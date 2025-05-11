import Foundation

enum Difficulty: String, CaseIterable, Codable {
    case easy = "difficulty.easy"
    case medium = "difficulty.medium"
    case hard = "difficulty.hard"
    
    var emptyCells: Int {
        switch self {
        case .easy: return 30
        case .medium: return 40
        case .hard: return 50
        }
    }
}

struct GameState: Codable {
    let board: [[Int]]
    let solution: [[Int]]
    let initialBoard: [[Int]]
    let moveCount: Int
    let difficulty: Difficulty
    let isGameActive: Bool
} 