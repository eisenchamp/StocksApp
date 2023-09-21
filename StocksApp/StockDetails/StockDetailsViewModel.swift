import Foundation

protocol StockDetailsViewModelOutput {
    func updateGraph(stockGraphData: StockGraphData)
}

protocol StockDetailsViewModelProvider {
    
    func setStockDetailsView(stockDetailsView: StockDetailsViewModelOutput)
    
    func getCurrentStockModel() -> StockModel?
    
    func setCurrentStockModel(stockModel: StockModel)
    
    func loadGraphData(period: String)
    
}


class StockDetailsViewModel: StockDetailsViewModelProvider{
    
    //MARK: - Properties
    
    private let stockManager: StockManager
    private var stockDetailsModel: StockDetailsModel
    private var stockDetailsView: StockDetailsViewModelOutput?
    
    //MARK: - Lifecycle
    
    init(stockDetailsModel: StockDetailsModel, stockManager: StockManager) {
        self.stockManager = stockManager
        self.stockDetailsModel = stockDetailsModel
    }
    
    //MARK: - Internal Methods
    
    func setStockDetailsView(stockDetailsView: StockDetailsViewModelOutput) {
        self.stockDetailsView = stockDetailsView
    }
    
    func getCurrentStockModel() -> StockModel? {
        return stockDetailsModel.currentStockModel
    }
    
    
    func setCurrentStockModel(stockModel: StockModel) {
        stockDetailsModel.setCurrentStockModel(stockModel: stockModel)
    }
    
    
    func loadGraphData(period: String) {
        guard let currentStockModel = stockDetailsModel.currentStockModel else {
            return
        }
        
        stockManager.performRequestGraphData(with: currentStockModel.ticker, period: period , completion: {  stockGraphData, error in
            if error != nil { return }
            guard let stockGraphData = stockGraphData else {
                print("THIS IS ERROR:")
                return
            }
            self.stockDetailsView?.updateGraph(stockGraphData: stockGraphData)
        })
    }
    
}
