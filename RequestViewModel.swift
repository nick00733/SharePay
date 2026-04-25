import Foundation
import FirebaseFirestore

// ─────────────────────────────────────────────────────────────
//  RequestViewModel.swift
//  Handles save / update / delete of Request documents
//  Follows the course pattern (Week 12 Hackathon TeamViewModel)
// ─────────────────────────────────────────────────────────────

@Observable
class RequestViewModel {
    
    // MARK: - Save (Create OR Update)
    
    static func saveRequest(request: Request) async -> String? {
        let db = Firestore.firestore()
        
        if let id = request.id {
            // request already exists → update it
            do {
                try db.collection("requests").document(id).setData(from: request)
                print("😎 Data updated successfully!")
                return id
            } catch {
                print("😡 ERROR: Could not update data in 'requests'. \(error.localizedDescription)")
                return nil
            }
        } else {
            // new request → add a new document
            do {
                let docref = try db.collection("requests").addDocument(from: request)
                print("🐣 Data added successfully!")
                return docref.documentID
            } catch {
                print("😡 ERROR: Could not create a new request in 'requests'. \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    // MARK: - Delete
    
    static func deleteRequest(request: Request) {
        let db = Firestore.firestore()
        
        guard let id = request.id else {
            print("😡 ERROR: request.id == nil, cannot delete")
            return
        }
        
        Task {
            do {
                try await db.collection("requests").document(id).delete()
                print("🗑️ Document deleted successfully!")
            } catch {
                print("😡 ERROR: removing document. \(error.localizedDescription)")
            }
        }
    }
}
