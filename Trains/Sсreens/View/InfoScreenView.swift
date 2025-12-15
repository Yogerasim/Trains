import SwiftUI

struct InfoScreenView: View {
    @StateObject var viewModel: InfoScreenViewModel
    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
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
        if viewModel.showNoInternet {
            PlaceholderView(type: .noInternet)

        } else if viewModel.showServerError {
            PlaceholderView(type: .serverError)

        } else if viewModel.isLoading {
            ProgressView()

        } else {
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

                    VStack(spacing: 0) {
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
    }
}
