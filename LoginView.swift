import SwiftUI
import FirebaseAuth

// ─────────────────────────────────────────────────────────────
//  LoginView.swift
//  SharePay — Email/Password Login & Sign-Up
//  Follows the course pattern (Snacktacular Ch. 8.2 / Hackathon)
// ─────────────────────────────────────────────────────────────

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var presentSheet = false
    @FocusState private var focusField: FocusedField?
    
    enum FocusedField {
        case email, password
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - Logo & Title
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .padding(.top, 60)
                
                Text("SharePay")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                
                Text("Exchange cash locally, instantly.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 40)
                
                // MARK: - Email & Password Fields
                Group {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.next)
                        .focused($focusField, equals: .email)
                        .onSubmit {
                            focusField = .password
                        }
                    
                    SecureField("Password", text: $password)
                        .submitLabel(.done)
                        .focused($focusField, equals: .password)
                        .onSubmit {
                            focusField = nil
                        }
                }
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 2)
                }
                .padding(.horizontal)
                
                // MARK: - Sign Up / Login Buttons
                HStack {
                    Button {
                        register()
                    } label: {
                        Text("Sign Up")
                    }
                    .padding(.trailing)
                    
                    Button {
                        login()
                    } label: {
                        Text("Log In")
                    }
                    .padding(.leading)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .font(.title2)
                .padding(.top)
                
                Spacer()
            }
            .alert(alertMessage, isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            }
            .fullScreenCover(isPresented: $presentSheet) {
                ListView()
            }
        }
    }
    
    // MARK: - Firebase Auth: Sign Up
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 SIGN UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🐣 Registration success!")
                presentSheet = true
            }
        }
    }
    
    // MARK: - Firebase Auth: Login
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("🪵 Log in success!")
                presentSheet = true
            }
        }
    }
}

#Preview {
    LoginView()
}
