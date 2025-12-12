import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

// MARK: - ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ

/// Извлекает строку из значения Any, поддерживает Optional
private func unwrapAnyToString(_ any: Any) -> String? {
    let mirror = Mirror(reflecting: any)
    if mirror.displayStyle == .optional {
        if let first = mirror.children.first {
            return unwrapAnyToString(first.value)
        }
        return nil
    }
    return any as? String
}

/// Ищет в codes любое поле, где имя содержит "yandex"
private func extractYandexCode(from codes: Any) -> String? {
    let mirror = Mirror(reflecting: codes)

    // 1. Ищем поля с названием, похожим на yandex
    for child in mirror.children {
        guard let label = child.label?.lowercased() else { continue }

        if label.contains("yandex") || label.contains("yandex_code") || label.contains("yandexcode") {
            if let value = unwrapAnyToString(child.value) {
                return value
            }
        }
    }

    // 2. Фолбэк: первая строка
    for child in mirror.children {
        if let value = unwrapAnyToString(child.value) {
            return value
        }
    }

    return nil
}

// MARK: - СЕРВИС

final class RussianCitiesService {

    func getRussianCities(from allStations: AllStations) -> [City] {
        guard let countries = allStations.countries else { return [] }
        guard let russia = countries.first(where: { $0.title == "Россия" }) else { return [] }
        guard let regions = russia.regions else { return [] }

        var result: [City] = []

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

                let stationInfos: [StationInfo] = stations
                    .filter { station in
                        guard let type = station.station_type else { return false }
                        return validTypes.contains(type)
                    }
                    .compactMap { station in
                        guard let title = station.title else { return nil }

                        var codeString: String? = nil
                        if let codes = station.codes {
                            codeString = extractYandexCode(from: codes)
                        }

                        guard let code = codeString, !code.isEmpty else { return nil }

                        return StationInfo(title: title, code: code)
                    }
                    .sorted(by: { $0.title < $1.title })

                guard !stationInfos.isEmpty else { continue }
                guard let cityName = settlement.title else { continue }

                result.append(City(name: cityName, stations: stationInfos))
            }
        }

        return result.sorted { $0.name < $1.name }
    }
}
