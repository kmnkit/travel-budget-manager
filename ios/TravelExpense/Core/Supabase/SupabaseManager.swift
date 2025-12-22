import Foundation
import Supabase

/// Supabaseクライアントのシングルトンマネージャー
/// xconfigファイル経由でInfo.plistから設定を読み込みます
///
/// 設定手順:
/// 1. Config/Debug.xcconfig と Config/Release.xcconfig を編集
/// 2. SUPABASE_URL と SUPABASE_ANON_KEY を設定
/// 3. Xcode プロジェクト設定で xcconfig を参照
class SupabaseManager {
    static let shared = SupabaseManager()

    /// Supabaseクライアント（設定エラー時はnil）
    private(set) var client: SupabaseClient?

    /// 設定エラー（設定が不正な場合に設定される）
    private(set) var configurationError: Error?

    /// クライアントが正しく初期化されているか
    var isConfigured: Bool {
        client != nil
    }

    private init() {
        do {
            let supabaseURL = try AppConfiguration.supabaseURL
            let supabaseKey = try AppConfiguration.supabaseAnonKey

            // カスタムURLSessionConfigurationを作成（接続問題の回避）
            let configuration = URLSessionConfiguration.default
            configuration.httpShouldUsePipelining = false
            configuration.httpMaximumConnectionsPerHost = 2 // 改善: 1から2に増加
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 60
            configuration.waitsForConnectivity = true
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

            client = SupabaseClient(
                supabaseURL: supabaseURL,
                supabaseKey: supabaseKey,
                options: SupabaseClientOptions(
                    global: SupabaseClientOptions.GlobalOptions(
                        session: URLSession(configuration: configuration)
                    )
                )
            )

            #if DEBUG
            AppConfiguration.printConfigurationStatus()
            #endif
        } catch {
            configurationError = error
            client = nil
            print("SupabaseManager initialization failed: \(error.localizedDescription)")
        }
    }

    /// 設定済みのクライアントを取得（未設定時はエラーをスロー）
    /// - Returns: SupabaseClient
    /// - Throws: 設定エラー
    func getClient() throws -> SupabaseClient {
        if let client = client {
            return client
        }
        throw configurationError ?? AppConfiguration.ConfigurationError.missingValue(key: "Supabase")
    }

    // MARK: - Auth

    /// ログイン（リトライロジック付き）
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    /// - Returns: ログインしたユーザー
    /// - Throws: 認証エラーまたは設定エラー
    func signIn(email: String, password: String) async throws -> User {
        let supabaseClient = try getClient()
        return try await withRetry {
            let session = try await supabaseClient.auth.signIn(
                email: email,
                password: password
            )
            return session.user
        }
    }

    /// サインアップ（リトライロジック付き）
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    /// - Returns: 作成されたユーザー
    /// - Throws: 認証エラーまたは設定エラー
    func signUp(email: String, password: String) async throws -> User {
        let supabaseClient = try getClient()
        return try await withRetry {
            let session = try await supabaseClient.auth.signUp(
                email: email,
                password: password
            )
            return session.user
        }
    }

    /// ログアウト
    /// - Throws: ログアウトエラーまたは設定エラー
    func signOut() async throws {
        let supabaseClient = try getClient()
        try await supabaseClient.auth.signOut()
    }

    /// 現在のユーザー取得
    var currentUser: User? {
        client?.auth.currentUser
    }

    /// セッション監視（正しい型を返す）
    /// - Returns: 認証状態変更のAsyncStream（未設定時は空のストリーム）
    func observeAuthStateChanges() -> AsyncStream<(event: AuthChangeEvent, session: Session?)> {
        guard let supabaseClient = client else {
            // 設定エラー時は空のストリームを返す
            return AsyncStream { continuation in
                continuation.finish()
            }
        }
        return supabaseClient.auth.authStateChanges
    }

    // MARK: - Private Helpers

    /// リトライロジック（-1005エラー時に最大3回リトライ）
    private func withRetry<T>(
        maxRetries: Int = 3,
        operation: @escaping () async throws -> T
    ) async throws -> T {
        var lastError: Error?

        for attempt in 1...maxRetries {
            do {
                // リトライ間の待機（最初の試行はすぐ実行）
                if attempt > 1 {
                    try await Task.sleep(nanoseconds: UInt64(attempt) * 500_000_000)
                }
                return try await operation()
            } catch let error as NSError {
                lastError = error
                // ネットワーク接続エラー（-1005）の場合のみリトライ
                if error.domain == NSURLErrorDomain && error.code == -1005 {
                    print("Attempt \(attempt) failed with connection error, retrying...")
                    continue
                }
                throw error
            } catch {
                throw error
            }
        }

        throw lastError ?? NSError(
            domain: "SupabaseManager",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "操作に失敗しました"]
        )
    }
}
