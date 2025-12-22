import SwiftUI

// MARK: - Color Extension for Hex Values

extension Color {
    /// 16進数の文字列からColorを初期化
    /// - Parameter hex: 16進数カラーコード（例: "E63946"）
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - App Theme Colors

extension Color {
    /// アプリのテーマカラー
    enum Theme {
        /// メインレッド: #E63946
        static let primaryRed = Color(hex: "E63946")

        /// ダークレッド: #C1121F
        static let darkRed = Color(hex: "C1121F")

        /// ライトレッド: #F8B4B4
        static let lightRed = Color(hex: "F8B4B4")

        /// アクセントゴールド: #FFB703
        static let accentGold = Color(hex: "FFB703")

        /// アクセントグリーン: #06D6A0
        static let accentGreen = Color(hex: "06D6A0")

        /// 背景グラデーション
        static var backgroundGradient: LinearGradient {
            LinearGradient(
                colors: [primaryRed, darkRed],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
