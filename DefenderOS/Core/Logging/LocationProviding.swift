import Foundation
import CoreLocation

/// Seam between TripLogger and CoreLocation (docs/AUDIT.md §5: TripLogger
/// could not be unit tested without a real device feeding it location
/// updates). Tests substitute a mock; production uses CoreLocationProvider.
protocol LocationProviding: AnyObject {
    /// Delivery callback for batches of location fixes.
    var onLocations: (([CLLocation]) -> Void)? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

/// Production implementation backed by CLLocationManager.
final class CoreLocationProvider: NSObject, LocationProviding, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var onLocations: (([CLLocation]) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    var authorizationStatus: CLAuthorizationStatus { manager.authorizationStatus }
    func requestWhenInUseAuthorization() { manager.requestWhenInUseAuthorization() }
    func startUpdatingLocation() { manager.startUpdatingLocation() }
    func stopUpdatingLocation() { manager.stopUpdatingLocation() }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocations?(locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // M0: swallow; M1 adds structured logging (decision 0009).
    }
}
