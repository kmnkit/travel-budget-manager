import SwiftUI

// MARK: - Primary Button Style

/// プライマリボタンスタイル（白背景・赤文字）
struct PrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color = .white
    var foregroundColor: Color = Color.Theme.primaryRed

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style

/// セカンダリボタンスタイル（アウトライン）
struct SecondaryButtonStyle: ButtonStyle {
    var borderColor: Color = Color.Theme.primaryRed
    var foregroundColor: Color = Color.Theme.primaryRed

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.white)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Destructive Button Style

/// 削除ボタンスタイル（赤背景）
struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.Theme.primaryRed)
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Icon Button Style

/// アイコンボタンスタイル
struct IconButtonStyle: ButtonStyle {
    var size: CGFloat = 44
    var backgroundColor: Color = Color(.systemGray6)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Button("Primary Button") {}
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal)

        Button("Secondary Button") {}
            .buttonStyle(SecondaryButtonStyle())
            .padding(.horizontal)

        Button("Destructive Button") {}
            .buttonStyle(DestructiveButtonStyle())
            .padding(.horizontal)

        Button {
        } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(IconButtonStyle())
    }
    .padding()
}
