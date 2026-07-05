import Foundation
import CoreLocation

/// Minimal ignition-to-ignition trip capture. Starts on CarPlay connect,
/// ends on disconnect, persists via TripStore.
///
/// Location updates arrive through the LocationProviding seam so distance
/// and trip-state logic run headlessly under test (docs/AUDIT.md §5);
/// production uses CoreLocationProvider.
final class TripLogger {
    static let shared = TripLogger()

    private let provider: LocationProviding
    private let store: TripStore
    private var points: [CLLocation] = []
    private var startedAt: Date?

    init(provider: LocationProviding = CoreLocationProvider(),
         store: TripStore = .shared) {
        self.provider = provider
        self.store = store
        provider.onLocations = { [weak self] locations in
            self?.points.append(contentsOf: locations)
        }
    }

    func beginTrip() {
        guard startedAt == nil else { return }  // already logging
        startedAt = Date()
        points = []
        if provider.authorizationStatus == .notDetermined {
            provider.requestWhenInUseAuthorization()
        }
        provider.startUpdatingLocation()
    }

    func endTrip() {
        guard let start = startedAt else { return }
        provider.stopUpdatingLocation()

        var distance: Double = 0
        for (a, b) in zip(points, points.dropFirst()) { distance += b.distance(from: a) }

        let trip = Trip(id: UUID(),
                        startedAt: start,
                        endedAt: Date(),
                        pointCount: points.count,
                        distanceMeters: distance,
                        purposeTag: nil)
        store.append(trip)
        startedAt = nil
        points = []
    }
}
