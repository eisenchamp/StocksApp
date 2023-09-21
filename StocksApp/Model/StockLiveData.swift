import UIKit

struct StockLiveData: Codable {
    let currentPrice: Double
    let change: Double
    let changePercent: Double
    
    enum CodingKeys: String, CodingKey {
            case currentPrice = "c"
            case change = "d"
            case changePercent = "dp"
    }
}
