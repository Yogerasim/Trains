import Combine
import Foundation

@MainActor
final class StationsScheduleViewModel: ObservableObject {
    @Published var items: [StationData] = []
    @Published var isLoading = false
    @Published var showNoInternet = false
    @Published var showServerError = false

    private let searchService: SearchServiceProtocol
    private let fromCode: String
    private let toCode: String

    init(fromCode: String, toCode: String, searchService: SearchServiceProtocol) {
        self.fromCode = fromCode
        self.toCode = toCode
        self.searchService = searchService
    }

    func load() async {
        isLoading = true
        showNoInternet = false
        showServerError = false
        defer { isLoading = false }

        do {
            let result = try await searchService.getScheduleBetweenStations(
                from: fromCode,
                to: toCode,
                date: nil
            )

            items = convert(result)

        } catch {
            handle(error)
        }
    }

    private func convert(_ data: Segments) -> [StationData] {
        data.segments?.compactMap { seg in
            let durationText = formatAnyDuration(seg.duration)
            let carrier = seg.thread?.carrier

            let logoURL: URL? = {
                if let logo = seg.thread?.carrier?.logo,
                   let url = URL(string: logo),
                   !logo.isEmpty
                {
                    return url
                }
                return nil
            }()

            let departureDate: Date? = {
                guard let value = seg.departure else { return nil }
                if let d = value as? Date { return d }
                if let s = value as? String { return ISO8601DateFormatter().date(from: s) }
                return nil
            }()

            let hasTransfers: Bool = {
                if let uid = seg.thread?.uid {
                    return uid.contains("_")
                }
                return false
            }()

            return StationData(
                carrierCode: carrier?.code.map { String($0) },
                logoURL: logoURL,
                stationName: seg.thread?.carrier?.title ?? "Без названия",
                subtitle: seg.thread?.title,
                rightTopText: formatDateAny(seg.departure),
                leftBottomText: formatDateAny(seg.departure),
                middleBottomText: durationText,
                rightBottomText: formatDateAny(seg.arrival),
                departureDate: departureDate,
                hasTransfers: hasTransfers
            )
        } ?? []
    }

    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private func formatDateAny(_ value: Any?) -> String {
        guard let value else { return "" }
        if let d = value as? Date {
            return timeFormatter.string(from: d)
        }
        if let s = value as? String, let d = ISO8601DateFormatter().date(from: s) {
            return timeFormatter.string(from: d)
        }
        return ""
    }

    private func formatAnyDuration(_ seconds: Any?) -> String {
        guard let seconds else { return "" }
        if let i = seconds as? Int { return formatDuration(i) }
        if let i32 = seconds as? Int32 { return formatDuration(Int(i32)) }
        if let i64 = seconds as? Int64 { return formatDuration(Int(i64)) }
        if let str = seconds as? String, let i = Int(str) { return formatDuration(i) }
        return ""
    }

    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let mins = (seconds % 3600) / 60
        return "\(hours) ч \(mins) мин"
    }

    private func handle(_ error: Error) {
        if let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet
        {
            showNoInternet = true
        } else {
            showServerError = true
        }
    }
}
