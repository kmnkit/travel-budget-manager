import Foundation

/// 旅行モデル
struct Trip: Codable, Identifiable {
    let id: String
    let userId: String
    let name: String
    let destination: String?
    let startDate: Date
    let endDate: Date?
    let budget: Double?
    let currency: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case budget
        case currency
        case createdAt = "created_at"
    }
}

/// 旅行作成用リクエスト
struct CreateTripRequest: Codable {
    let userId: String
    let name: String
    let destination: String?
    let startDate: Date
    let endDate: Date?
    let budget: Double?
    let currency: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case budget
        case currency
    }
}

/// 旅行更新用リクエスト
struct UpdateTripRequest: Codable {
    let name: String?
    let destination: String?
    let startDate: Date?
    let endDate: Date?
    let budget: Double?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case name
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case budget
        case currency
    }
}
