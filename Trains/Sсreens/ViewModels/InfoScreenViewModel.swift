import Combine
import Foundation

@MainActor
final class InfoScreenViewModel: ObservableObject {

    // MARK: - State

    @Published private(set) var state: InfoScreenState = .loading

    // MARK: - Content

    @Published private(set) var carrierName: String = ""
    @Published private(set) var logoURL: URL?
    @Published private(set) var infoItems: [InfoItem] = []

    // MARK: - Dependencies

    private let carrierCode: String
    private let carrierService: CarrierServiceProtocol

    // MARK: - Init

    init(
        carrierCode: String,
        carrierService: CarrierServiceProtocol
    ) {
        self.carrierCode = carrierCode
        self.carrierService = carrierService
    }

    // MARK: - Load

    func load() async {
        state = .loading

        do {
            print("📡 Fetching carrier info for code:", carrierCode)

            let response = try await carrierService.getCarrierInfo(code: carrierCode)
            dump(response)

            guard let carrier = response.carrier else {
                state = .error(.serverError)
                return
            }

            carrierName = carrier.title ?? "Перевозчик неизвестен"
            logoURL = carrier.logo.flatMap(URL.init)

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
                }
            ].compactMap { $0 }

            print("✅ Carrier loaded:", carrierName)
            print("📦 Info items:", infoItems.count)

            state = .content

        } catch {
            print("❌ Carrier load error:", error)

            if let urlError = error as? URLError,
               urlError.code == .notConnectedToInternet {
                state = .error(.noInternet)
            } else {
                state = .error(.serverError)
            }
        }
    }
}
enum InfoScreenState {
    case loading
    case content
    case error(InfoScreenError)
}

enum InfoScreenError {
    case noInternet
    case serverError
}
