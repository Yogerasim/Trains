import SwiftUI

struct InfoScreenView: View {
    @StateObject var viewModel: InfoScreenViewModel
    let onBack: () -> Void

    var body: some View {
        VStack {
            content
        }
        .background(DesignSystem.Colors.background)
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .loading:
            ProgressView()

        case .content:
            contentView

        case .error(let error):
            errorView(error)
        }
    }

    private var contentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let url = viewModel.logoURL {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 343)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 16)
                }

                Text(viewModel.carrierName)
                    .font(DesignSystem.Fonts.bold24)
                    .frame(width: 343, alignment: .leading)

                VStack(spacing: .zero) {
                    ForEach(viewModel.infoItems) { item in
                        InfoElementView(
                            title: item.title,
                            subtitle: item.subtitle
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }

    @ViewBuilder
    private func errorView(_ error: InfoScreenError) -> some View {
        switch error {
        case .noInternet:
            PlaceholderView(type: .noInternet)

        case .serverError:
            PlaceholderView(type: .serverError)
        }
    }
}
