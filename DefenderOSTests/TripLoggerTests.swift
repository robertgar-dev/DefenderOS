import XCTest
import CoreLocation
@testable import DefenderOS

/// Headless stand-in for CoreLocationProvider — no GPS, no Simulator.
/// CLLocation values are constructed directly; nothing touches hardware.
private final class MockLocationProvider: LocationProviding {
    var onLocations: (([CLLocation]) -> Void)?
    var authorizationStatus: CLAuthorizationStatus = .authorizedWhenInUse
    private(set) var requestAuthorizationCount = 0
    private(set) var startCount = 0
    private(set) var stopCount = 0

    func requestWhenInUseAuthorization() { requestAuthorizationCount += 1 }
    func startUpdatingLocation() { startCount += 1 }
    func stopUpdatingLocation() { stopCount += 1 }

    func send(_ locations: [CLLocation]) { onLocations?(locations) }
}

final class TripLoggerTests: XCTestCase {
    private var provider: MockLocationProvider!
    private var store: TripStore!
    private var logger: TripLogger!

    override func setUp() {
        super.setUp()
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        provider = MockLocationProvider()
        store = TripStore(directory: dir)
        logger = TripLogger(provider: provider, store: store)
    }

    private func location(_ lat: Double, _ lon: Double) -> CLLocation {
        CLLocation(latitude: lat, longitude: lon)
    }

    func testTripLifecyclePersistsOneTrip() {
        logger.beginTrip()
        provider.send([location(37.0, -122.0), location(37.001, -122.0)])
        logger.endTrip()

        let trips = store.allTrips()
        XCTAssertEqual(trips.count, 1)
        XCTAssertEqual(trips.first?.pointCount, 2)
        XCTAssertEqual(provider.startCount, 1)
        XCTAssertEqual(provider.stopCount, 1)
    }

    func testDistanceSumsConsecutivePairs() {
        let a = location(37.000, -122.000)
        let b = location(37.001, -122.000)
        let c = location(37.001, -122.001)
        let expected = b.distance(from: a) + c.distance(from: b)

        logger.beginTrip()
        provider.send([a, b, c])
        logger.endTrip()

        let trip = store.allTrips().first
        XCTAssertNotNil(trip)
        XCTAssertEqual(trip?.distanceMeters ?? -1, expected, accuracy: 0.001)
    }

    func testBeginTripWhileActiveDoesNotResetState() {
        logger.beginTrip()
        provider.send([location(37.0, -122.0), location(37.001, -122.0)])
        logger.beginTrip()  // no-op while a trip is active
        provider.send([location(37.002, -122.0)])
        logger.endTrip()

        XCTAssertEqual(store.allTrips().first?.pointCount, 3)
        XCTAssertEqual(provider.startCount, 1)
    }

    func testEndTripWithoutBeginIsNoOp() {
        logger.endTrip()
        XCTAssertTrue(store.allTrips().isEmpty)
        XCTAssertEqual(provider.stopCount, 0)
    }

    func testAuthorizationRequestedOnlyWhenNotDetermined() {
        provider.authorizationStatus = .notDetermined
        logger.beginTrip()
        XCTAssertEqual(provider.requestAuthorizationCount, 1)
        logger.endTrip()

        provider.authorizationStatus = .authorizedWhenInUse
        logger.beginTrip()
        XCTAssertEqual(provider.requestAuthorizationCount, 1)  // unchanged
        logger.endTrip()
    }

    func testSecondTripAppendsSeparately() {
        logger.beginTrip()
        provider.send([location(37.0, -122.0)])
        logger.endTrip()

        logger.beginTrip()
        provider.send([location(38.0, -121.0), location(38.001, -121.0)])
        logger.endTrip()

        let trips = store.allTrips()
        XCTAssertEqual(trips.count, 2)
        XCTAssertEqual(trips.last?.pointCount, 2)
    }
}
