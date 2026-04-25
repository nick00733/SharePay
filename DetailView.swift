import SwiftUI
import FirebaseAuth

// ─────────────────────────────────────────────────────────────
//  DetailView.swift
//  SharePay — create or edit a cash exchange request
//  Live preview of the SharePay Hybrid Fee
// ─────────────────────────────────────────────────────────────

struct DetailView: View {
    
    @State var request: Request
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
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
            
            // MARK: - Note
            Section("Note (optional)") {
                TextField("e.g. Meet at Starbucks Beacon St.",
                          text: $request.note,
                          axis: .vertical)
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
        .navigationTitle(request.id == nil ? "New Request" : "Edit Request")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        // Tag the request with the current user's email
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
}

#Preview {
    NavigationStack {
        DetailView(request: Request())
    }
}
