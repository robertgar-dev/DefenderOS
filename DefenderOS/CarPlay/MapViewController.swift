import UIKit
import MapKit

/// M0: MapKit default rendering, user location shown. The Pangea/Mapbox
/// restyle is a Backlog item — do not block the live build on cartography.
final class MapViewController: UIViewController {
    private let mapView = MKMapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
    }
}
