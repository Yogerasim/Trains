import SwiftUI

enum SelectionStyle {
    case checkbox
    case radio
}

struct SelectableRowView: View {
    
    let title: String
    @Binding var isSelected: Bool
    let style: SelectionStyle
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Fonts.regular17)
                .foregroundColor(DesignSystem.Colors.textPrimary)
            
            Spacer()
            
            Button(action: {
                isSelected.toggle()
            }) {
                ZStack {
                    if style == .checkbox {
                        
                        let borderColor = DesignSystem.Colors.textPrimary
                        
                        let fillColor = colorScheme == .dark
                            ? Color.white
                            : Color.black
                        
                        let checkColor = colorScheme == .dark
                            ? Color.black
                            : Color.white
                        
                        Rectangle()
                            .stroke(borderColor, lineWidth: 5)
                            .frame(width: 24, height: 24)
                            .background(
                                isSelected ? fillColor : Color.clear
                            )
                            .cornerRadius(5)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(checkColor)
                        }
                        
                    } else {
                        
                        let borderColor = DesignSystem.Colors.textPrimary
                        
                        let fillColor = colorScheme == .dark
                            ? Color.white
                            : Color.black
                        
                        Circle()
                            .stroke(borderColor, lineWidth: 2)
                            .frame(width: 24, height: 24)
                        
                        if isSelected {
                            Circle()
                                .fill(fillColor)
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .frame(width: 343, height: 60)
        .padding(.horizontal, 16)
    }
}

private struct SelectableRowPreviewContainer: View {
    @State private var checkboxChecked = false
    @State private var radioSelected = true
    
    var body: some View {
        VStack(spacing: 16) {
            SelectableRowView(title: "Утро 06:00 - 12:00", isSelected: $checkboxChecked, style: .checkbox)
            SelectableRowView(title: "Да", isSelected: $radioSelected, style: .radio)
        }
        .padding()
    }
}

#Preview {
    SelectableRowPreviewContainer()
}
