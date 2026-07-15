import SwiftUI

struct HeaderButton: View {

    private let icon: String
    private let action: () -> Void

    init(
        icon: String,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
    }
    
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

