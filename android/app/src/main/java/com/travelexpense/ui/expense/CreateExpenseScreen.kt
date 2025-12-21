package com.travelexpense.ui.expense

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
import com.travelexpense.data.model.CreateExpenseRequest
import com.travelexpense.data.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.from
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.time.LocalDate

/**
 * 支出作成画面
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CreateExpenseScreen(
    tripId: String,
    viewModel: CreateExpenseViewModel = androidx.lifecycle.viewmodel.compose.viewModel(
        factory = CreateExpenseViewModelFactory(tripId)
    ),
    onDismiss: () -> Unit = {}
) {
    val description by viewModel.description.collectAsState()
    val amount by viewModel.amount.collectAsState()
    val currency by viewModel.currency.collectAsState()
    val location by viewModel.location.collectAsState()
    val paymentMethod by viewModel.paymentMethod.collectAsState()
    val notes by viewModel.notes.collectAsState()
    val isLoading by viewModel.isLoading.collectAsState()
    val errorMessage by viewModel.errorMessage.collectAsState()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("支出を追加") },
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
            // 説明
            OutlinedTextField(
                value = description,
                onValueChange = { viewModel.onDescriptionChange(it) },
                label = { Text("説明") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // 金額・通貨
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                OutlinedTextField(
                    value = amount,
                    onValueChange = { viewModel.onAmountChange(it) },
                    label = { Text("金額") },
                    modifier = Modifier.weight(1f),
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    singleLine = true
                )

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
                        listOf("JPY", "USD", "EUR").forEach { curr ->
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

            // 場所
            OutlinedTextField(
                value = location,
                onValueChange = { viewModel.onLocationChange(it) },
                label = { Text("場所（オプション）") },
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            // 支払い方法
            var paymentExpanded by remember { mutableStateOf(false) }
            ExposedDropdownMenuBox(
                expanded = paymentExpanded,
                onExpandedChange = { paymentExpanded = !paymentExpanded }
            ) {
                OutlinedTextField(
                    value = paymentMethod,
                    onValueChange = {},
                    readOnly = true,
                    label = { Text("支払い方法（オプション）") },
                    trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(paymentExpanded) },
                    modifier = Modifier
                        .fillMaxWidth()
                        .menuAnchor()
                )

                ExposedDropdownMenu(
                    expanded = paymentExpanded,
                    onDismissRequest = { paymentExpanded = false }
                ) {
                    listOf("現金", "クレジットカード", "デビットカード", "ICカード").forEach { method ->
                        DropdownMenuItem(
                            text = { Text(method) },
                            onClick = {
                                viewModel.onPaymentMethodChange(method)
                                paymentExpanded = false
                            }
                        )
                    }
                }
            }

            // メモ
            OutlinedTextField(
                value = notes,
                onValueChange = { viewModel.onNotesChange(it) },
                label = { Text("メモ（オプション）") },
                modifier = Modifier.fillMaxWidth(),
                minLines = 3,
                maxLines = 5
            )

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
                    viewModel.createExpense {
                        onDismiss()
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                enabled = !isLoading && amount.toDoubleOrNull() != null && amount.toDouble() > 0
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
 * 支出作成ViewModel
 */
class CreateExpenseViewModel(private val tripId: String) : ViewModel() {
    private val _description = MutableStateFlow("")
    val description: StateFlow<String> = _description.asStateFlow()

    private val _amount = MutableStateFlow("")
    val amount: StateFlow<String> = _amount.asStateFlow()

    private val _currency = MutableStateFlow("JPY")
    val currency: StateFlow<String> = _currency.asStateFlow()

    private val _location = MutableStateFlow("")
    val location: StateFlow<String> = _location.asStateFlow()

    private val _paymentMethod = MutableStateFlow("")
    val paymentMethod: StateFlow<String> = _paymentMethod.asStateFlow()

    private val _notes = MutableStateFlow("")
    val notes: StateFlow<String> = _notes.asStateFlow()

    private val _isLoading = MutableStateFlow(false)
    val isLoading: StateFlow<Boolean> = _isLoading.asStateFlow()

    private val _errorMessage = MutableStateFlow<String?>(null)
    val errorMessage: StateFlow<String?> = _errorMessage.asStateFlow()

    fun onDescriptionChange(newDescription: String) {
        _description.value = newDescription
    }

    fun onAmountChange(newAmount: String) {
        _amount.value = newAmount
    }

    fun onCurrencyChange(newCurrency: String) {
        _currency.value = newCurrency
    }

    fun onLocationChange(newLocation: String) {
        _location.value = newLocation
    }

    fun onPaymentMethodChange(newPaymentMethod: String) {
        _paymentMethod.value = newPaymentMethod
    }

    fun onNotesChange(newNotes: String) {
        _notes.value = newNotes
    }

    fun createExpense(onSuccess: () -> Unit) {
        val amountValue = _amount.value.toDoubleOrNull()
        if (amountValue == null || amountValue <= 0) {
            _errorMessage.value = "正しい金額を入力してください"
            return
        }

        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null

            try {
                val newExpense = CreateExpenseRequest(
                    tripId = tripId,
                    categoryId = null, // TODO: カテゴリー選択機能追加
                    amount = amountValue,
                    currency = _currency.value,
                    description = _description.value.ifEmpty { null },
                    notes = _notes.value.ifEmpty { null },
                    expenseDate = LocalDate.now().toString(),
                    location = _location.value.ifEmpty { null },
                    paymentMethod = _paymentMethod.value.ifEmpty { null },
                    metadata = null
                )

                SupabaseClient.client
                    .from("expenses")
                    .insert(newExpense)

                onSuccess()
            } catch (e: Exception) {
                _errorMessage.value = "支出の作成に失敗しました: ${e.message}"
            } finally {
                _isLoading.value = false
            }
        }
    }
}

/**
 * ViewModelFactory
 */
class CreateExpenseViewModelFactory(
    private val tripId: String
) : androidx.lifecycle.ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(CreateExpenseViewModel::class.java)) {
            return CreateExpenseViewModel(tripId) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}
