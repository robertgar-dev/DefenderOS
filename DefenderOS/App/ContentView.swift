import SwiftUI

struct ContentView: View {
    @State private var trips: [Trip] = []

    var body: some View {
        NavigationStack {
            List(trips) { trip in
                VStack(alignment: .leading, spacing: 4) {
                    Text(trip.startedAt, style: .date).font(.headline)
                    Text("\(trip.pointCount) points · \(String(format: "%.1f", trip.distanceMeters / 1609.34)) mi")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("DefenderOS · Trips")
            .onAppear { trips = TripStore.shared.allTrips() }
            .refreshable { trips = TripStore.shared.allTrips() }
        }
    }
}
