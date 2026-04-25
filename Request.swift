import Foundation
import FirebaseFirestore

// ─────────────────────────────────────────────────────────────
//  Request.swift  (UPDATED with location fields)
//  Stored in Firestore collection "requests"
// ─────────────────────────────────────────────────────────────

struct Request: Codable, Identifiable {
    
    @DocumentID var id: String?
    var userEmail: String = ""
    var type: String = "needsCash"   // "needsCash" or "hasCash"
    var amount: Double = 0.0
    var note: String = ""
    var address: String = ""           // NEW: human-readable address
    var latitude: Double = 0.0         // NEW: pin coordinate
    var longitude: Double = 0.0        // NEW: pin coordinate
    var createdAt: Date = Date()
    
    // MARK: - Computed Properties
    
    /// Total SharePay fee using hybrid model: max($2.00, 2.5% of amount)
    var fee: Double {
        max(2.00, amount * 0.025)
    }
    
    var responderShare: Double { fee * 0.70 }
    var platformShare: Double { fee * 0.30 }
    
    var typeLabel: String {
        type == "needsCash" ? "Needs Cash" : "Has Cash"
    }
    
    /// True if a real location was set (not the default 0,0)
    var hasLocation: Bool {
        latitude != 0.0 && longitude != 0.0
    }
}
