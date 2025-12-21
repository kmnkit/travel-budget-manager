import Foundation

/// 支出モデル
struct Expense: Codable, Identifiable {
    let id: String
    let tripId: String
    let categoryId: String?
    let amount: Double
    let currency: String
    let description: String?
    let notes: String?
    let expenseDate: Date
    let location: String?
    let paymentMethod: String?
    let metadata: ExpenseMetadata?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case tripId = "trip_id"
        case categoryId = "category_id"
        case amount
        case currency
        case description
        case notes
        case expenseDate = "expense_date"
        case location
        case paymentMethod = "payment_method"
        case metadata
        case createdAt = "created_at"
    }
}

/// 支出メタデータ（ICカード取引情報など）
struct ExpenseMetadata: Codable {
    let icCardTransaction: ICCardTransaction?

    enum CodingKeys: String, CodingKey {
        case icCardTransaction = "ic_card_transaction"
    }
}

/// ICカード取引情報
struct ICCardTransaction: Codable {
    let entryCode: Int
    let exitCode: Int
    let balance: Int
    let cardType: String
    let rawData: String?

    enum CodingKeys: String, CodingKey {
        case entryCode = "entry_code"
        case exitCode = "exit_code"
        case balance
        case cardType = "card_type"
        case rawData = "raw_data"
    }
}

/// 支出作成用リクエスト
struct CreateExpenseRequest: Codable {
    let tripId: String
    let categoryId: String?
    let amount: Double
    let currency: String
    let description: String?
    let notes: String?
    let expenseDate: Date
    let location: String?
    let paymentMethod: String?
    let metadata: ExpenseMetadata?

    enum CodingKeys: String, CodingKey {
        case tripId = "trip_id"
        case categoryId = "category_id"
        case amount
        case currency
        case description
        case notes
        case expenseDate = "expense_date"
        case location
        case paymentMethod = "payment_method"
        case metadata
    }
}

/// 支出更新用リクエスト
struct UpdateExpenseRequest: Codable {
    let categoryId: String?
    let amount: Double?
    let currency: String?
    let description: String?
    let notes: String?
    let expenseDate: Date?
    let location: String?
    let paymentMethod: String?

    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case amount
        case currency
        case description
        case notes
        case expenseDate = "expense_date"
        case location
        case paymentMethod = "payment_method"
    }
}
