import SwiftUI

@main
struct TravelExpenseApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}

/// コンテンツビュー（認証状態に応じて画面を切り替え）
struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            switch authViewModel.authState {
            case .loading:
                ProgressView()
                    .scaleEffect(1.5)

            case .authenticated:
                MainTabView()

            case .unauthenticated, .error:
                LoginView()
            }
        }
    }
}

/// メインタブビュー
struct MainTabView: View {
    var body: some View {
        TabView {
            TripListView()
                .tabItem {
                    Label("旅行", systemImage: "airplane")
                }

            Text("カテゴリー")
                .tabItem {
                    Label("カテゴリー", systemImage: "folder")
                }

            ProfileView()
                .tabItem {
                    Label("プロフィール", systemImage: "person.circle")
                }
        }
        .accentColor(Color(hex: "E63946"))
    }
}

/// プロフィール画面
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    if let user = SupabaseManager.shared.currentUser {
                        HStack {
                            Text("メールアドレス")
                            Spacer()
                            Text(user.email ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                }

                Section {
                    Button(role: .destructive, action: {
                        Task {
                            await authViewModel.signOut()
                        }
                    }) {
                        HStack {
                            Text("ログアウト")
                            Spacer()
                            if authViewModel.isLoading {
                                ProgressView()
                            }
                        }
                    }
                    .disabled(authViewModel.isLoading)
                }
            }
            .navigationTitle("プロフィール")
        }
    }
}

/// 旅行詳細画面
struct TripDetailView: View {
    let trip: Trip

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(trip.name)
                    .font(.title)
                    .fontWeight(.bold)

                if let destination = trip.destination {
                    HStack {
                        Image(systemName: "location.fill")
                        Text(destination)
                    }
                    .foregroundColor(.gray)
                }

                Divider()

                Text("日付: \(trip.startDate.formatted(date: .long, time: .omitted))")
                    .font(.subheadline)

                if let budget = trip.budget {
                    Text("予算: \(trip.currency) \(budget, specifier: "%.0f")")
                        .font(.subheadline)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("旅行詳細")
    }
}

/// 旅行作成フォーム
struct TripFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var destination = ""

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("旅行名", text: $name)
                    TextField("目的地", text: $destination)
                }

                Section {
                    Button("作成") {
                        // TODO: 旅行作成処理
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle("新しい旅行")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
