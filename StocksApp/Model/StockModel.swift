import UIKit

struct StockModel {
    let ticker: String
    let name: String
    let linkIcon: String
    var isFavorite : Bool
    let stockLiveData: StockLiveData
    
    
    init(ticker: String, name: String, linkIcon: String, stockLiveData: StockLiveData) {
        self.ticker = ticker
        self.name = name
        self.linkIcon = linkIcon
        self.stockLiveData = stockLiveData
        self.isFavorite = false
    }
}

