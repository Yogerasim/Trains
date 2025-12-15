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

            for (index, segment) in segments.enumerated() {
                print("🧩 SEGMENT \(index):")
                dump(segment)

                let carrier = segment.thread?.carrier

                let departureTime = formatDateAny(segment.departure)
                let arrivalTime = formatDateAny(segment.arrival)
                let durationText = formatAnyDuration(segment.duration)

                guard let departureDate = segment.departure else {
                    continue
                }

                let hasTransfers = segment.thread?.uid?.contains("_") == true

                let todayDateText = formatTodayDate(Date())

                let stationTitle =
                    segment.thread?.carrier?.title ??
                    "Перевозчик неизвестен"

                let subtitleText: String? = nil

                let logoURL: URL? = {
                    if let logo = carrier?.logo,
                       let url = URL(string: logo),
                       !logo.isEmpty
                    {
                        return url
                    }
                    return nil
                }()

                mapped.append(
                    StationData(
                        carrierCode: carrier?.code.map { String($0) },
                        logoURL: logoURL,
                        stationName: stationTitle,
                        subtitle: subtitleText,
                        rightTopText: todayDateText,
                        leftBottomText: departureTime,
                        middleBottomText: durationText,
                        rightBottomText: arrivalTime,
                        departureDate: departureDate,
                        hasTransfers: hasTransfers
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

    private lazy var timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private func formatDateAny(_ v: Any?) -> String {
        guard let v = v else { return "" }
        if let d = v as? Date { return timeFormatter.string(from: d) }
        if let s = v as? String,
           let d = ISO8601DateFormatter().date(from: s)
        {
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

    private lazy var dateFormatterDay: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ru_RU")
        f.dateFormat = "d MMMM"
        return f
    }()

    private func formatTodayDate(_ date: Date) -> String {
        dateFormatterDay.string(from: date)
    }
}
