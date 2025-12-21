import Foundation

/// アプリケーション設定を管理する構造体
/// xcconfigファイルからInfo.plistを経由して設定を読み込みます
enum AppConfiguration {

    // MARK: - Configuration Errors

    enum ConfigurationError: LocalizedError {
        case missingValue(key: String)
        case invalidURL(key: String)

        var errorDescription: String? {
            switch self {
            case .missingValue(let key):
                return "設定が見つかりません: \(key)。xcconfigファイルを確認してください。"
            case .invalidURL(let key):
                return "無効なURL形式: \(key)"
            }
        }
    }

    // MARK: - Supabase Configuration

    /// Supabase プロジェクトURL
    /// - Throws: ConfigurationError if value is missing or invalid
    static var supabaseURL: URL {
        get throws {
            guard let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
                  !urlString.isEmpty,
                  !urlString.contains("your-project") else {
                throw ConfigurationError.missingValue(key: "SUPABASE_URL")
            }

            guard let url = URL(string: urlString) else {
                throw ConfigurationError.invalidURL(key: "SUPABASE_URL")
            }

            return url
        }
    }

    /// Supabase 匿名キー（公開用）
    /// - Throws: ConfigurationError if value is missing
    static var supabaseAnonKey: String {
        get throws {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
                  !key.isEmpty,
                  !key.contains("your-") else {
                throw ConfigurationError.missingValue(key: "SUPABASE_ANON_KEY")
            }

            return key
        }
    }

    // MARK: - Validation

    /// 設定が正しく読み込まれているか検証
    /// - Returns: true if all required configurations are valid
    static func validate() -> Result<Void, ConfigurationError> {
        do {
            _ = try supabaseURL
            _ = try supabaseAnonKey
            return .success(())
        } catch let error as ConfigurationError {
            return .failure(error)
        } catch {
            return .failure(.missingValue(key: "Unknown"))
        }
    }

    // MARK: - Debug Information

    #if DEBUG
    /// デバッグ用: 設定状態を出力
    static func printConfigurationStatus() {
        print("=== App Configuration Status ===")

        if let url = try? supabaseURL {
            print("Supabase URL: \(url.host ?? "unknown")")
        } else {
            print("Supabase URL: NOT CONFIGURED")
        }

        if let key = try? supabaseAnonKey {
            let maskedKey = String(key.prefix(10)) + "..."
            print("Supabase Key: \(maskedKey)")
        } else {
            print("Supabase Key: NOT CONFIGURED")
        }

        print("================================")
    }
    #endif
}
