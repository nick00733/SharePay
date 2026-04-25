import SwiftUI
import FirebaseAuth

// ─────────────────────────────────────────────────────────────
//  MainTabView.swift  (NEW)
//  Top-level container after login.  Two tabs: List + Map.
//  Sign-Out and "+ New" toolbar live here so both tabs share them.
// ─────────────────────────────────────────────────────────────

struct MainTabView: View {
    
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView {
            // MARK: - Tab 1: List
            NavigationStack {
                ListView()
                    .navigationTitle("Cash Requests")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Sign Out") {
                                signOut()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("New", systemImage: "plus") {
                                sheetIsPresented = true
                            }
                        }
                    }
            }
            .tabItem {
                Label("List", systemImage: "list.bullet")
            }
            
            // MARK: - Tab 2: Map
            NavigationStack {
                MapView()
                    .navigationTitle("Map")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Sign Out") {
                                signOut()
                            }
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("New", systemImage: "plus") {
                                sheetIsPresented = true
                            }
                        }
                    }
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                DetailView(request: Request())
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            print("🚪➡️ Log out successful!")
            dismiss()
        } catch {
            print("😡 ERROR: Could not sign out!")
        }
    }
}

#Preview {
    MainTabView()
}
