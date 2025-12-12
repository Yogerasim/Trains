import Combine
import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

@MainActor
final class StationsScreenViewModel: ObservableObject {
    @Published var stations: [StationData] = []
    @Published var isLoading = false
    @Published var showNoInternet = false
    @Published var showServerError = false

    private let searchService: SearchService
    private let fromStationCode: String
    private let toStationCode: String

    init(fromStationCode: String, toStationCode: String, searchService: SearchService) {
        self.fromStationCode = fromStationCode
        self.toStationCode = toStationCode
        self.searchService = searchService
    }

    func load(date: String? = nil) async {
        isLoading = true
        showNoInternet = false
        showServerError = false
        defer { isLoading = false }

        do {
            let response = try await searchService.getScheduleBetweenStations(
                from: fromStationCode,
                to: toStationCode,
                date: date
            )

            var tmpStations: [StationData] = []

            // Проверяем, есть ли сегменты
            if let segments = response.segments {
                for segment in segments {
                    let thread = segment.thread
                    let carrier = thread?.carrier

                    // --- Обработка дат ---
                    let departureText = parseDate(segment.departure)
                    let arrivalText = parseDate(segment.arrival)

                    // --- Обработка duration ---
                    let durationText = parseDuration(segment.duration)

                    tmpStations.append(
                        StationData(
                            logoName: carrier?.code.map(String.init) ?? "RZHD",
                            stationName: thread?.title ?? "Неизвестно",
                            subtitle: carrier?.title.map { String($0) },
                            rightTopText: departureText,
                            leftBottomText: arrivalText,
                            middleBottomText: durationText,
                            rightBottomText: arrivalText
                        )
                    )
                }
            }

            self.stations = tmpStations

        } catch {
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                showNoInternet = true
            } else {
                showServerError = true
            }
        }
    }

    // MARK: - Вспомогательные функции

    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private func parseDate(_ value: Any?) -> String {
        guard let value = value else { return "" }

        // Если приходит Date
        if let date = value as? Date {
            return timeFormatter.string(from: date)
        }

        // Если приходит String в ISO8601
        if let str = value as? String,
           let date = ISO8601DateFormatter().date(from: str) {
            return timeFormatter.string(from: date)
        }

        return ""
    }

    private func parseDuration(_ value: Any?) -> String {
        guard let value = value else { return "" }

        if let intVal = value as? Int {
            return formatDuration(intVal)
        }

        if let int32Val = value as? Int32 {
            return formatDuration(Int(int32Val))
        }

        if let int64Val = value as? Int64 {
            return formatDuration(Int(int64Val))
        }

        // Если приходит строкой
        if let str = value as? String, let intVal = Int(str) {
            return formatDuration(intVal)
        }

        return ""
    }

    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let mins = (seconds % 3600) / 60
        return "\(hours) ч \(mins) мин"
    }
}
