import SwiftUI

struct NumberButton: View {
    let number: Int
    let action: () -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .compact
    }
    
    private var isCompact: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .compact
    }
    
    private var buttonSize: CGFloat {
        if isIPad {
            return 70
        } else if isLandscape {
            return 60
        } else if isCompact {
            return 40
        } else {
            return 45
        }
    }
    
    private var fontSize: CGFloat {
        if isIPad {
            return 28
        } else if isLandscape {
            return 24
        } else if isCompact {
            return 18
        } else {
            return 20
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.system(size: fontSize, weight: .medium))
                .frame(width: buttonSize, height: buttonSize)
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