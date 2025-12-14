import Foundation
import Combine

@MainActor
final class InfoScreenViewModel: ObservableObject {

    @Published var carrierName: String = ""
    @Published var logoURL: URL?
    @Published var infoItems: [InfoItem] = []

    @Published var isLoading = false
    @Published var showNoInternet = false
    @Published var showServerError = false

    private let carrierCode: String
    private let carrierService: CarrierServiceProtocol

    init(
        carrierCode: String,
        carrierService: CarrierServiceProtocol
    ) {
        self.carrierCode = carrierCode
        self.carrierService = carrierService
    }

    func load() async {
        isLoading = true
        showNoInternet = false
        showServerError = false
        defer { isLoading = false }

        do {
            print("📡 Fetching carrier info for code:", carrierCode)
            let carrier = try await carrierService.getCarrierInfo(code: carrierCode)
            dump(carrier)

//            carrierName = carrier.title ?? "Перевозчик"
//            logoURL = carrier.logo.flatMap { URL(string: $0) }
//
//            infoItems = [
//                carrier.phone.map { InfoItem(title: "Телефон", subtitle: $0) },
//                carrier.email.map { InfoItem(title: "Email", subtitle: $0) },
//                carrier.url.map { InfoItem(title: "Сайт", subtitle: $0) }
//            ].compactMap { $0 }

        } catch {
            if let urlError = error as? URLError,
               urlError.code == .notConnectedToInternet {
                showNoInternet = true
            } else {
                showServerError = true
            }
        }
    }
}
