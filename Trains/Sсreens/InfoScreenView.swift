import SwiftUI

struct InfoScreenView: View {
    
    let carrierName: String
    let imageName: String
    let infoItems: [InfoItem]
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 343)
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                    
                    Text(carrierName)
                        .font(DesignSystem.Fonts.bigTitle2)
                        .foregroundColor(.black)
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
        .background(Color.white)
        .ignoresSafeArea(.keyboard)
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
