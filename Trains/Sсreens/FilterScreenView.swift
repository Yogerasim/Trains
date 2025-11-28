import SwiftUI

struct FilterScreenView: View {
    let timeOptions: [String]
    @Binding var timeSelections: [Bool]
    @Binding var showTransfers: Bool
    let onBack: () -> Void
    let onApply: () -> Void
    
    @State private var showNoInternet = false
    @State private var showServerError = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            contentView
            
            Spacer()
            
            if !showNoInternet && !showServerError {
                PrimaryButton(title: "Применить") {
                    onApply()
                }
                .padding(.bottom, 16)
            }
        }
        .background(DesignSystem.Colors.background)
        .ignoresSafeArea(.keyboard)
    }
    
    @ViewBuilder
    private var contentView: some View {
        
        if showNoInternet {
            PlaceholderView(type: .noInternet)
                .frame(maxHeight: .infinity)
            
        } else if showServerError {
            PlaceholderView(type: .serverError)
                .frame(maxHeight: .infinity)
            
        } else {
            VStack(spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Время отправления")
                        .font(DesignSystem.Fonts.bigTitle2)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
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
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
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
                                set: { newValue in
                                    showTransfers = !newValue
                                }
                            ),
                            style: .radio
                        )
                    }
                }
            }
            .padding([.top, .horizontal], 16)
        }
    }
}


private struct FilterScreenViewPreview: View {
    
    @State private var timeSelections = Array(repeating: false, count: 3)
    @State private var showTransfers = false
    
    var body: some View {
        FilterScreenView(
            timeOptions: [
                "Утро 06:00 - 12:00",
                "День 12:00 - 18:00",
                "Вечер 18:00 - 00:00"
            ],
            timeSelections: $timeSelections,
            showTransfers: $showTransfers,
            onBack: {},
            onApply: {}
        )
    }
}

#Preview {
    FilterScreenViewPreview()
}
