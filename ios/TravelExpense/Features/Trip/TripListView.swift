import SwiftUI

/// 旅行一覧画面
struct TripListView: View {
    @StateObject private var viewModel = TripViewModel()
    @State private var showingNewTrip = false

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.filteredAndSortedTrips.isEmpty {
                    emptyStateView
                } else {
                    tripListView
                }
            }
            .navigationTitle("マイトリップ")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingNewTrip = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color(hex: "E63946"))
                    }
                }
            }
            .sheet(isPresented: $showingNewTrip) {
                TripFormView()
            }
            .task {
                await viewModel.fetchTrips()
            }
        }
    }

    // MARK: - Trip List

    private var tripListView: some View {
        VStack(spacing: 0) {
            // 検索バー
            searchBar

            // フィルター・ソート
            filterSortBar

            // 旅行リスト
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.filteredAndSortedTrips) { trip in
                        NavigationLink(destination: TripDetailView(trip: trip)) {
                            TripCardView(trip: trip)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("旅行名や目的地で検索...", text: $viewModel.searchQuery)
                .textFieldStyle(PlainTextFieldStyle())

            if !viewModel.searchQuery.isEmpty {
                Button(action: {
                    viewModel.searchQuery = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: - Filter & Sort Bar

    private var filterSortBar: some View {
        VStack(spacing: 12) {
            // フィルターボタン
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach([TripFilter.all, .ongoing, .upcoming, .past], id: \.self) { filter in
                        FilterButton(
                            title: filter.title,
                            isSelected: viewModel.filter == filter,
                            action: {
                                viewModel.filter = filter
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }

            // ソート・クリア
            HStack {
                Menu {
                    ForEach([TripSort.dateDesc, .dateAsc, .name, .budget], id: \.self) { sort in
                        Button(action: {
                            viewModel.sortBy = sort
                        }) {
                            HStack {
                                Text(sort.title)
                                if viewModel.sortBy == sort {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                        Text(viewModel.sortBy.title)
                    }
                    .font(.caption)
                    .foregroundColor(.primary)
                }

                Spacer()

                if viewModel.hasActiveFilters {
                    Button(action: {
                        viewModel.clearFilters()
                    }) {
                        Text("フィルターをクリア")
                            .font(.caption)
                            .foregroundColor(Color(hex: "E63946"))
                    }
                }
            }
            .padding(.horizontal)

            // 検索結果数
            if !viewModel.searchQuery.isEmpty {
                HStack {
                    Text("\(viewModel.filteredAndSortedTrips.count)件の旅行が見つかりました")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "airplane.departure")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))

            Text(viewModel.hasActiveFilters ? "条件に一致する旅行が見つかりません" : "旅行がまだありません")
                .font(.headline)
                .foregroundColor(.gray)

            Text(viewModel.hasActiveFilters ? "フィルターを変更するか、新しい旅行を作成してください" : "新しい旅行を作成して支出の記録を始めましょう")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            if viewModel.hasActiveFilters {
                Button(action: {
                    viewModel.clearFilters()
                }) {
                    Text("フィルターをクリア")
                        .fontWeight(.medium)
                }
                .buttonStyle(SecondaryButtonStyle())
            } else {
                Button(action: {
                    showingNewTrip = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("最初の旅行を作成")
                    }
                    .fontWeight(.medium)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }
}

// MARK: - Trip Card

struct TripCardView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // ヘッダー
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    if let destination = trip.destination {
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.caption)
                            Text(destination)
                                .font(.subheadline)
                        }
                        .foregroundColor(.gray)
                    }
                }

                Spacer()

                TripStatusBadge(trip: trip)
            }

            Divider()

            // 日付・予算
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(trip.startDate.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                }

                if let budget = trip.budget {
                    Spacer()
                    Text("\(trip.currency) \(budget, specifier: "%.0f")")
                        .font(.caption)
                        .foregroundColor(Color(hex: "E63946"))
                        .fontWeight(.medium)
                }
            }
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Trip Status Badge

struct TripStatusBadge: View {
    let trip: Trip

    private var status: (String, Color) {
        let today = Calendar.current.startOfDay(for: Date())
        let startDate = Calendar.current.startOfDay(for: trip.startDate)
        let endDate = trip.endDate.map { Calendar.current.startOfDay(for: $0) }

        if startDate > today {
            return ("予定", Color.blue)
        } else if let end = endDate, end < today {
            return ("過去", Color.gray)
        } else {
            return ("進行中", Color(hex: "06D6A0"))
        }
    }

    var body: some View {
        Text(status.0)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(status.1.opacity(0.2))
            .foregroundColor(status.1)
            .cornerRadius(8)
    }
}

// MARK: - Filter Button

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "E63946") : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

// MARK: - Secondary Button Style

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.white)
            .foregroundColor(Color(hex: "E63946"))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "E63946"), lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    TripListView()
}
