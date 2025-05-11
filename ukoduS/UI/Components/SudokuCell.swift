import SwiftUI

struct SudokuCell: View {
    let number: Int
    let isSelected: Bool
    let isFixed: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .overlay(
                    Rectangle()
                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                )
            
            if number != 0 {
                Text("\(number)")
                    .font(.system(size: 24, weight: isFixed ? .bold : .regular))
                    .foregroundColor(isFixed ? .black : .blue)
            }
        }
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    SudokuCell(number: 5, isSelected: true, isFixed: true)
        .frame(width: 50, height: 50)
} 