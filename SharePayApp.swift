import SwiftUI
import FirebaseCore

// ─────────────────────────────────────────────────────────────
//  SharePayApp.swift
//  Entry point — initializes Firebase and starts with LoginView
// ─────────────────────────────────────────────────────────────

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("🔥 Firebase configured")
        return true
    }
}

@main
struct SharePayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
