import SwiftUI

struct PlaceholderView: View {

    let type: PlaceholderType

    var body: some View {
        VStack(spacing: 16) {

            if let imageName = type.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 223, height: 223)
            }

            Text(type.title)
                .font(DesignSystem.Fonts.bigTitle2)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16)
    }
}
#Preview {
    ScrollView {
        VStack(spacing: 40) {

            PlaceholderView(type: .noInternet)
                .frame(height: 400)

            PlaceholderView(type: .serverError)
                .frame(height: 400)

            PlaceholderView(type: .emptyMessage)
                .frame(height: 300)

            PlaceholderView(type: .noData)
                .frame(height: 300)
        }
        .padding()
    }
}
enum PlaceholderType {
    case noInternet
    case serverError
    case emptyMessage
    case noData
}

extension PlaceholderType {
    var title: String {
        switch self {
        case .noInternet:
            return "Нет интернета"
        case .serverError:
            return "Ошибка сервера"
        case .emptyMessage:
            return "Вариантов нет"
        case .noData:
            return "Город не найден"
        }
    }

    var imageName: String? {
        switch self {
        case .noInternet:
            return "NoInternet"
        case .serverError:
            return "ServerError"
        case .emptyMessage,
             .noData:
            return nil
        }
    }
}
