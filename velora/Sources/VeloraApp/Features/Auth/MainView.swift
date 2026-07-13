import SwiftUI

struct MainView: View {

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(spacing: 20) {

                headerBlock

                profileCard

                buttonBlock

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }

    private var headerBlock: some View {
        HStack {

            HeaderButton(
                icon: "line.horizontal.3",
                action: {}
            )

            Spacer()

            HStack(spacing: 4) {
                Text("Velora")
                    .font(.system(size: 34, weight: .bold))

                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.pink)
            }

            Spacer()

            HeaderButton(
                icon: "slider.horizontal.3",
                action: {}
            )
        }
        .padding(.horizontal, 8)
    }

    private var profileCard: some View {
        Image("girl", bundle: .module)
            .resizable()
            .scaledToFill()
            .frame(width: 340, height: 560)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 32))

            .overlay {
                LinearGradient(
                    colors: [
                        .clear,
                        .black.opacity(0.85)
                    ],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 32))
            }

            .overlay(alignment: .top) {
                progressBlock
                    .padding(.horizontal, 16)
                    .padding(.top, 14)
            }

            .overlay(alignment: .bottomLeading) {
                infoBlock
                    .padding(24)
            }
    }

    private var progressBlock: some View {
        HStack(spacing: 6) {

            Capsule()
                .fill(.white)

            Capsule()
                .fill(.white.opacity(0.35))

            Capsule()
                .fill(.white.opacity(0.35))

            Capsule()
                .fill(.white.opacity(0.35))
        }
        .frame(height: 4)
    }

    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Text("Анна, 25")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)

                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.pink)

                Spacer()

                Image(systemName: "info.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
            }

            Label("Маркетолог", systemImage: "briefcase.fill")
                .foregroundStyle(.white)

            Label("Москва · 3 км", systemImage: "location.fill")
                .foregroundStyle(.white)
        }
    }

    private var buttonBlock: some View {
        HStack(spacing: 22) {

            MainButton(
                icon: "arrow.uturn.backward",
                iconColor: .yellow,
                action: {}
            )

            MainButton(
                icon: "xmark",
                iconColor: .pink,
                action: {}
            )

            MainButton(
                icon: "heart.fill",
                iconColor: .pink,
                action: {}
            )

            MainButton(
                icon: "bolt.fill",
                iconColor: .purple,
                action: {}
            )
        }
    }

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
}

//#Preview {
//    MainView()
//}
