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

    private let searchService: SearchServiceProtocol
    private let fromStationCode: String
    private let toStationCode: String

    init(fromStationCode: String, toStationCode: String, searchService: SearchServiceProtocol) {
        self.fromStationCode = fromStationCode
        self.toStationCode = toStationCode
        self.searchService = searchService
    }

    func load(date: String? = nil) async {
        isLoading = true
        showNoInternet = false
        showServerError = false
        defer { isLoading = false }

        print("📡 StationsScreenViewModel.load() — from:\(fromStationCode) to:\(toStationCode) date:\(date ?? "nil")")

        do {
            let response = try await searchService.getScheduleBetweenStations(
                from: fromStationCode,
                to: toStationCode,
                date: date
            )

            print("✅ API returned response: \(response)")

            var tmpStations: [StationData] = []

            // Safety: убедимся что segments не nil
            guard let segments = response.segments, !segments.isEmpty else {
                print("⚠️ response.segments is nil or empty")
                // не считаем это обязательно server error — показываем empty placeholder
                self.stations = []
                return
            }

            for (idx, segment) in segments.enumerated() {
                print("→ segment[\(idx)]: \(segment)")

                // маппим защищённо
                let thread = segment.thread
                let carrier = thread?.carrier

                // departure / arrival — в твоём debug видно Date, так что форматируем
                let depText = formatDateAny(segment.departure)
                let arrText = formatDateAny(segment.arrival)

                // duration может быть Int/Int32/Int64/String — обработаем
                let durationText = formatAnyDuration(segment.duration)

                // carrier code -> локальная картинка mapping (если надо)
                let logoName: String = {
                    if let code = carrier?.code {
                        // carrier.code может быть Int или String — приводим в строку
                        return String(describing: code)
                    }
                    return "RZHD"
                }()

                let subtitle = carrier?.title ?? thread?.title

                tmpStations.append(
                    StationData(
                        logoName: logoName,
                        stationName: thread?.title ?? "Неизвестно",
                        subtitle: subtitle,
                        rightTopText: depText,
                        leftBottomText: arrText,
                        middleBottomText: durationText,
                        rightBottomText: arrText
                    )
                )
            }

            self.stations = tmpStations
            print("🎯 Mapped stations count: \(tmpStations.count)")

        } catch {
            // подробный лог ошибки
            print("❌ StationsScreenViewModel.load() error: \(error)")
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                showNoInternet = true
                print("→ Network: no internet")
            } else {
                showServerError = true
                print("→ Server error flag set")
            }
        }
    }

    // ---------------- helpers ----------------

    private lazy var timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private func formatDateAny(_ v: Any?) -> String {
        guard let v = v else { return "" }

        if let d = v as? Date { return timeFormatter.string(from: d) }
        if let s = v as? String, let d = ISO8601DateFormatter().date(from: s) { return timeFormatter.string(from: d) }
        // Fallback to debug description if unexpected type
        return String(describing: v)
    }

    private func formatAnyDuration(_ v: Any?) -> String {
        guard let v = v else { return "" }
        if let i = v as? Int { return formatDuration(i) }
        if let i32 = v as? Int32 { return formatDuration(Int(i32)) }
        if let i64 = v as? Int64 { return formatDuration(Int(i64)) }
        if let s = v as? String, let i = Int(s) { return formatDuration(i) }
        // fallback
        return String(describing: v)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let mins = (seconds % 3600) / 60
        return "\(hours) ч \(mins) мин"
    }
}
