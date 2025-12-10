import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    
    private let services = ServicesControl.shared
    private var cancellables = Set<AnyCancellable>()
    
    private let client = APIConfig.client
    private let apiKey = APIConfig.apiKey
    
    init() {
        // Если включены тесты, запускаем
        if services.runTests {
            runTests()
        }
        
        // Слежение за изменением флага runTests
        services.$runTests
            .sink { [weak self] run in
                if run {
                    self?.runTests()
                } else {
                    print("Tests disabled")
                }
            }
            .store(in: &cancellables)
    }
    
    /// Запуск тестов включённых сервисов
    private func runTests() {
        print("Running enabled API tests...")
        
        if services.stationsList {
            let stationsService = StationsListService(client: client, apiKey: apiKey)
            stationsService.testFetchStationsList(limitToOneCountry: true)
        }
    }
}
