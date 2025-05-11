import SwiftUI

struct SudokuCell: View {
    let number: Int
    let isSelected: Bool
    let isFixed: Bool
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
        Text(number == 0 ? "" : "\(number)")
            .font(.system(size: fontSize, weight: isFixed ? .bold : .regular))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.white)
            .foregroundColor(isFixed ? .black : .blue)
    }
}

#Preview {
    SudokuCell(number: 5, isSelected: true, isFixed: true)
        .frame(width: 50, height: 50)
        .background(Color.gray.opacity(0.1))
} 