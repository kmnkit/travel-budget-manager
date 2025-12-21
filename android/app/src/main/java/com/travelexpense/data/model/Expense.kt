package com.travelexpense.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * 支出モデル
 */
@Serializable
data class Expense(
    val id: String,
    @SerialName("trip_id")
    val tripId: String,
    @SerialName("category_id")
    val categoryId: String? = null,
    val amount: Double,
    val currency: String,
    val description: String? = null,
    val notes: String? = null,
    @SerialName("expense_date")
    val expenseDate: String,
    val location: String? = null,
    @SerialName("payment_method")
    val paymentMethod: String? = null,
    val metadata: ExpenseMetadata? = null,
    @SerialName("created_at")
    val createdAt: String
)

/**
 * 支出メタデータ（ICカード取引情報など）
 */
@Serializable
data class ExpenseMetadata(
    @SerialName("ic_card_transaction")
    val icCardTransaction: ICCardTransaction? = null
)

/**
 * ICカード取引情報
 */
@Serializable
data class ICCardTransaction(
    @SerialName("entry_code")
    val entryCode: Int,
    @SerialName("exit_code")
    val exitCode: Int,
    val balance: Int,
    @SerialName("card_type")
    val cardType: String,
    @SerialName("raw_data")
    val rawData: String? = null
)

/**
 * 支出作成用リクエスト
 */
@Serializable
data class CreateExpenseRequest(
    @SerialName("trip_id")
    val tripId: String,
    @SerialName("category_id")
    val categoryId: String? = null,
    val amount: Double,
    val currency: String,
    val description: String? = null,
    val notes: String? = null,
    @SerialName("expense_date")
    val expenseDate: String,
    val location: String? = null,
    @SerialName("payment_method")
    val paymentMethod: String? = null,
    val metadata: ExpenseMetadata? = null
)
