import Foundation
import CoreLocation

/// Minimal ignition-to-ignition trip capture. Starts on CarPlay connect,
/// ends on disconnect, persists via TripStore.
final class TripLogger: NSObject, CLLocationManagerDelegate {
    static let shared = TripLogger()

    private let manager = CLLocationManager()
    private var points: [CLLocation] = []
    private var startedAt: Date?

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func beginTrip() {
        guard startedAt == nil else { return }  // already logging
        startedAt = Date()
        points = []
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        manager.startUpdatingLocation()
    }

    func endTrip() {
        guard let start = startedAt else { return }
        manager.stopUpdatingLocation()

        var distance: Double = 0
        for (a, b) in zip(points, points.dropFirst()) { distance += b.distance(from: a) }

        let trip = Trip(id: UUID(),
                        startedAt: start,
                        endedAt: Date(),
                        pointCount: points.count,
                        distanceMeters: distance,
                        purposeTag: nil)
        TripStore.shared.append(trip)
        startedAt = nil
        points = []
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        points.append(contentsOf: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // M0: swallow; M1 adds structured logging.
    }
}
