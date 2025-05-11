import SwiftUI

struct SudokuView: View {
    @StateObject private var viewModel = SudokuViewModel()
    private let gridSize: CGFloat = UIScreen.main.bounds.width - 40
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                if !viewModel.isGameActive {
                    startView
                } else {
                    gameView
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private var startView: some View {
        VStack(spacing: 30) {
            Text(LocalizedStringKey("app.name"))
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.blue)
                .padding(.top, 50)
            
            Text(LocalizedStringKey("game.select.difficulty"))
                .font(.title2)
                .foregroundColor(.secondary)
            
            VStack(spacing: 15) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button(action: {
                        withAnimation {
                            viewModel.startNewGame(difficulty: difficulty)
                        }
                    }) {
                        Text(LocalizedStringKey(difficulty.rawValue))
                            .font(.title3)
                            .frame(width: 200)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue)
                                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                            .foregroundColor(.white)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
    
    private var gameView: some View {
        VStack(spacing: 20) {
            HStack {
                Text(String(format: NSLocalizedString("game.moves", comment: ""), viewModel.moveCount))
                    .font(.title3)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal)
            
            titleView
            sudokuBoard
            numberPad
            
            Button(action: {
                withAnimation {
                    viewModel.endGame()
                }
            }) {
                Text(LocalizedStringKey("game.end"))
                    .font(.title3)
                    .frame(width: 200)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.red)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    )
                    .foregroundColor(.white)
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, 20)
        }
        .padding(.vertical)
    }
    
    private var titleView: some View {
        Text("\(Text(LocalizedStringKey("app.name"))) - \(Text(LocalizedStringKey(viewModel.difficulty.rawValue)))")
            .font(.title)
            .foregroundColor(.primary)
            .padding()
    }
    
    private var sudokuBoard: some View {
        VStack(spacing: 1) {
            ForEach(0..<9) { row in
                HStack(spacing: 1) {
                    ForEach(0..<9) { col in
                        SudokuCell(
                            number: viewModel.board[row][col],
                            isSelected: viewModel.selectedCell?.row == row && viewModel.selectedCell?.col == col,
                            isFixed: viewModel.initialBoard[row][col] != 0
                        )
                        .frame(width: gridSize/9, height: gridSize/9)
                        .onTapGesture {
                            viewModel.selectCell(at: (row, col))
                        }
                    }
                }
            }
        }
        .background(Color.black)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding()
    }
    
    private var numberPad: some View {
        VStack(spacing: 15) {
            ForEach(0..<3) { row in
                HStack(spacing: 15) {
                    ForEach(1...3, id: \.self) { num in
                        NumberButton(number: row * 3 + num) {
                            if let selected = viewModel.selectedCell {
                                viewModel.makeMove(row * 3 + num, at: selected)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    SudokuView()
} 