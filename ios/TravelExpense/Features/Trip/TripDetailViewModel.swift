import Foundation
import Combine

/// 旅行詳細ViewModel
@MainActor
class TripDetailViewModel: ObservableObject {
    @Published var trip: Trip
    @Published var expenses: [Expense] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let supabase = SupabaseManager.shared
    private var cancellables = Set<AnyCancellable>()

    init(trip: Trip) {
        self.trip = trip
    }

    // MARK: - Data Fetching

    /// 支出一覧を取得
    func fetchExpenses() async {
        isLoading = true
        errorMessage = nil

        do {
            let response: [Expense] = try await supabase.client
                .from("expenses")
                .select()
                .eq("trip_id", value: trip.id)
                .order("expense_date", ascending: false)
                .execute()
                .value

            expenses = response
        } catch {
            errorMessage = "支出の取得に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// 支出を削除
    func deleteExpense(_ expense: Expense) async {
        do {
            try await supabase.client
                .from("expenses")
                .delete()
                .eq("id", value: expense.id)
                .execute()

            expenses.removeAll { $0.id == expense.id }
        } catch {
            errorMessage = "支出の削除に失敗しました: \(error.localizedDescription)"
        }
    }

    // MARK: - Computed Properties

    /// 総支出額
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    /// 予算残高
    var remainingBudget: Double? {
        guard let budget = trip.budget else { return nil }
        return budget - totalExpenses
    }

    /// 予算使用率
    var budgetUsage: Double {
        guard let budget = trip.budget, budget > 0 else { return 0 }
        return (totalExpenses / budget) * 100
    }

    /// 予算超過か
    var isOverBudget: Bool {
        guard let remaining = remainingBudget else { return false }
        return remaining < 0
    }
}
