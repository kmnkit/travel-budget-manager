import Foundation
import Combine
import Supabase

/// 認証状態
enum AuthState: Equatable {
    case loading
    case authenticated(User)
    case unauthenticated
    case error(String)

    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.authenticated(let lUser), .authenticated(let rUser)):
            return lUser.id == rUser.id
        case (.unauthenticated, .unauthenticated):
            return true
        case (.error(let lError), .error(let rError)):
            return lError == rError
        default:
            return false
        }
    }
}

/// 認証ViewModel（アプリ全体で共有）
@MainActor
class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .loading
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    private let supabase = SupabaseManager.shared
    private var authTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthStatus()
        observeAuthChanges()
    }

    deinit {
        authTask?.cancel()
    }

    // MARK: - Auth Status

    /// 認証状態をチェック
    func checkAuthStatus() {
        if let user = supabase.currentUser {
            authState = .authenticated(user)
        } else {
            authState = .unauthenticated
        }
    }

    /// 認証状態の変更を監視
    private func observeAuthChanges() {
        authTask?.cancel()
        authTask = Task { [weak self] in
            guard let self = self else { return }

            for await (event, session) in self.supabase.observeAuthStateChanges() {
                guard !Task.isCancelled else { break }

                switch event {
                case .signedIn:
                    if let user = session?.user {
                        self.authState = .authenticated(user)
                    } else {
                        self.checkAuthStatus()
                    }
                case .signedOut:
                    self.authState = .unauthenticated
                case .tokenRefreshed:
                    if let user = session?.user {
                        self.authState = .authenticated(user)
                    }
                default:
                    break
                }
            }
        }
    }

    // MARK: - Validation

    /// メールアドレスの形式を検証
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }

    /// 入力バリデーション
    private func validateInput(requireStrongPassword: Bool = false) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください"
            return false
        }

        guard isValidEmail(email) else {
            errorMessage = "有効なメールアドレスを入力してください"
            return false
        }

        if requireStrongPassword {
            guard password.count >= 6 else {
                errorMessage = "パスワードは6文字以上で入力してください"
                return false
            }
        }

        return true
    }

    // MARK: - Actions

    /// ログイン
    func signIn() async {
        guard validateInput() else { return }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await supabase.signIn(email: email, password: password)
            authState = .authenticated(user)
            clearForm()
        } catch {
            errorMessage = "ログインに失敗しました: \(error.localizedDescription)"
            authState = .error(error.localizedDescription)
        }

        isLoading = false
    }

    /// サインアップ
    func signUp() async {
        guard validateInput(requireStrongPassword: true) else { return }

        isLoading = true
        errorMessage = nil
        successMessage = nil

        do {
            let user = try await supabase.signUp(email: email, password: password)

            // メール確認が必要な場合はメッセージを表示
            if user.emailConfirmedAt == nil {
                successMessage = "登録が完了しました。メールアドレスに送信された確認リンクをクリックしてください。"
            } else {
                authState = .authenticated(user)
                clearForm()
            }
        } catch {
            errorMessage = "サインアップに失敗しました: \(error.localizedDescription)"
            authState = .error(error.localizedDescription)
        }

        isLoading = false
    }

    /// ログアウト
    func signOut() async {
        isLoading = true
        errorMessage = nil

        do {
            try await supabase.signOut()
            authState = .unauthenticated
            clearForm()
        } catch {
            errorMessage = "ログアウトに失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// フォームをクリア
    func clearForm() {
        email = ""
        password = ""
        errorMessage = nil
        successMessage = nil
    }
}
