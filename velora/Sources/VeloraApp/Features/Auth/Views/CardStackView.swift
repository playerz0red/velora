import SwiftUI

struct CardStackView: View {

    @Binding var profiles: [MockProfile]

    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {

            ForEach(Array(profiles.enumerated().reversed()), id: \.element.id) { index, profile in

                if index == 0 {

                    ProfileCardView(profile: profile)
                        .overlay(alignment: .topLeading) {
                            overlayView
                        }
                        .scaleEffect(1 + abs(offset.width) / 2500)
                        .offset(offset)
                        .rotationEffect(.degrees(offset.width / 25.0))
                        .gesture(dragGesture)
                        .zIndex(100)

                } else {

                    ProfileCardView(profile: profile)
                        .scaleEffect(0.95)
                        .offset(y: CGFloat(index) * 8)
                        .zIndex(Double(index))
                }
            }
        }
    }
}

private extension CardStackView {

    var dragGesture: some Gesture {

        DragGesture()

            .onChanged { value in
                offset = value.translation
            }

            .onEnded { value in

                let threshold: CGFloat = 120

                if value.translation.width > threshold {

                    withAnimation(.easeIn(duration: 0.25)) {
                        offset.width = 1000
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

                        guard !profiles.isEmpty else { return }

                        profiles.removeFirst()

                        offset = .zero
                    }

                } else if value.translation.width < -threshold {

                    withAnimation(.easeIn(duration: 0.25)) {
                        offset.width = -1000
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

                        guard !profiles.isEmpty else { return }

                        profiles.removeFirst()

                        offset = .zero
                    }

                } else {

                    withAnimation(
                        .spring(
                            response: 0.45,
                            dampingFraction: 0.72
                        )
                    ) {
                        offset = .zero
                    }
                }
            }
    }

    @ViewBuilder
    var overlayView: some View {

        if offset.width > 30 {

            Text("LIKE")
                .font(Font.system(size: 40, weight: .bold))
                .foregroundStyle(.green)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green, lineWidth: 4)
                }
                .rotationEffect(.degrees(-15))
                .padding(.top, 50)
                .padding(.leading, 20)
                .opacity(min(offset.width / 120.0, 1))

        } else if offset.width < -30 {

            HStack {

                Spacer()

                Text("NOPE")
                    .font(Font.system(size: 40, weight: .bold))
                    .foregroundStyle(.red)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.red, lineWidth: 4)
                    }
                    .rotationEffect(.degrees(15))
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                    .opacity(min(-offset.width / 120.0, 1))
            }
        }
    }
}
