import Foundation
import Combine

/// 旅行一覧ViewModel
@MainActor
class TripViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchQuery = ""
    @Published var filter: TripFilter = .all
    @Published var sortBy: TripSort = .dateDesc

    private let supabase = SupabaseManager.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init() {
        setupSearch()
    }

    // MARK: - Data Fetching

    /// 旅行一覧を取得
    func fetchTrips() async {
        guard let userId = supabase.currentUser?.id else {
            errorMessage = "ユーザー情報の取得に失敗しました"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response: [Trip] = try await supabase.client
                .from("trips")
                .select()
                .eq("user_id", value: userId)
                .order("start_date", ascending: false)
                .execute()
                .value

            trips = response
        } catch {
            errorMessage = "旅行の取得に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }

    /// 旅行を削除
    func deleteTrip(_ trip: Trip) async {
        do {
            try await supabase.client
                .from("trips")
                .delete()
                .eq("id", value: trip.id)
                .execute()

            // ローカルから削除
            trips.removeAll { $0.id == trip.id }
        } catch {
            errorMessage = "旅行の削除に失敗しました: \(error.localizedDescription)"
        }
    }

    // MARK: - Filtering & Sorting

    /// フィルター・ソート済みの旅行一覧
    var filteredAndSortedTrips: [Trip] {
        var result = trips

        // 検索フィルター
        if !searchQuery.isEmpty {
            result = result.filter { trip in
                trip.name.localizedCaseInsensitiveContains(searchQuery) ||
                (trip.destination?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            }
        }

        // 日付フィルター
        let today = Calendar.current.startOfDay(for: Date())
        result = result.filter { trip in
            switch filter {
            case .all:
                return true
            case .upcoming:
                return trip.startDate > today
            case .ongoing:
                let endDate = trip.endDate ?? trip.startDate
                return trip.startDate <= today && endDate >= today
            case .past:
                guard let endDate = trip.endDate else { return false }
                return endDate < today
            }
        }

        // ソート
        result.sort { first, second in
            switch sortBy {
            case .dateDesc:
                return first.startDate > second.startDate
            case .dateAsc:
                return first.startDate < second.startDate
            case .name:
                return first.name.localizedCompare(second.name) == .orderedAscending
            case .budget:
                return (first.budget ?? 0) > (second.budget ?? 0)
            }
        }

        return result
    }

    /// フィルターをクリア
    func clearFilters() {
        searchQuery = ""
        filter = .all
        sortBy = .dateDesc
    }

    /// フィルターがアクティブか
    var hasActiveFilters: Bool {
        !searchQuery.isEmpty || filter != .all || sortBy != .dateDesc
    }

    // MARK: - Search

    private func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Filter & Sort Types

enum TripFilter {
    case all
    case upcoming
    case ongoing
    case past

    var title: String {
        switch self {
        case .all: return "すべて"
        case .upcoming: return "予定"
        case .ongoing: return "進行中"
        case .past: return "過去"
        }
    }
}

enum TripSort {
    case dateDesc
    case dateAsc
    case name
    case budget

    var title: String {
        switch self {
        case .dateDesc: return "日付が新しい順"
        case .dateAsc: return "日付が古い順"
        case .name: return "名前順"
        case .budget: return "予算順"
        }
    }
}
