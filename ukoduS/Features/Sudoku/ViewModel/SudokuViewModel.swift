import SwiftUI

@MainActor
class SudokuViewModel: ObservableObject {
    @Published private(set) var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @Published private(set) var solution: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @Published private(set) var selectedCell: (row: Int, col: Int)? = nil
    @Published private(set) var moveCount: Int = 0
    @Published private(set) var difficulty: Difficulty = .easy
    @Published private(set) var isGameActive: Bool = false
    @Published private(set) var initialBoard: [[Int]] = []
    
    private let storageService: GameStorageServiceProtocol
    
    init(storageService: GameStorageServiceProtocol = GameStorageService()) {
        self.storageService = storageService
    }
    
    func loadGame() -> GameState? {
        return storageService.loadGame()
    }
    
    func resumeGame(_ gameState: GameState) {
        board = gameState.board
        solution = gameState.solution
        initialBoard = gameState.initialBoard
        moveCount = gameState.moveCount
        difficulty = gameState.difficulty
        isGameActive = gameState.isGameActive
    }
    
    func startNewGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        generateNewGame()
        moveCount = 0
        isGameActive = true
        saveGame()
    }
    
    func endGame() {
        isGameActive = false
    }
    
    func makeMove(_ number: Int, at position: (row: Int, col: Int)) {
        guard isValidMove(number, at: position) else { return }
        board[position.row][position.col] = number
        moveCount += 1
        
        if isGameComplete() {
            endGame()
        }
        
        saveGame()
    }
    
    func selectCell(at position: (row: Int, col: Int)) {
        selectedCell = position
    }
    
    private func generateNewGame() {
        solution = generateSolution()
        board = solution
        
        let cellsToRemove = difficulty.emptyCells
        var removedCells = 0
        
        while removedCells < cellsToRemove {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            
            if board[row][col] != 0 {
                board[row][col] = 0
                removedCells += 1
            }
        }
        
        initialBoard = board
    }
    
    private func generateSolution() -> [[Int]] {
        var solution = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        
        for box in 0..<3 {
            let numbers = Array(1...9).shuffled()
            for i in 0..<3 {
                for j in 0..<3 {
                    solution[box * 3 + i][box * 3 + j] = numbers[i * 3 + j]
                }
            }
        }
        
        _ = solveSudoku(&solution)
        
        return solution
    }
    
    private func solveSudoku(_ board: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == 0 {
                    for num in 1...9 {
                        if isValidPlacement(board, row: row, col: col, num: num) {
                            board[row][col] = num
                            
                            if solveSudoku(&board) {
                                return true
                            }
                            
                            board[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }
    
    private func isValidPlacement(_ board: [[Int]], row: Int, col: Int, num: Int) -> Bool {
        // Check row
        for x in 0..<9 {
            if board[row][x] == num {
                return false
            }
        }
        
        // Check column
        for x in 0..<9 {
            if board[x][col] == num {
                return false
            }
        }
        
        // Check 3x3 box
        let boxRow = row / 3 * 3
        let boxCol = col / 3 * 3
        
        for i in 0..<3 {
            for j in 0..<3 {
                if board[boxRow + i][boxCol + j] == num {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func isValidMove(_ number: Int, at position: (row: Int, col: Int)) -> Bool {
        if initialBoard[position.row][position.col] != 0 {
            return false
        }
        
        for col in 0..<9 {
            if board[position.row][col] == number {
                return false
            }
        }
        
        for row in 0..<9 {
            if board[row][position.col] == number {
                return false
            }
        }
        
        let boxRow = position.row / 3 * 3
        let boxCol = position.col / 3 * 3
        
        for row in boxRow..<boxRow + 3 {
            for col in boxCol..<boxCol + 3 {
                if board[row][col] == number {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func isGameComplete() -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == 0 || board[row][col] != solution[row][col] {
                    return false
                }
            }
        }
        return true
    }
    
    private func saveGame() {
        let gameState = GameState(
            board: board,
            solution: solution,
            initialBoard: initialBoard,
            moveCount: moveCount,
            difficulty: difficulty,
            isGameActive: isGameActive
        )
        storageService.saveGame(gameState)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @StateObject private var viewModel = SudokuViewModel()
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Game State Preview")
                    .font(.title)
                    .padding()
                
                Group {
                    Text("Is Game Active: \(viewModel.isGameActive ? "Yes" : "No")")
                    Text("Difficulty: \(viewModel.difficulty.rawValue)")
                    Text("Move Count: \(viewModel.moveCount)")
                }
                .font(.headline)
                
                if let selected = viewModel.selectedCell {
                    Text("Selected Cell: (\(selected.row), \(selected.col))")
                        .font(.headline)
                }
                
                VStack(spacing: 1) {
                    ForEach(0..<9) { row in
                        HStack(spacing: 1) {
                            ForEach(0..<9) { col in
                                Text("\(viewModel.board[row][col])")
                                    .frame(width: 30, height: 30)
                                    .background(
                                        Rectangle()
                                            .fill(viewModel.initialBoard[row][col] != 0 ? Color.gray.opacity(0.2) : Color.white)
                                    )
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                                    )
                            }
                        }
                    }
                }
                .background(Color.black)
                .padding()
                
                Button("Start New Game") {
                    viewModel.startNewGame(difficulty: .easy)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding()
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
} 