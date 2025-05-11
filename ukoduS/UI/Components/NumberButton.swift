import SwiftUI

struct NumberButton: View {
    let number: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: 24, weight: .medium))
                .frame(width: 50, height: 50)
                .background(Color.white)
                .foregroundColor(.blue)
                .overlay(
                    Rectangle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    NumberButton(number: 5) {}
        .padding()
        .background(Color.gray.opacity(0.1))
} 