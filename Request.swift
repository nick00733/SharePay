import Foundation
import FirebaseFirestore

// ─────────────────────────────────────────────────────────────
//  Request.swift
//  Model for a SharePay cash exchange request
//  Stored in Firestore collection "requests"
// ─────────────────────────────────────────────────────────────

struct Request: Codable, Identifiable {
    
    @DocumentID var id: String?
    var userEmail: String = ""
    var type: String = "needsCash"   // "needsCash" or "hasCash"
    var amount: Double = 0.0
    var note: String = ""
    var createdAt: Date = Date()
    
    // MARK: - Computed Properties (Hybrid Fee Model from Strategy Doc)
    
    /// Total SharePay fee using hybrid model: max($2.00, 2.5% of amount)
    var fee: Double {
        max(2.00, amount * 0.025)
    }
    
    /// Responder's share of the fee (70%)
    var responderShare: Double {
        fee * 0.70
    }
    
    /// SharePay's share of the fee (30%)
    var platformShare: Double {
        fee * 0.30
    }
    
    /// Human-readable type label
    var typeLabel: String {
        type == "needsCash" ? "Needs Cash" : "Has Cash"
    }
}
