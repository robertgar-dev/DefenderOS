import Foundation

/// M0 persistence: JSON-lines file. Deliberately boring — one appendable file,
/// human-readable, zero dependencies. SQLite replaces this in M1 behind the
/// same three methods (decision 0008). Dossier-compatible: each line is one
/// self-contained trip record.
final class TripStore {
    static let shared = TripStore()
    let fileURL: URL

    init(directory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]) {
        fileURL = directory.appendingPathComponent("trips.jsonl")
    }

    private let encoder: JSONEncoder = {
        let e = JSONEncoder(); e.dateEncodingStrategy = .iso8601; return e
    }()
    private let decoder: JSONDecoder = {
        let d = JSONDecoder(); d.dateDecodingStrategy = .iso8601; return d
    }()

    func append(_ trip: Trip) {
        guard var line = try? encoder.encode(trip) else { return }
        line.append(0x0A)
        if FileManager.default.fileExists(atPath: fileURL.path),
           let handle = try? FileHandle(forWritingTo: fileURL) {
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: line)
        } else {
            try? line.write(to: fileURL)
        }
    }

    func allTrips() -> [Trip] {
        guard let data = try? Data(contentsOf: fileURL),
              let text = String(data: data, encoding: .utf8) else { return [] }
        return text.split(separator: "\n").compactMap { line -> Trip? in
            try? decoder.decode(Trip.self, from: Data(line.utf8))
        }
    }

    func clear() { try? FileManager.default.removeItem(at: fileURL) }
}

