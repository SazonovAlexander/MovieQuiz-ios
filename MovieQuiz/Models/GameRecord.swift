import Foundation


struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    
    func isBetterThan(game: GameRecord) -> Bool {
        return correct > game.correct
    }
}
