import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// ─────────────────────────────────────────────────────────────
//  ListView.swift  (UPDATED)
//  Toolbar (Sign Out, +) moved to MainTabView.
//  NEW: only the request's owner can delete it.
//  NEW: shows the address inline.
// ─────────────────────────────────────────────────────────────

struct ListView: View {
    
    @FirestoreQuery(collectionPath: "requests") var requests: [Request]
    
    /// The currently signed-in user's email — used for delete-permission check
    private var currentUserEmail: String? {
        Auth.auth().currentUser?.email
    }
    
    var body: some View {
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
                        if !request.address.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundStyle(.red)
                                    .font(.caption2)
                                Text(request.address)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
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
                // Only the request's owner can delete it
                if request.userEmail == currentUserEmail {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        RequestViewModel.deleteRequest(request: request)
                    }
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
    }
}

#Preview {
    NavigationStack {
        ListView()
    }
}
