import Foundation


protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    var totalAccurancy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    
}
