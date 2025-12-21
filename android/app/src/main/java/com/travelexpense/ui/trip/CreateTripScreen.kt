package com.travelexpense.ui.trip

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Close
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.travelexpense.data.model.CreateTripRequest
import com.travelexpense.data.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.from
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.format.DateTimeFormatter

/**
 * 旅行作成画面
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CreateTripScreen(
    viewModel: CreateTripViewModel = androidx.lifecycle.viewmodel.compose.viewModel(),
    onDismiss: () -> Unit = {}
) {
    val name by viewModel.name.collectAsState()
    val destination by viewModel.destination.collectAsState()
    val startDate by viewModel.startDate.collectAsState()
    val endDate by viewModel.endDate.collectAsState()
    val budget by viewModel.budget.collectAsState()
    val currency by viewModel.currency.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("新しい旅行") },
                navigationIcon = {
                    IconButton(onClick = onDismiss) {
                        Icon(Icons.Default.Close, "閉じる")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // 旅行名
            OutlinedTextField(
                value = name,
                onValueChange = { viewModel.onNameChange(it) },
                label = { Text("旅行名") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // 目的地
            OutlinedTextField(
                value = destination,
                onValueChange = { viewModel.onDestinationChange(it) },
                label = { Text("目的地") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // 開始日
            Text("開始日: $startDate", style = MaterialTheme.typography.bodyLarge)

            // 終了日
            Text("終了日: $endDate", style = MaterialTheme.typography.bodyLarge)

            // 予算
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedTextField(
                    value = budget,
                    onValueChange = { viewModel.onBudgetChange(it) },
                    label = { Text("予算") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true
                )

                // 通貨選択
                var expanded by remember { mutableStateOf(false) }
                ExposedDropdownMenuBox(
                    expanded = expanded,
                    onExpandedChange = { expanded = !expanded },
                    modifier = Modifier.width(120.dp)
                ) {
                    OutlinedTextField(
                        value = currency,
                        onValueChange = {},
                        readOnly = true,
                        label = { Text("通貨") },
                        trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded) },
                        modifier = Modifier.menuAnchor()
                    )

                    ExposedDropdownMenu(
                        expanded = expanded,
                        onDismissRequest = { expanded = false }
                    ) {
                        listOf("JPY", "USD", "EUR", "GBP").forEach { curr ->
                            DropdownMenuItem(
                                text = { Text(curr) },
                                onClick = {
                                    viewModel.onCurrencyChange(curr)
                                    expanded = false
                                }
                            )
                        }
                    }
                }
            }

            // エラーメッセージ
            errorMessage?.let {
                Text(
                    text = it,
                    color = MaterialTheme.colorScheme.error,
                    style = MaterialTheme.typography.bodySmall
                )
            }

            Spacer(modifier = Modifier.weight(1f))

            // 作成ボタン
            Button(
                onClick = {
                    viewModel.createTrip {
                        onDismiss()
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading && name.isNotEmpty()
            ) {
                if (isLoading) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(24.dp),
                        color = MaterialTheme.colorScheme.onPrimary
                    )
                } else {
                    Text("作成")
                }
            }
        }
    }
}

/**
 * 旅行作成ViewModel
 */
class CreateTripViewModel : ViewModel() {
    private val _name = MutableStateFlow("")
    val name: StateFlow<String> = _name.asStateFlow()

    private val _destination = MutableStateFlow("")
    val destination: StateFlow<String> = _destination.asStateFlow()

    private val _startDate = MutableStateFlow(LocalDate.now().toString())
    val startDate: StateFlow<String> = _startDate.asStateFlow()

    private val _endDate = MutableStateFlow(LocalDate.now().plusWeeks(1).toString())
    val endDate: StateFlow<String> = _endDate.asStateFlow()

    private val _budget = MutableStateFlow("")
    val budget: StateFlow<String> = _budget.asStateFlow()

    private val _currency = MutableStateFlow("JPY")
    val currency: StateFlow<String> = _currency.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage.asStateFlow()

    fun onNameChange(newName: String) {
        _name.value = newName
    }

    fun onDestinationChange(newDestination: String) {
        _destination.value = newDestination
    }

    fun onBudgetChange(newBudget: String) {
        _budget.value = newBudget
    }

    fun onCurrencyChange(newCurrency: String) {
        _currency.value = newCurrency
    }

    fun createTrip(onSuccess: () -> Unit) {
        if (_name.value.isEmpty()) {
            _errorMessage.value = "旅行名を入力してください"
            return
        }

        val userId = SupabaseClient.currentUser()?.id ?: run {
            _errorMessage.value = "ユーザー情報の取得に失敗しました"
            return
        }

        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null

            try {
                val newTrip = CreateTripRequest(
                    userId = userId,
                    name = _name.value,
                    destination = _destination.value.ifEmpty { null },
                    startDate = _startDate.value,
                    endDate = _endDate.value,
                    budget = _budget.value.toDoubleOrNull(),
                    currency = _currency.value
                )

                SupabaseClient.client
                    .from("trips")
                    .insert(newTrip)

                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = "旅行の作成に失敗しました: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }
}
