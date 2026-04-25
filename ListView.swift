import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// ─────────────────────────────────────────────────────────────
//  ListView.swift
//  SharePay — main screen after login
//  Shows all open cash requests using @FirestoreQuery
//  Supports swipe-to-delete and create-new via toolbar "+"
// ─────────────────────────────────────────────────────────────

struct ListView: View {
    
    @FirestoreQuery(collectionPath: "requests") var requests: [Request]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(requests) { request in
                NavigationLink {
                    DetailView(request: request)
                } label: {
                    HStack(spacing: 14) {
                        // Type icon
                        Image(systemName: request.type == "needsCash"
                              ? "dollarsign.circle.fill"
                              : "banknote.fill")
                            .font(.title)
                            .foregroundStyle(request.type == "needsCash" ? .blue : .green)
                            .frame(width: 36)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(request.typeLabel)
                                .font(.headline)
                            Text("$\(request.amount, specifier: "%.2f")  •  Fee: $\(request.fee, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if !request.note.isEmpty {
                                Text(request.note)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        RequestViewModel.deleteRequest(request: request)
                    }
                }
            }
            .listStyle(.plain)
            .overlay {
                if requests.isEmpty {
                    ContentUnavailableView(
                        "No Requests Yet",
                        systemImage: "arrow.left.arrow.right.circle",
                        description: Text("Tap + to create your first cash request.")
                    )
                }
            }
            .navigationTitle("Cash Requests")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🚪➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out!")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New", systemImage: "plus") {
                        sheetIsPresented.toggle()
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                NavigationStack {
                    DetailView(request: Request())
                }
            }
        }
    }
}

#Preview {
    ListView()
}
