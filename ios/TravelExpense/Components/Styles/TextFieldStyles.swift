import SwiftUI

// MARK: - Custom Text Field Style

/// カスタムテキストフィールドスタイル（半透明白背景）
struct CustomTextFieldStyle: TextFieldStyle {
    var backgroundColor: Color = .white.opacity(0.2)
    var foregroundColor: Color = .white
    var borderColor: Color = .white.opacity(0.3)
    var cornerRadius: CGFloat = 12

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .foregroundColor(foregroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Outlined Text Field Style

/// アウトラインテキストフィールドスタイル
struct OutlinedTextFieldStyle: TextFieldStyle {
    var borderColor: Color = Color.Theme.primaryRed
    var cornerRadius: CGFloat = 12

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Search Text Field Style

/// 検索用テキストフィールドスタイル
struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            configuration
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        TextField("Custom Style", text: .constant(""))
            .textFieldStyle(CustomTextFieldStyle())
            .padding()
            .background(Color.Theme.primaryRed)

        TextField("Outlined Style", text: .constant(""))
            .textFieldStyle(OutlinedTextFieldStyle())
            .padding()

        TextField("Search Style", text: .constant(""))
            .textFieldStyle(SearchTextFieldStyle())
            .padding()
    }
}
