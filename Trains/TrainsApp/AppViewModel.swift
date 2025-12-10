import Foundation
import Combine
import OpenAPIRuntime
import OpenAPIURLSession

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
        
        // StationsListService
        if services.stationsList {
            let s = StationsListService(client: client, apiKey: apiKey)
            Task { await s.debugPrintAllStations() }
        }
        
        // ThreadService
        if services.threadService {
            let t = ThreadService(client: client, apikey: apiKey)
            Task { await t.debugPrintRoute(uid: "SU-1524_251101_c26_12", date: "2025-12-10") }
        }
        
        // SearchService (рабочие коды станций)
        if services.searchService {
            let search = SearchService(client: client, apikey: apiKey)
            Task { await debugPrintSchedule(search: search, from: "s9600213", to: "s9623328", date: "2025-12-10") }
        }
        
        // CarrierService (берем код из ThreadService)
        if services.carrierService {
            let carrier = CarrierService(client: client, apikey: apiKey)
            Task { await debugPrintCarrier(carrier: carrier, code: "680") } // Проверить код из ThreadService
        }
        
        // CopyrightService
        if services.copyrightService {
            let cr = CopyrightService(client: client, apikey: apiKey)
            Task { await debugPrintCopyright(service: cr) }
        }
        
        // NearestSettlementService (работают реальные координаты Москвы)
        if services.nearestSettlementService {
            let nearestCity = NearestSettlementService(client: client, apikey: apiKey)
            Task { await debugPrintNearestCity(service: nearestCity, lat: 59.864177, lng: 30.319163, distance: 50) }
        }
        
        // NearestStationsService (реальные координаты + уменьшенный радиус)
        if services.nearestStationsService {
            let nearestStations = NearestStationsService(client: client, apikey: apiKey)
            Task { await debugPrintNearestStations(service: nearestStations, lat: 59.864177, lng: 30.319163, distance: 50) }
        }
        
        // ScheduleService (рабочий код станции)
        if services.scheduleService {
            let schedule = ScheduleService(client: client, apikey: apiKey)
            Task { await debugPrintScheduleForStation(service: schedule, station: "s9600213", date: "2025-12-10") }
        }
    }
    
    // MARK: - Debug helpers
    
    private func debugPrintSchedule(search: SearchService, from: String, to: String, date: String?) async {
        print("=== DEBUG SEARCH START ===")
        do {
            let result = try await search.getScheduleBetweenStations(from: from, to: to, date: date)
            print(result)
        } catch { print("❌ Error SEARCH: \(error)") }
        print("=== DEBUG SEARCH END ===")
    }
    
    private func debugPrintCarrier(carrier: CarrierService, code: String) async {
        print("=== DEBUG CARRIER START ===")
        do {
            let result = try await carrier.getCarrierInfo(code: code)
            print(result)
        } catch { print("❌ Error CARRIER: \(error)") }
        print("=== DEBUG CARRIER END ===")
    }
    
    private func debugPrintCopyright(service: CopyrightService) async {
        print("=== DEBUG COPYRIGHT START ===")
        do {
            let result = try await service.getCopyright()
            print(result)
        } catch { print("❌ Error COPYRIGHT: \(error)") }
        print("=== DEBUG COPYRIGHT END ===")
    }
    
    private func debugPrintNearestCity(service: NearestSettlementService, lat: Double, lng: Double, distance: Int) async {
        print("=== DEBUG NEAREST CITY START ===")
        do {
            let result = try await service.getNearestCity(lat: lat, lng: lng, distance: distance)
            print(result)
        } catch { print("❌ Error NEAREST CITY: \(error)") }
        print("=== DEBUG NEAREST CITY END ===")
    }
    
    private func debugPrintNearestStations(service: NearestStationsService, lat: Double, lng: Double, distance: Int) async {
        print("=== DEBUG NEAREST STATIONS START ===")
        do {
            let result = try await service.getNearestStations(lat: lat, lng: lng, distance: distance)
            print(result)
        } catch { print("❌ Error NEAREST STATIONS: \(error)") }
        print("=== DEBUG NEAREST STATIONS END ===")
    }
    
    private func debugPrintScheduleForStation(service: ScheduleService, station: String, date: String?) async {
        print("=== DEBUG STATION SCHEDULE START ===")
        do {
            let result = try await service.getStationSchedule(station: station, date: date)
            print(result)
        } catch { print("❌ Error STATION SCHEDULE: \(error)") }
        print("=== DEBUG STATION SCHEDULE END ===")
    }
}
