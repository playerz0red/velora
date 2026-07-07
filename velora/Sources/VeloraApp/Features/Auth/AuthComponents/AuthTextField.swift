import SwiftUI

struct AuthTextField: View {
    private let title: String
    private let placeholder: String
    private let icon: String
    private var isSecure: Bool = false
    
    @Binding var text: String
    @State private var isPasswordVisible = false
    
    init(
        title: String,
        placeholder: String,
        icon: String,
        isSecure: Bool = false,
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
        self._text = text
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.black)
            
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(.gray)
                
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                        .font(.system(size: 20))
                } else {
                    TextField(placeholder, text: $text)
                        .font(.system(size: 20))
                        .keyboardType(isSecure ? .default : .emailAddress)
                        .autocorrectionDisabled()
                }
                
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .font(.system(size: 22))
                            .foregroundStyle(.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 46)
            .background(Color.white.opacity(0.8))
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.gray.opacity(0.18), lineWidth: 1.2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }
}
