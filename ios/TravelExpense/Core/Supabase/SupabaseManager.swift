import Foundation
import Supabase

/// Supabaseクライアントのシングルトンマネージャー
class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        // Info.plistから設定を読み込む
        guard let url = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              let supabaseURL = URL(string: url) else {
            fatalError("Supabase configuration missing in Info.plist")
        }

        client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: key
        )
    }

    // MARK: - Auth

    /// ログイン
    func signIn(email: String, password: String) async throws -> User {
        let session = try await client.auth.signIn(
            email: email,
            password: password
        )
        return session.user
    }

    /// サインアップ
    func signUp(email: String, password: String) async throws -> User {
        let session = try await client.auth.signUp(
            email: email,
            password: password
        )
        return session.user
    }

    /// ログアウト
    func signOut() async throws {
        try await client.auth.signOut()
    }

    /// 現在のユーザー取得
    var currentUser: User? {
        client.auth.currentUser
    }

    /// セッション監視
    func observeAuthStateChanges() -> AsyncStream<(event: AuthChangeEvent, session: Session?)> {
        client.auth.authStateChanges
    }
}
