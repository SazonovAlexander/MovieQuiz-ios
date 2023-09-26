import Foundation


class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    var totalAccurancy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
            
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let game = GameRecord(correct: count, total: amount, date: Date())
        if game.isBetterThan(game: bestGame) {
            bestGame = game
        }
        gamesCount = gamesCount + 1
        print(Double(count) / Double(amount))
        totalAccurancy = (totalAccurancy * Double(gamesCount - 1) + Double(count) / Double(amount)) / Double(gamesCount)
    }
    
    
}
