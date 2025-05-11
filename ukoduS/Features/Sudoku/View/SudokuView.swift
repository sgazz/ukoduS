import SwiftUI

struct SudokuView: View {
    @StateObject private var viewModel = SudokuViewModel()
    private let gridSize: CGFloat = UIScreen.main.bounds.width - 40
    
    var body: some View {
        VStack {
            if !viewModel.isGameActive {
                startView
            } else {
                gameView
            }
        }
        .preferredColorScheme(.light)
    }
    
    private var startView: some View {
        VStack(spacing: 20) {
            Text(LocalizedStringKey("app.name"))
                .font(.largeTitle)
                .padding()
            
            Text(LocalizedStringKey("game.select.difficulty"))
                .font(.title2)
            
            ForEach(Difficulty.allCases, id: \.self) { difficulty in
                Button(action: {
                    viewModel.startNewGame(difficulty: difficulty)
                }) {
                    Text(LocalizedStringKey(difficulty.rawValue))
                        .font(.title3)
                        .frame(width: 200)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private var gameView: some View {
        VStack {
            HStack {
                Text(String(format: NSLocalizedString("game.moves", comment: ""), viewModel.moveCount))
                    .font(.title3)
                Spacer()
            }
            .padding()
            
            titleView
            sudokuBoard
            numberPad
            
            Button(action: {
                viewModel.endGame()
            }) {
                Text(LocalizedStringKey("game.end"))
                    .font(.title3)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
    
    private var titleView: some View {
        Text("\(Text(LocalizedStringKey("app.name"))) - \(Text(LocalizedStringKey(viewModel.difficulty.rawValue)))")
            .font(.largeTitle)
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
        .padding()
    }
    
    private var numberPad: some View {
        VStack(spacing: 10) {
            ForEach(0..<3) { row in
                HStack(spacing: 10) {
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