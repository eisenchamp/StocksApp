import UIKit

struct StockDetailsModel {
    private (set) var currentStockModel: StockModel?
    
    mutating func setCurrentStockModel(stockModel: StockModel) {
        self.currentStockModel = stockModel
    }
}
