import SwiftUI

struct MainButton: View {

    private let icon: String
    private let iconColor: Color
    private let action: () -> Void

    init(
        icon: String,
        iconColor: Color,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 68, height: 68)
                .background(.white)
                .clipShape(Circle())
                .shadow(
                    color: .black.opacity(0.08),
                    radius: 10
                )
        }
    }
}
