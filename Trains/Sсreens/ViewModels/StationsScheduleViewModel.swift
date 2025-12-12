import Foundation
import Combine

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

    // MARK: - Load schedule
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

            self.items = convert(result)

        } catch {
            handle(error)
        }
    }

    // MARK: - Convert Segments → StationData
    private func convert(_ data: Segments) -> [StationData] {
        data.segments?.compactMap { seg in
            
            let durationText: String
            if let dur = seg.duration {
                durationText = formatDuration(Int(dur))
            } else {
                durationText = ""
            }

            return StationData(
                logoName: seg.thread?.carrier?.logo ?? "DefaultLogo",
                stationName: seg.thread?.carrier?.title ?? "Без названия",
                subtitle: seg.thread?.title,
                rightTopText: format(seg.departure),
                leftBottomText: format(seg.departure),
                middleBottomText: durationText,
                rightBottomText: format(seg.arrival)
            )
        } ?? []
    }
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()

    private func format(_ date: Date?) -> String {
        guard let date else { return "" }
        return dateFormatter.string(from: date)
    }

    private func formatDuration(_ seconds: Int?) -> String {
        guard let s = seconds else { return "" }
        let hours = s / 3600
        let mins = (s % 3600) / 60
        return "\(hours) ч \(mins) мин"
    }
    private func handle(_ error: Error) {
        if let urlError = error as? URLError,
           urlError.code == .notConnectedToInternet {
            showNoInternet = true
        } else {
            showServerError = true
        }
    }
}
