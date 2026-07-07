import SwiftUI

struct AuthFooter: View {
    
    private var title: String
    private var buttonLabel: String
    
    init(
        title: String,
        buttonLabel: String
    ) {
        self.title = title
        self.buttonLabel = buttonLabel
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .foregroundStyle(.secondary)
            
            Button {
            } label: {
                Text(buttonLabel)
                    .fontWeight(.semibold)
                    .foregroundStyle(.pink)
            }
        }
        .font(.system(size: 16))
        .padding(.top, 4)
    }
}
