import Foundation
import Combine
import Supabase

/// 認証状態
enum AuthState {
    case loading
    case authenticated(User)
    case unauthenticated
    case error(Error)
}

/// 認証ViewModel
@MainActor
class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .loading
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let supabase = SupabaseManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        checkAuthStatus()
        observeAuthChanges()
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
        Task {
            for await event in supabase.observeAuthStateChanges() {
                switch event {
                case .signedIn(let session):
                    authState = .authenticated(session.user)
                case .signedOut:
                    authState = .unauthenticated
                default:
                    break
                }
            }
        }
    }

    // MARK: - Actions

    /// ログイン
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await supabase.signIn(email: email, password: password)
            authState = .authenticated(user)
        } catch {
            errorMessage = "ログインに失敗しました: \(error.localizedDescription)"
            authState = .error(error)
        }

        isLoading = false
    }

    /// サインアップ
    func signUp() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "メールアドレスとパスワードを入力してください"
            return
        }

        guard password.count >= 6 else {
            errorMessage = "パスワードは6文字以上で入力してください"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await supabase.signUp(email: email, password: password)
            authState = .authenticated(user)
        } catch {
            errorMessage = "サインアップに失敗しました: \(error.localizedDescription)"
            authState = .error(error)
        }

        isLoading = false
    }

    /// ログアウト
    func signOut() async {
        isLoading = true

        do {
            try await supabase.signOut()
            authState = .unauthenticated
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
    }
}
