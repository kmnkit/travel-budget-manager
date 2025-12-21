package com.travelexpense.ui.trip

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.travelexpense.data.model.Trip
import com.travelexpense.data.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.from
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.format.DateTimeFormatter

/**
 * 旅行フィルター
 */
enum class TripFilter(val title: String) {
    ALL("すべて"),
    UPCOMING("予定"),
    ONGOING("進行中"),
    PAST("過去")
}

/**
 * 旅行ソート
 */
enum class TripSort(val title: String) {
    DATE_DESC("日付が新しい順"),
    DATE_ASC("日付が古い順"),
    NAME("名前順"),
    BUDGET("予算順")
}

/**
 * 旅行一覧ViewModel
 */
class TripViewModel : ViewModel() {
    private val _trips = MutableStateFlow<List<Trip>>(emptyList())
    val trips: StateFlow<List<Trip>> = _trips.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage.asStateFlow()

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery.asStateFlow()

    private val _filter = MutableStateFlow(TripFilter.ALL)
    val filter: StateFlow<TripFilter> = _filter.asStateFlow()

    private val _sortBy = MutableStateFlow(TripSort.DATE_DESC)
    val sortBy: StateFlow<TripSort> = _sortBy.asStateFlow()

    // MARK: - Data Fetching

    /**
     * 旅行一覧を取得
     */
    fun fetchTrips() {
        val userId = SupabaseClient.currentUser()?.id ?: run {
            _errorMessage.value = "ユーザー情報の取得に失敗しました"
            return
        }

        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null

            try {
                val response = SupabaseClient.client
                    .from("trips")
                    .select()
                    .decodeList<Trip>()

                _trips.value = response.filter { it.userId == userId }
            } catch (e: Exception) {
                _errorMessage.value = "旅行の取得に失敗しました: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }

    /**
     * 旅行を削除
     */
    fun deleteTrip(trip: Trip) {
        viewModelScope.launch {
            try {
                SupabaseClient.client
                    .from("trips")
                    .delete {
                        filter {
                            eq("id", trip.id)
                        }
                    }

                _trips.value = _trips.value.filter { it.id != trip.id }
            } catch (e: Exception) {
                _errorMessage.value = "旅行の削除に失敗しました: ${e.message}"
            }
        }
    }

    // MARK: - Filtering & Sorting

    /**
     * フィルター・ソート済みの旅行一覧
     */
    val filteredAndSortedTrips: StateFlow<List<Trip>> = MutableStateFlow(emptyList()).apply {
        viewModelScope.launch {
            combine(
                _trips,
                _searchQuery,
                _filter,
                _sortBy
            ) { trips, query, filter, sort ->
                var result = trips

                // 検索フィルター
                if (query.isNotEmpty()) {
                    result = result.filter { trip ->
                        trip.name.contains(query, ignoreCase = true) ||
                        (trip.destination?.contains(query, ignoreCase = true) == true)
                    }
                }

                // 日付フィルター
                val today = LocalDate.now()
                result = result.filter { trip ->
                    val startDate = LocalDate.parse(trip.startDate, DateTimeFormatter.ISO_DATE_TIME)
                    val endDate = trip.endDate?.let { LocalDate.parse(it, DateTimeFormatter.ISO_DATE_TIME) }

                    when (filter) {
                        TripFilter.ALL -> true
                        TripFilter.UPCOMING -> startDate > today
                        TripFilter.ONGOING -> {
                            val end = endDate ?: startDate
                            startDate <= today && end >= today
                        }
                        TripFilter.PAST -> endDate?.let { it < today } ?: false
                    }
                }

                // ソート
                result = when (sort) {
                    TripSort.DATE_DESC -> result.sortedByDescending { it.startDate }
                    TripSort.DATE_ASC -> result.sortedBy { it.startDate }
                    TripSort.NAME -> result.sortedBy { it.name }
                    TripSort.BUDGET -> result.sortedByDescending { it.budget ?: 0.0 }
                }

                result
            }.collect { value = it }
        }
    }

    /**
     * 検索クエリ更新
     */
    fun onSearchQueryChange(query: String) {
        _searchQuery.value = query
    }

    /**
     * フィルター更新
     */
    fun onFilterChange(filter: TripFilter) {
        _filter.value = filter
    }

    /**
     * ソート更新
     */
    fun onSortChange(sort: TripSort) {
        _sortBy.value = sort
    }

    /**
     * フィルターをクリア
     */
    fun clearFilters() {
        _searchQuery.value = ""
        _filter.value = TripFilter.ALL
        _sortBy.value = TripSort.DATE_DESC
    }

    /**
     * フィルターがアクティブか
     */
    val hasActiveFilters: StateFlow<Boolean> = MutableStateFlow(false).apply {
        viewModelScope.launch {
            combine(
                _searchQuery,
                _filter,
                _sortBy
            ) { query, filter, sort ->
                query.isNotEmpty() || filter != TripFilter.ALL || sort != TripSort.DATE_DESC
            }.collect { value = it }
        }
    }
}

// Combine helper
private fun <T1, T2, T3, T4, R> combine(
    flow1: StateFlow<T1>,
    flow2: StateFlow<T2>,
    flow3: StateFlow<T3>,
    flow4: StateFlow<T4>,
    transform: (T1, T2, T3, T4) -> R
): kotlinx.coroutines.flow.Flow<R> = kotlinx.coroutines.flow.combine(flow1, flow2, flow3, flow4) { a, b, c, d ->
    transform(a, b, c, d)
}
