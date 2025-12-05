import SwiftUI

struct InfoScreenView: View {
    
    let carrierName: String
    let imageName: String
    let infoItems: [InfoItem]
    @State private var showNoInternet = false
    @State private var showServerError = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            contentView
            
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
            ScrollView {
                VStack(spacing: 16) {
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 343)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                    
                    Text(carrierName)
                        .font(DesignSystem.Fonts.bold24)
                        .foregroundStyle(DesignSystem.Colors.textPrimary)
                        .frame(width: 343, alignment: .leading)
                    
                    VStack(spacing: 0) {
                        ForEach(infoItems) { item in
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


struct InfoItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}

#Preview {
    InfoScreenView(
        carrierName: "ОАО «РЖД»",
        imageName: "Image",
        infoItems: [
            InfoItem(title: "Телефон", subtitle: "+7 (904) 329-27-71"),
            InfoItem(title: "Email", subtitle: "i.lozgkina@yandex.ru")
        ]
    )
}
