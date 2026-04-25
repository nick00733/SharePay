import SwiftUI
import MapKit

// ─────────────────────────────────────────────────────────────
//  LocationSearchView.swift  (NEW)
//  Lets the user search for a place near Boston College.
//  Returns the selected coordinates via @Binding.
//  Pattern adapted from Course Ch. 8.13.
// ─────────────────────────────────────────────────────────────

struct LocationSearchView: View {
    
    @Binding var address: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var results: [MKMapItem] = []
    
    // Boston College campus center — biases the search
    private let bcRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3355, longitude: -71.1685),
        latitudinalMeters: 3000,
        longitudinalMeters: 3000
    )
    
    var body: some View {
        NavigationStack {
            Group {
                if results.isEmpty {
                    ContentUnavailableView(
                        "Search BC Area",
                        systemImage: "mappin.and.ellipse",
                        description: Text("Try \"Bapst Library\", \"Hillside Café\", or any spot near Boston College.")
                    )
                } else {
                    List(results, id: \.self) { item in
                        Button {
                            selectLocation(item)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text(item.placemark.title ?? "")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Find Location")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search BC area")
            .onChange(of: searchText) {
                Task { await search() }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - MKLocalSearch
    
    func search() async {
        guard !searchText.isEmpty else {
            results = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = bcRegion
        
        do {
            let response = try await MKLocalSearch(request: request).start()
            results = response.mapItems
        } catch {
            print("😡 SEARCH ERROR: \(error.localizedDescription)")
            results = []
        }
    }
    
    func selectLocation(_ item: MKMapItem) {
        address = item.name ?? item.placemark.title ?? "Selected Location"
        latitude = item.placemark.coordinate.latitude
        longitude = item.placemark.coordinate.longitude
        dismiss()
    }
}

#Preview {
    LocationSearchView(
        address: .constant(""),
        latitude: .constant(0.0),
        longitude: .constant(0.0)
    )
}
