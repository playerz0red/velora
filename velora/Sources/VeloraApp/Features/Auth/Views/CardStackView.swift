import SwiftUI

struct CardStackView: View {

    @Binding private var profiles: [MockProfile]

    @State private var offset: CGSize = .zero
   
    init(profiles: Binding<[MockProfile]>) {
        self._profiles = profiles
    }

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

private enum OverlayPosition {
    case leading
    case trailing

    var text: String {
        switch self {
        case .leading:
            return "LIKE"
        case .trailing:
            return "NOPE"
        }
    }

    var color: Color {
        switch self {
        case .leading:
            return .green
        case .trailing:
            return .red
        }
    }

    var rotation: Double {
        switch self {
        case .leading:
            return -15
        case .trailing:
            return 15
        }
    }

    var alignment: Alignment {
        switch self {
        case .leading:
            return .topLeading
        case .trailing:
            return .topTrailing
        }
    }

    var edge: Edge.Set {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
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
            overlayView(position: .leading)
        } else if offset.width < -30 {
            overlayView(position: .trailing)
        }
    }

    func overlayView(position: OverlayPosition) -> some View {

        Text(position.text)
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(position.color)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(position.color, lineWidth: 4)
            }
            .rotationEffect(.degrees(position.rotation))
            .padding(.top, 50)
            .padding(position.edge, 20)
            .frame(maxWidth: .infinity, alignment: position.alignment)
            .opacity(
                min(
                    abs(offset.width) / 120.0,
                    1
                )
            )
    }
}
