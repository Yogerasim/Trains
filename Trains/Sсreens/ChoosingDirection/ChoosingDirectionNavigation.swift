enum ChoosingDirectionNavigation: Identifiable {
    case cityFrom
    case cityTo
    case stations

    var id: Self { self }
}

enum ScreenState {
    case content
    case noInternet
    case serverError
}
