import SwiftUI

struct AuthLogo: View {

    private let title: String
    private let subtitle: String
    
    init(
        title: String,
        subtitle: String
    ) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.fill")
                .font(.system(size: 34))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.pink,
                                 Color(red: 0.95, green: 0.68, blue: 0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(title)
                .font(.system(size: 34, weight: .bold))

            Text(subtitle)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}
