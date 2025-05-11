import Foundation

protocol GameStorageServiceProtocol {
    func saveGame(_ gameState: GameState)
    func loadGame() -> GameState?
}

class GameStorageService: GameStorageServiceProtocol {
    private let userDefaults: UserDefaults
    private let gameStateKey = "savedGame"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveGame(_ gameState: GameState) {
        if let encoded = try? JSONEncoder().encode(gameState) {
            userDefaults.set(encoded, forKey: gameStateKey)
        }
    }
    
    func loadGame() -> GameState? {
        guard let savedData = userDefaults.data(forKey: gameStateKey) else {
            return nil
        }
        return try? JSONDecoder().decode(GameState.self, from: savedData)
    }
} 