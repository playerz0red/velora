import SwiftUI

struct AuthFooter: View {
    
    private var title: String
    private var buttonLabel: String
    private let action: () -> Void
    
    init(
        title: String,
        buttonLabel: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.buttonLabel = buttonLabel
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .foregroundStyle(.secondary)
            
            Button (action: action) {
                Text(buttonLabel)
                    .fontWeight(.semibold)
                    .foregroundStyle(.pink)
            }
        }
        .font(.system(size: 16))
        .padding(.top, 4)
    }
}
