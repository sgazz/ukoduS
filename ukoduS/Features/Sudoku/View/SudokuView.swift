import SwiftUI

struct SudokuView: View {
    @StateObject private var viewModel = SudokuViewModel()
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
    
    private var gridSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let padding: CGFloat = isIPad ? 60 : 20
        
        if isIPad {
            return min(screenWidth, screenHeight) - padding
        } else if isLandscape {
            return screenHeight - padding
        } else if isCompact {
            return min(screenWidth, screenHeight) - padding
        } else {
            return screenWidth - padding
        }
    }
    
    private var buttonWidth: CGFloat {
        if isIPad {
            return 250
        } else if isLandscape {
            return 200
        } else if isCompact {
            return 140
        } else {
            return 160
        }
    }
    
    private var titleFontSize: CGFloat {
        if isIPad {
            return 48
        } else if isLandscape {
            return 36
        } else if isCompact {
            return 28
        } else {
            return 32
        }
    }
    
    private var spacing: CGFloat {
        if isIPad {
            return 30
        } else if isLandscape {
            return 20
        } else if isCompact {
            return 12
        } else {
            return 15
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                if !viewModel.isGameActive {
                    startView
                } else {
                    if isLandscape && !isIPad {
                        landscapeGameView
                    } else {
                        portraitGameView
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
    
    private var startView: some View {
        VStack(spacing: spacing) {
            Text(LocalizedStringKey("app.name"))
                .font(.system(size: titleFontSize, weight: .bold))
                .foregroundColor(.blue)
                .padding(.top, isIPad ? 40 : 20)
            
            Text(LocalizedStringKey("game.select.difficulty"))
                .font(isIPad ? .title2 : .title3)
                .foregroundColor(.secondary)
            
            VStack(spacing: spacing * 0.75) {
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button(action: {
                        withAnimation {
                            viewModel.startNewGame(difficulty: difficulty)
                        }
                    }) {
                        Text(LocalizedStringKey(difficulty.rawValue))
                            .font(isIPad ? .title2 : .title3)
                            .frame(width: buttonWidth)
                            .padding(.vertical, isIPad ? 12 : 8)
                            .background(Color.white)
                            .foregroundColor(.blue)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                
                if let savedGame = viewModel.loadGame() {
                    Button(action: {
                        withAnimation {
                            viewModel.resumeGame(savedGame)
                        }
                    }) {
                        Text(LocalizedStringKey("game.resume"))
                            .font(isIPad ? .title2 : .title3)
                            .frame(width: buttonWidth)
                            .padding(.vertical, isIPad ? 12 : 8)
                            .background(Color.white)
                            .foregroundColor(.green)
                            .overlay(
                                Rectangle()
                                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.top, spacing)
            
            Spacer()
        }
        .padding()
    }
    
    private var landscapeGameView: some View {
        HStack(spacing: spacing) {
            VStack(spacing: spacing) {
                titleView
                sudokuBoard
            }
            .frame(maxWidth: .infinity)
            
            VStack(spacing: spacing) {
                HStack {
                    Text(String(format: NSLocalizedString("game.moves", comment: ""), viewModel.moveCount))
                        .font(isIPad ? .title2 : .title3)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                numberPad
                
                Button(action: {
                    withAnimation {
                        viewModel.endGame()
                    }
                }) {
                    Text(LocalizedStringKey("game.end"))
                        .font(isIPad ? .title2 : .title3)
                        .frame(width: buttonWidth)
                        .padding(.vertical, isIPad ? 12 : 8)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .overlay(
                            Rectangle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    private var portraitGameView: some View {
        VStack(spacing: spacing) {
            HStack {
                Text(String(format: NSLocalizedString("game.moves", comment: ""), viewModel.moveCount))
                    .font(isIPad ? .title2 : .title3)
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
                    .font(isIPad ? .title2 : .title3)
                    .frame(width: buttonWidth)
                    .padding(.vertical, isIPad ? 12 : 8)
                    .background(Color.white)
                    .foregroundColor(.red)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, spacing)
        }
        .padding(.vertical)
    }
    
    private var titleView: some View {
        Text("\(Text(LocalizedStringKey("app.name"))) - \(Text(LocalizedStringKey(viewModel.difficulty.rawValue)))")
            .font(isIPad ? .title : .title2)
            .foregroundColor(.primary)
            .padding(.vertical, spacing * 0.5)
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
        .padding(.horizontal)
    }
    
    private var numberPad: some View {
        VStack(spacing: spacing * 0.75) {
            ForEach(0..<3) { row in
                HStack(spacing: spacing * 0.75) {
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
        .padding(.horizontal)
    }
}

#Preview {
    SudokuView()
} 