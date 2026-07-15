import SwiftUI

struct ProfileCardView: View {

    private let profile: MockProfile
    
    init(
        profile: MockProfile
    ) {
        self.profile = profile
    }

    var body: some View {
        Image(profile.image, bundle: .module)
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

            .overlay(alignment: .bottomLeading) {
                infoBlock
                    .padding(24)
            }
    }

    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {

                Text("\(profile.name), \(profile.age)")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)

                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.pink)

                Spacer()

                Image(systemName: "info.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
            }

            Label(profile.profession, systemImage: "briefcase.fill")
                .foregroundStyle(.white)

            Label(profile.location, systemImage: "location.fill")
                .foregroundStyle(.white)
        }
    }
}


