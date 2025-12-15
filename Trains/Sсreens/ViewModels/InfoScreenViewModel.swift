import Combine
import Foundation

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

            let response = try await carrierService.getCarrierInfo(code: carrierCode)
            dump(response)

            guard let carrier = response.carrier else {
                showServerError = true
                return
            }

            carrierName = carrier.title ?? "Перевозчик неизвестен"

            logoURL = carrier.logo.flatMap { URL(string: $0) }

            infoItems = [
                carrier.phone.flatMap {
                    $0.isEmpty ? nil : InfoItem(title: "Телефон", subtitle: $0)
                },
                carrier.email.flatMap {
                    $0.isEmpty ? nil : InfoItem(title: "Email", subtitle: $0)
                },
                carrier.url.flatMap {
                    InfoItem(title: "Сайт", subtitle: $0)
                },
                carrier.address.flatMap {
                    InfoItem(title: "Адрес", subtitle: $0)
                },
            ].compactMap { $0 }

            print("✅ Carrier loaded:", carrierName)
            print("📦 Info items:", infoItems.count)

        } catch {
            print("❌ Carrier load error:", error)

            if let urlError = error as? URLError,
               urlError.code == .notConnectedToInternet
            {
                showNoInternet = true
            } else {
                showServerError = true
            }
        }
    }
}
