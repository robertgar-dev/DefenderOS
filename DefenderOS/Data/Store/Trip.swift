import Foundation

struct Trip: Codable, Identifiable {
    let id: UUID
    let startedAt: Date
    let endedAt: Date
    let pointCount: Int
    let distanceMeters: Double
    let purposeTag: String?
}
