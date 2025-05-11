import SwiftUI

struct SudokuCell: View {
    let number: Int
    let isSelected: Bool
    let isFixed: Bool
    
    var body: some View {
        Text(number == 0 ? "" : "\(number)")
            .font(.system(size: 24, weight: isFixed ? .bold : .regular))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isSelected ? Color.blue.opacity(0.2) : Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            )
            .foregroundColor(isFixed ? .black : .blue)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 10) {
        SudokuCell(number: 5, isSelected: true, isFixed: false)
        SudokuCell(number: 3, isSelected: false, isFixed: true)
        SudokuCell(number: 0, isSelected: false, isFixed: false)
    }
    .frame(width: 120, height: 120)
    .padding()
    .background(Color.gray.opacity(0.1))
} 