import SwiftUI

struct MainView: View {

    private static let initialProfiles: [MockProfile] = [
        MockProfile(
            name: "Анна",
            age: 25,
            profession: "Маркетолог",
            location: "Москва · 3 км",
            image: "girl3"
        ),
        MockProfile(
            name: "Катя",
            age: 23,
            profession: "Дизайнер",
            location: "Минск · 5 км",
            image: "girl2"
        ),
        MockProfile(
            name: "Мария",
            age: 27,
            profession: "HR",
            location: "Варшава · 2 км",
            image: "girl"
        )
    ]

    @State private var profiles = Self.initialProfiles

    var body: some View {
        ZStack {
            AuthBackground()

            VStack(spacing: 20) {

                headerBlock

                CardStackView(profiles: $profiles)
                    .frame(width: 340, height: 560)

                buttonBlock

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .onChange(of: profiles) { _, newValue in
            if newValue.isEmpty {
                profiles = Self.initialProfiles
            }
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
}
