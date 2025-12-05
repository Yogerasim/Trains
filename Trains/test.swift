import SwiftUI

struct Test: View {
    @State var showNewView = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .onTapGesture {
                    showNewView = true
                }
            if showNewView {
                Text("Привет, Практикум!")
                    .padding()
            }
            Spacer()
        }
        .frame(height: 100)
        .padding()
    }
}


#Preview {
    Test()
}
