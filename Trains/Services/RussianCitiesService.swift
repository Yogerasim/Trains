import OpenAPIRuntime
import Foundation
import OpenAPIURLSession


// Протокол сервиса
protocol RussianCitiesServiceProtocol {
    /// Фильтрует все города и возвращает только российские с железнодорожными станциями
    func getRussianCities(from allStations: AllStations) -> [City]
}

// Конкретная реализация
final class RussianCitiesService {
    func getRussianCities(from allStations: AllStations) -> [City] {
        guard let countries = allStations.countries else { return [] }

        guard let russia = countries.first(where: { $0.title == "Россия" }) else { return [] }

        guard let regions = russia.regions else { return [] }

        var result: [City] = []

        // Все допустимые типы ЖД-станций
        let validTypes: Set<String> = [
            "train",
            "train_station",
            "station",
            "platform",
            "stop",
            "checkpoint",
            "halt"
        ]

        for region in regions {
            guard let settlements = region.settlements else { continue }

            for settlement in settlements {
                guard let stations = settlement.stations else { continue }

                // Фильтруем по типу
                let trainStations = stations
                    .filter { station in
                        guard let type = station.station_type else { return false }
                        return validTypes.contains(type)
                    }
                    .compactMap { $0.title }
                    .sorted()

                guard !trainStations.isEmpty else { continue }

                guard let cityName = settlement.title, !cityName.isEmpty else { continue }

                result.append(City(name: cityName, stations: trainStations))
            }
        }

        let sorted = result.sorted { $0.name < $1.name }
        print("🔥 Loaded Russian cities with stations: \(sorted.count)")
        return sorted
    }
}
extension StationsListService {
    
    func testRussianCitiesGrouped(allStations: AllStations) {
        let service = RussianCitiesService()
        let cities = service.getRussianCities(from: allStations)
        
        // Группируем города по первой букве
        let grouped = Dictionary(grouping: cities) { city in
            city.name.first?.uppercased() ?? "#"
        }
        
        // Сортируем по алфавиту
        let sortedKeys = grouped.keys.sorted()
        
        for key in sortedKeys {
            print("=== \(key) ===")
            let citiesForKey = grouped[key]!.sorted { $0.name < $1.name }
            for city in citiesForKey.prefix(10) { // первые 10 городов для каждой буквы
                print("Город: \(city.name), станции: \(city.stations.count)")
            }
            if citiesForKey.count > 10 {
                print("... ещё \(citiesForKey.count - 10) городов")
            }
        }
        
        print("✅ Всего российских городов с ж/д станциями: \(cities.count)")
    }
}
