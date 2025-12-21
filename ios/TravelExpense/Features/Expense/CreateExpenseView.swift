import SwiftUI

/// 支出作成画面
struct CreateExpenseView: View {
    let tripId: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateExpenseViewModel

    init(tripId: String) {
        self.tripId = tripId
        _viewModel = StateObject(wrappedValue: CreateExpenseViewModel(tripId: tripId))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("説明", text: $viewModel.description)

                    HStack {
                        TextField("金額", value: $viewModel.amount, format: .number)
                            .keyboardType(.decimalPad)

                        Picker("通貨", selection: $viewModel.currency) {
                            Text("JPY").tag("JPY")
                            Text("USD").tag("USD")
                            Text("EUR").tag("EUR")
                        }
                        .pickerStyle(.menu)
                    }

                    DatePicker(
                        "日付",
                        selection: $viewModel.expenseDate,
                        displayedComponents: .date
                    )
                }

                Section(header: Text("詳細（オプション）")) {
                    TextField("場所", text: $viewModel.location)

                    Picker("支払い方法", selection: $viewModel.paymentMethod) {
                        Text("未選択").tag("")
                        Text("現金").tag("現金")
                        Text("クレジットカード").tag("クレジットカード")
                        Text("デビットカード").tag("デビットカード")
                        Text("ICカード").tag("ICカード")
                    }

                    TextField("メモ", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        Button(action: {
                            Task {
                                await viewModel.createExpense()
                                if viewModel.errorMessage == nil {
                                    dismiss()
                                }
                            }
                        }) {
                            HStack {
                                Spacer()
                                Text("作成")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        .disabled(viewModel.amount == 0)
                    }
                }
            }
            .navigationTitle("支出を追加")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
            .alert("エラー", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }
}

/// 支出作成ViewModel
@MainActor
class CreateExpenseViewModel: ObservableObject {
    let tripId: String

    @Published var description = ""
    @Published var amount: Double = 0
    @Published var currency = "JPY"
    @Published var expenseDate = Date()
    @Published var location = ""
    @Published var paymentMethod = ""
    @Published var notes = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let supabase = SupabaseManager.shared

    init(tripId: String) {
        self.tripId = tripId
    }

    func createExpense() async {
        guard amount > 0 else {
            errorMessage = "金額を入力してください"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let newExpense = CreateExpenseRequest(
                tripId: tripId,
                categoryId: nil, // TODO: カテゴリー選択機能追加
                amount: amount,
                currency: currency,
                description: description.isEmpty ? nil : description,
                notes: notes.isEmpty ? nil : notes,
                expenseDate: expenseDate,
                location: location.isEmpty ? nil : location,
                paymentMethod: paymentMethod.isEmpty ? nil : paymentMethod,
                metadata: nil
            )

            try await supabase.client
                .from("expenses")
                .insert(newExpense)
                .execute()

        } catch {
            errorMessage = "支出の作成に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    CreateExpenseView(tripId: "1")
}
