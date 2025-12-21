package com.travelexpense.ui.trip

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.travelexpense.data.model.Trip
import java.time.LocalDate
import java.time.format.DateTimeFormatter

/**
 * 旅行一覧画面
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun TripListScreen(
    viewModel: TripViewModel = viewModel()
) {
    val trips by viewModel.filteredAndSortedTrips.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val searchQuery by viewModel.searchQuery.collectAsState()
    val filter by viewModel.filter.collectAsState()
    val hasActiveFilters by viewModel.hasActiveFilters.collectAsState()

    LaunchedEffect(Unit) {
        viewModel.fetchTrips()
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("マイトリップ") },
                actions = {
                    IconButton(onClick = { /* TODO: Add trip */ }) {
                        Icon(
                            imageVector = Icons.Default.Add,
                            contentDescription = "新しい旅行",
                            tint = Color(0xFFE63946)
                        )
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // 検索バー
            SearchBar(
                query = searchQuery,
                onQueryChange = { viewModel.onSearchQueryChange(it) },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp)
            )

            // フィルター
            FilterBar(
                selectedFilter = filter,
                onFilterChange = { viewModel.onFilterChange(it) },
                onClearFilters = { viewModel.clearFilters() },
                hasActiveFilters = hasActiveFilters
            )

            // 旅行リスト
            if (isLoading) {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator()
                }
            } else if (trips.isEmpty()) {
                EmptyState(
                    hasActiveFilters = hasActiveFilters,
                    onClearFilters = { viewModel.clearFilters() }
                )
            } else {
                TripList(trips = trips)
            }
        }
    }
}

@Composable
fun SearchBar(
    query: String,
    onQueryChange: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = query,
        onValueChange = onQueryChange,
        modifier = modifier,
        placeholder = { Text("旅行名や目的地で検索...") },
        leadingIcon = {
            Icon(
                imageVector = Icons.Default.Search,
                contentDescription = "検索"
            )
        },
        singleLine = true,
        shape = MaterialTheme.shapes.medium
    )
}

@Composable
fun FilterBar(
    selectedFilter: TripFilter,
    onFilterChange: (TripFilter) -> Unit,
    onClearFilters: () -> Unit,
    hasActiveFilters: Boolean
) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp, vertical = 8.dp)
    ) {
        // フィルターボタン
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            TripFilter.values().forEach { filter ->
                FilterChip(
                    selected = selectedFilter == filter,
                    onClick = { onFilterChange(filter) },
                    label = { Text(filter.title) },
                    modifier = Modifier.weight(1f)
                )
            }
        }

        // クリアボタン
        if (hasActiveFilters) {
            TextButton(
                onClick = onClearFilters,
                modifier = Modifier.align(Alignment.End)
            ) {
                Text(
                    text = "フィルターをクリア",
                    color = Color(0xFFE63946),
                    fontSize = 12.sp
                )
            }
        }
    }
}

@Composable
fun TripList(trips: List<Trip>) {
    LazyColumn(
        contentPadding = PaddingValues(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        items(trips) { trip ->
            TripCard(trip = trip)
        }
    }
}

@Composable
fun TripCard(trip: Trip) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp)
        ) {
            // ヘッダー
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = trip.name,
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold
                    )

                    trip.destination?.let { destination ->
                        Row(
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.padding(top = 4.dp)
                        ) {
                            Text(
                                text = "📍 $destination",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                    }
                }

                TripStatusBadge(trip = trip)
            }

            Divider(modifier = Modifier.padding(vertical = 12.dp))

            // 日付・予算
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                val startDate = try {
                    LocalDate.parse(trip.startDate, DateTimeFormatter.ISO_DATE_TIME)
                        .format(DateTimeFormatter.ofPattern("yyyy/MM/dd"))
                } catch (e: Exception) {
                    trip.startDate
                }

                Text(
                    text = "📅 $startDate",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )

                trip.budget?.let { budget ->
                    Text(
                        text = "${trip.currency} ${budget.toInt()}",
                        style = MaterialTheme.typography.bodySmall,
                        color = Color(0xFFE63946),
                        fontWeight = FontWeight.Medium
                    )
                }
            }
        }
    }
}

@Composable
fun TripStatusBadge(trip: Trip) {
    val (status, color) = remember(trip) {
        val today = LocalDate.now()
        val startDate = LocalDate.parse(trip.startDate, DateTimeFormatter.ISO_DATE_TIME)
        val endDate = trip.endDate?.let { LocalDate.parse(it, DateTimeFormatter.ISO_DATE_TIME) }

        when {
            startDate > today -> "予定" to Color(0xFF2196F3)
            endDate?.let { it < today } == true -> "過去" to Color(0xFF9E9E9E)
            else -> "進行中" to Color(0xFF06D6A0)
        }
    }

    Surface(
        color = color.copy(alpha = 0.2f),
        shape = MaterialTheme.shapes.small
    ) {
        Text(
            text = status,
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
            style = MaterialTheme.typography.labelSmall,
            color = color,
            fontWeight = FontWeight.Medium
        )
    }
}

@Composable
fun EmptyState(
    hasActiveFilters: Boolean,
    onClearFilters: () -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(32.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "✈️",
            fontSize = 60.sp
        )

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = if (hasActiveFilters) "条件に一致する旅行が見つかりません" else "旅行がまだありません",
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )

        Spacer(modifier = Modifier.height(8.dp))

        Text(
            text = if (hasActiveFilters) "フィルターを変更するか、新しい旅行を作成してください" else "新しい旅行を作成して支出の記録を始めましょう",
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )

        Spacer(modifier = Modifier.height(24.dp))

        if (hasActiveFilters) {
            OutlinedButton(onClick = onClearFilters) {
                Text("フィルターをクリア")
            }
        } else {
            Button(
                onClick = { /* TODO: Add trip */ },
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color(0xFFE63946)
                )
            ) {
                Icon(imageVector = Icons.Default.Add, contentDescription = null)
                Spacer(modifier = Modifier.width(8.dp))
                Text("最初の旅行を作成")
            }
        }
    }
}
