import SwiftUI

struct HeaderButton: View {

    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.black)
                .padding(10)
                .background(.white)
                .clipShape(Circle())
        }
    }
}

