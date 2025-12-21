import SwiftUI

/// 旅行作成画面
struct CreateTripView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreateTripViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("旅行名", text: $viewModel.name)
                    TextField("目的地", text: $viewModel.destination)
                }

                Section(header: Text("期間")) {
                    DatePicker(
                        "開始日",
                        selection: $viewModel.startDate,
                        displayedComponents: .date
                    )

                    DatePicker(
                        "終了日",
                        selection: $viewModel.endDate,
                        in: viewModel.startDate...,
                        displayedComponents: .date
                    )
                }

                Section(header: Text("予算（オプション）")) {
                    HStack {
                        Picker("通貨", selection: $viewModel.currency) {
                            Text("JPY").tag("JPY")
                            Text("USD").tag("USD")
                            Text("EUR").tag("EUR")
                            Text("GBP").tag("GBP")
                        }
                        .pickerStyle(.menu)

                        TextField("予算", value: $viewModel.budget, format: .number)
                            .keyboardType(.decimalPad)
                    }
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
                                await viewModel.createTrip()
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
                        .disabled(viewModel.name.isEmpty)
                    }
                }
            }
            .navigationTitle("新しい旅行")
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

/// 旅行作成ViewModel
@MainActor
class CreateTripViewModel: ObservableObject {
    @Published var name = ""
    @Published var destination = ""
    @Published var startDate = Date()
    @Published var endDate = Date().addingTimeInterval(86400 * 7) // 1週間後
    @Published var budget: Double? = nil
    @Published var currency = "JPY"
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let supabase = SupabaseManager.shared

    func createTrip() async {
        guard !name.isEmpty else {
            errorMessage = "旅行名を入力してください"
            return
        }

        guard let userId = supabase.currentUser?.id else {
            errorMessage = "ユーザー情報の取得に失敗しました"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let dateFormatter = ISO8601DateFormatter()

            let newTrip = CreateTripRequest(
                userId: userId,
                name: name,
                destination: destination.isEmpty ? nil : destination,
                startDate: startDate,
                endDate: endDate,
                budget: budget,
                currency: currency
            )

            try await supabase.client
                .from("trips")
                .insert(newTrip)
                .execute()

        } catch {
            errorMessage = "旅行の作成に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }
}

#Preview {
    CreateTripView()
}
