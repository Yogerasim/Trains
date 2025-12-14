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

    init(
        fromStationCode: String,
        toStationCode: String,
        searchService: SearchServiceProtocol
    ) {
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

            guard let segments = response.segments, !segments.isEmpty else {
                stations = []
                return
            }

            var mapped: [StationData] = []

            for segment in segments {

                let thread = segment.thread
                let carrier = thread?.carrier

                let depText = formatDateAny(segment.departure)
                let arrText = formatDateAny(segment.arrival)
                let durationText = formatAnyDuration(segment.duration)

                let logoURL: URL? = {
                    if let logo = carrier?.logo,
                       let url = URL(string: logo),
                       !logo.isEmpty {
                        return url
                    }
                    return nil
                }()

                let fallbackLogo = "RZHD"   // ⬅️ гарантированный asset

                mapped.append(
                    StationData(
                        logoURL: logoURL,
                        logoName: fallbackLogo,
                        stationName: thread?.title ?? "Неизвестно",
                        subtitle: carrier?.title,
                        rightTopText: depText,
                        leftBottomText: arrText,
                        middleBottomText: durationText,
                        rightBottomText: arrText
                    )
                )
            }

            stations = mapped
            print("🎯 Mapped stations count: \(mapped.count)")

        } catch {
            print("❌ StationsScreenViewModel.load() error: \(error)")
            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                showNoInternet = true
            } else {
                showServerError = true
            }
        }
    }

    // MARK: - Helpers

    private lazy var timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private func formatDateAny(_ v: Any?) -> String {
        guard let v = v else { return "" }
        if let d = v as? Date { return timeFormatter.string(from: d) }
        if let s = v as? String,
           let d = ISO8601DateFormatter().date(from: s) {
            return timeFormatter.string(from: d)
        }
        return String(describing: v)
    }

    private func formatAnyDuration(_ v: Any?) -> String {
        guard let v = v else { return "" }
        if let i = v as? Int { return formatDuration(i) }
        if let i32 = v as? Int32 { return formatDuration(Int(i32)) }
        if let i64 = v as? Int64 { return formatDuration(Int(i64)) }
        if let s = v as? String, let i = Int(s) { return formatDuration(i) }
        return String(describing: v)
    }

    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let mins = (seconds % 3600) / 60
        return "\(hours) ч \(mins) мин"
    }
}
