import XCTest
@testable import DefenderOS

final class TripStoreTests: XCTestCase {
    var store: TripStore!

    override func setUp() {
        super.setUp()
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        store = TripStore(directory: dir)
    }

    func testRoundTrip() {
        let trip = Trip(id: UUID(), startedAt: Date(), endedAt: Date().addingTimeInterval(600),
                        pointCount: 42, distanceMeters: 12_345.6, purposeTag: "Family")
        store.append(trip)
        let loaded = store.allTrips()
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.id, trip.id)
        XCTAssertEqual(loaded.first?.pointCount, 42)
        XCTAssertEqual(loaded.first?.purposeTag, "Family")
    }

    func testAppendIsAdditive() {
        for i in 0..<3 {
            store.append(Trip(id: UUID(), startedAt: Date(), endedAt: Date(),
                              pointCount: i, distanceMeters: Double(i), purposeTag: nil))
        }
        XCTAssertEqual(store.allTrips().count, 3)
    }

    func testEmptyStoreReadsEmpty() {
        XCTAssertTrue(store.allTrips().isEmpty)
    }
}
