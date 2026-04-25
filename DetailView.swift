import SwiftUI
import FirebaseAuth

// ─────────────────────────────────────────────────────────────
//  DetailView.swift  (UPDATED — Edit-Permission Check)
//  Create / edit a cash request. Includes Hybrid Fee preview
//  AND location search.
//  NEW: only the request's owner can edit it. For others, the
//       form is read-only (Save button is hidden, fields disabled).
// ─────────────────────────────────────────────────────────────

struct DetailView: View {
    
    @State var request: Request
    @State private var showingLocationSearch = false
    @Environment(\.dismiss) private var dismiss
    
    /// True when the signed-in user is the request's owner.
    /// New requests (no id yet) are always editable by the creator.
    private var isMyRequest: Bool {
        guard let id = request.id, !id.isEmpty else { return true }   // new request
        return request.userEmail == Auth.auth().currentUser?.email
    }
    
    var body: some View {
        Form {
            // MARK: - Read-only banner for other users' requests
            if !isMyRequest {
                Section {
                    HStack(spacing: 8) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.orange)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Read-only")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Posted by \(request.userEmail)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            // MARK: - Type
            Section("I want to…") {
                Picker("Type", selection: $request.type) {
                    Text("Get Cash 💵").tag("needsCash")
                    Text("Give Cash 💰").tag("hasCash")
                }
                .pickerStyle(.segmented)
            }
            
            // MARK: - Amount
            Section("Amount") {
                HStack {
                    Text("$")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    TextField("0.00", value: $request.amount, format: .number)
                        .keyboardType(.decimalPad)
                        .font(.title2)
                }
            }
            
            // MARK: - Location
            Section("Location") {
                if request.hasLocation {
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.red)
                            .font(.title3)
                        Text(request.address)
                            .font(.subheadline)
                    }
                }
                if isMyRequest {
                    Button {
                        showingLocationSearch = true
                    } label: {
                        Label(
                            request.hasLocation ? "Change Location" : "Choose Location",
                            systemImage: "map"
                        )
                    }
                }
            }
            
            // MARK: - Note
            Section("Note (optional)") {
                TextField(
                    "e.g. Meet by the entrance",
                    text: $request.note,
                    axis: .vertical
                )
                .lineLimit(2...5)
            }
            
            // MARK: - Fee Preview (Hybrid Model)
            Section("SharePay Fee") {
                HStack {
                    Text("Total Service Fee")
                    Spacer()
                    Text("$\(request.fee, specifier: "%.2f")")
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }
                HStack {
                    Text("→ Responder gets (70%)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("$\(request.responderShare, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("→ SharePay (30%)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("$\(request.platformShare, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("Hybrid pricing: max($2.00, 2.5% of amount). Responder earns the larger share to incentivize cash supply.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
        // ⬇️ Disables every interactive field if it's not your request
        .disabled(!isMyRequest)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(isMyRequest ? "Cancel" : "Close",
                       systemImage: "xmark") {
                    dismiss()
                }
            }
            // Only show Save when the user owns the request
            if isMyRequest {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", systemImage: "checkmark") {
                        Task {
                            if let email = Auth.auth().currentUser?.email {
                                request.userEmail = email
                            }
                            let id = await RequestViewModel.saveRequest(request: request)
                            if id == nil {
                                print("😡 ERROR saving on DetailView")
                            } else {
                                dismiss()
                            }
                        }
                    }
                    .disabled(request.amount <= 0)
                }
            }
        }
        .sheet(isPresented: $showingLocationSearch) {
            LocationSearchView(
                address: $request.address,
                latitude: $request.latitude,
                longitude: $request.longitude
            )
        }
    }
    
    private var navigationTitle: String {
        if request.id == nil || request.id?.isEmpty == true {
            return "New Request"
        }
        return isMyRequest ? "Edit Request" : "View Request"
    }
}

#Preview {
    NavigationStack {
        DetailView(request: Request())
    }
}
