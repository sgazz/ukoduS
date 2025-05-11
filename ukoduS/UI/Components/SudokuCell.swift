import SwiftUI

struct SudokuCell: View {
    let number: Int
    let isSelected: Bool
    let isFixed: Bool
    
    var body: some View {
        Text(number == 0 ? "" : "\(number)")
            .font(.title2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isSelected ? Color.blue.opacity(0.3) : Color.white)
            .foregroundColor(isFixed ? .black : .blue)
            .border(Color.gray, width: 0.5)
    }
}

#Preview {
    SudokuCell(number: 5, isSelected: true, isFixed: false)
        .frame(width: 40, height: 40)
} 