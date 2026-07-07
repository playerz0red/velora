import SwiftUI

struct AuthDivider: View {
    
    private let title: String
    
    var body: some View {
        HStack(spacing: 5) {
            Rectangle()
                .fill(Color.gray.opacity(0.22))
                .frame(height: 1)
            
            Text("или")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
            
            Rectangle()
                .fill(Color.gray.opacity(0.22))
                .frame(height: 1)
        }
    }
}

