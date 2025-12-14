import Foundation

enum YandexDateError: Error {
    case invalidFormat(String)
}

final class YandexJSONDecoder {

    static let shared: JSONDecoder = {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()

            // null
            if container.decodeNil() {
                return Date.distantPast
            }

            let raw = try container.decode(String.self)

            // 1️⃣ ISO8601
            if let d = ISO8601DateFormatter().date(from: raw) {
                return d
            }

            // 2️⃣ yyyy-MM-dd HH:mm:ss
            let fullFormatter = DateFormatter()
            fullFormatter.locale = Locale(identifier: "en_US_POSIX")
            fullFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            fullFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            if let d = fullFormatter.date(from: raw) {
                return d
            }

            // 3️⃣ HH:mm:ss (⚠️ Яндекс)
            let timeFormatter = DateFormatter()
            timeFormatter.locale = Locale(identifier: "en_US_POSIX")
            timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            timeFormatter.dateFormat = "HH:mm:ss"

            if let d = timeFormatter.date(from: raw) {
                return d
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid Yandex date format: \(raw)"
            )
        }

        return decoder
    }()
}
