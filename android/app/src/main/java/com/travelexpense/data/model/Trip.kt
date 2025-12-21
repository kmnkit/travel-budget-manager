package com.travelexpense.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import java.time.LocalDate
import java.time.LocalDateTime

/**
 * 旅行モデル
 */
@Serializable
data class Trip(
    val id: String,
    @SerialName("user_id")
    val userId: String,
    val name: String,
    val destination: String? = null,
    @SerialName("start_date")
    val startDate: String, // ISO 8601 format
    @SerialName("end_date")
    val endDate: String? = null,
    val budget: Double? = null,
    val currency: String,
    @SerialName("created_at")
    val createdAt: String
)

/**
 * 旅行作成用リクエスト
 */
@Serializable
data class CreateTripRequest(
    @SerialName("user_id")
    val userId: String,
    val name: String,
    val destination: String? = null,
    @SerialName("start_date")
    val startDate: String,
    @SerialName("end_date")
    val endDate: String? = null,
    val budget: Double? = null,
    val currency: String
)

/**
 * 旅行更新用リクエスト
 */
@Serializable
data class UpdateTripRequest(
    val name: String? = null,
    val destination: String? = null,
    @SerialName("start_date")
    val startDate: String? = null,
    @SerialName("end_date")
    val endDate: String? = null,
    val budget: Double? = null,
    val currency: String? = null
)
