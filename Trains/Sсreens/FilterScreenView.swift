import SwiftUI

struct FilterScreenView: View {
    let timeOptions: [String]
    @Binding var timeSelections: [Bool]
    @Binding var showTransfers: Bool

    var body: some View {
        VStack(spacing: 0) {

            NavigationTitleView(title: "") {
                print("Назад")
            }

            VStack(spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Время отправления")
                        .font(DesignSystem.Fonts.bigTitle2)
                        .foregroundColor(.black)
                        .frame(width: 343, alignment: .leading)
                        .padding(.leading, 16)

                    VStack(spacing: 16) {
                        ForEach(timeOptions.indices, id: \.self) { index in
                            SelectableRowView(
                                title: timeOptions[index],
                                isSelected: $timeSelections[index],
                                style: .checkbox
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Показывать варианты с пересадками")
                        .font(DesignSystem.Fonts.bigTitle2)
                        .foregroundColor(.black)
                        .frame(width: 343, alignment: .leading)
                        .padding(.leading, 16)

                    VStack(spacing: 16) {
                        SelectableRowView(
                            title: "Да",
                            isSelected: $showTransfers,
                            style: .radio
                        )
                        SelectableRowView(
                            title: "Нет",
                            isSelected: Binding(
                                get: { !showTransfers },
                                set: { newValue in showTransfers = !newValue }
                            ),
                            style: .radio
                        )
                    }
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)

            Spacer()

            PrimaryButton(title: "Применить") {
                print("Применить фильтры")
            }
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
    }
}

struct FilterScreenViewPreview: View {
    @State var timeSelections = Array(repeating: false, count: 3)
    @State var showTransfers = false

    var body: some View {
        FilterScreenView(
            timeOptions: [
                "Утро 06:00 - 12:00",
                "День 12:00 - 18:00",
                "Вечер 18:00 - 00:00"
            ],
            timeSelections: $timeSelections,
            showTransfers: $showTransfers
        )
    }
}

#Preview {
    FilterScreenViewPreview()
}
