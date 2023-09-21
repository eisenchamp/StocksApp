import UIKit

struct StockGraphData: Codable {
    let closePrices: [Double]
    let highPrices: [Double]
    let lowPrices: [Double]
    let openPrices: [Double]
    let response: String
    let timestamp: [Double]
    let volumeData: [Double]
    
    enum CodingKeys: String, CodingKey {
        case closePrices = "c"
        case highPrices = "h"
        case lowPrices = "l"
        case openPrices = "o"
        case response = "s"
        case timestamp = "t"
        case volumeData = "v"
    }
}
