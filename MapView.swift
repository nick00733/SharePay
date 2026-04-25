import SwiftUI
import MapKit
import FirebaseFirestore

// ─────────────────────────────────────────────────────────────
//  MapView.swift  (NEW)
//  Shows all cash requests as pins on a Boston College campus map.
//  Tap a pin → opens the DetailView for that request.
// ─────────────────────────────────────────────────────────────

struct MapView: View {
    
    @FirestoreQuery(collectionPath: "requests") var requests: [Request]
    @State private var selectedRequest: Request?
    
    // Default camera position: Boston College
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 42.3355, longitude: -71.1685),
            latitudinalMeters: 1500,
            longitudinalMeters: 1500
        )
    )
    
    /// Only show requests that actually have coordinates
    var requestsWithLocation: [Request] {
        requests.filter { $0.hasLocation }
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(requestsWithLocation) { request in
                Annotation(
                    request.typeLabel,
                    coordinate: CLLocationCoordinate2D(
                        latitude: request.latitude,
                        longitude: request.longitude
                    )
                ) {
                    Button {
                        selectedRequest = request
                    } label: {
                        ZStack {
                            Circle()
                                .fill(request.type == "needsCash" ? .blue : .green)
                                .frame(width: 44, height: 44)
                                .shadow(radius: 3)
                            Image(systemName: request.type == "needsCash"
                                  ? "dollarsign"
                                  : "banknote")
                                .foregroundStyle(.white)
                                .font(.title3.bold())
                        }
                    }
                }
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .overlay(alignment: .top) {
            if requestsWithLocation.isEmpty {
                Text(requests.isEmpty
                     ? "No requests yet — tap List → + to create one."
                     : "Existing requests have no location yet — tap one to add a location.")
                    .font(.subheadline)
                    .padding(10)
                    .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 12))
                    .padding()
            }
        }
        .sheet(item: $selectedRequest) { request in
            NavigationStack {
                DetailView(request: request)
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    MapView()
}
