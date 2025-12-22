import SwiftUI

/// ログイン画面
struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showSignUp = false

    var body: some View {
        NavigationView {
            ZStack {
                // 背景グラデーション
                LinearGradient(
                    colors: [Color(hex: "E63946"), Color(hex: "C1121F")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    // ロゴ・タイトル
                    VStack(spacing: 12) {
                        Image(systemName: "airplane.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)

                        Text("Travel Expense Tracker")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("旅行支出を簡単に記録・管理")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.bottom, 32)

                    // フォーム
                    VStack(spacing: 16) {
                        // メールアドレス
                        TextField("メールアドレス", text: $viewModel.email)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)

                        // パスワード
                        SecureField("パスワード", text: $viewModel.password)
                            .textFieldStyle(CustomTextFieldStyle())
                            .textContentType(.password)

                        // エラーメッセージ
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .multilineTextAlignment(.center)
                        }

                        // ログインボタン
                        Button(action: {
                            Task {
                                await viewModel.signIn()
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("ログイン")
                                    .fontWeight(.semibold)
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .disabled(viewModel.isLoading)

                        // サインアップリンク
                        Button(action: {
                            viewModel.clearForm()
                            showSignUp = true
                        }) {
                            Text("アカウントをお持ちでない方はこちら")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .underline()
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 32)

                    Spacer()
                }
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
            }
        }
    }
}

// MARK: - Custom Styles

/// カスタムテキストフィールドスタイル
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

/// プライマリボタンスタイル
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .foregroundColor(Color(hex: "E63946"))
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
