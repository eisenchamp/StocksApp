import UIKit

protocol stockManagerDelegate{
    func getStockDicList(ticker:String) -> StockModel?
    
    func getStockList() -> [StockData]
    
    func getFavList() -> [StockData]
    
    func addtoFav(ticker : String)
    
    func removeFromFav(ticker : String) -> Bool
    
    func getFavListCount() -> Int
    
    func isFav(ticker : String) -> Bool
    
    func setFavToUserDefaults(val: Bool, ticker : String)
    
    func appendSearchList(stockData: StockData)
    
    func clearSearchList()
    
    func getSearchHistoryList() -> [String]
    
    func addStockToHistory(ticker: String)
    
    func setSearchHistoryToUserDefaults()
    
    func getSearchList() -> [StockData]
    //
    //    func didUpdateStock(_ stockManager: StockManager, stockLiveData: StockLiveData)
    //
    //    func didFailWithError(error: Error)
}

struct GraphParameters {
    let resolution: String
    let from: String
    let to: String
}

class StockManager{
    let semaphore = DispatchSemaphore(value: 1)
    
    func setStockModel(_ stockModel: StockModel, ticker: String) {
        
        semaphore.wait()
        self.stocksModelDic[ticker] = stockModel
        semaphore.signal()
        
    }
    
    var vm : ViewModelProtocol
    init(vm: ViewModelProtocol) {
        self.vm = vm
        self.setupStocksList()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let baseURL = "https://finnhub.io/api/v1/quote"
    let apiKey = "cf15vliad3i62koq9dr0cf15vliad3i62koq9drg"
    var stocksList: [StockData] = []
    var stocksModelDic: [String:StockModel] = [:]
    var stockLiveData: StockLiveData?
    var favoriteList : [StockData] = []
    var defaults = UserDefaults.standard
    var searchList: [StockData] = []
    var searchHistoryList: [String] = []
    
    
    let baseURLforGraph = "https://finnhub.io/api/v1/stock/candle?"
    let from = "1572651390"
    let to = "1575243390"
    let resolution = "D"
    
    func setupStocksList () {
        stocksList = getStockProfiles()
        
        let lockQueue = DispatchQueue(label: "name.lock.queue")
        
        var count = 1
        for item in stocksList {
            self.performRequest(with: item.ticker) { stockData, error in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let stockData = stockData else {
                    return
                }
                
                let stockModel = StockModel(ticker: item.ticker, name: item.name, linkIcon: item.logo, stockLiveData: stockData)
                DispatchQueue.global().async {
                    lockQueue.async {
                        self.stocksModelDic[item.ticker] = stockModel
                    }
                }
                
            }
            count = count+1
            if(count == 30) {break}
        }
        
    }
    
    func getStockProfiles() -> [StockData] {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let json = try JSONDecoder().decode([StockData].self, from: data)
                return json
            } catch {
                return []
            }
        }
        return []
    }
    
    func performRequest(with stockTicker: String, completion: @escaping (StockLiveData?, Error?) -> Void) {
        let urlString = baseURL + "?token=" + apiKey + "&symbol=" + stockTicker
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                guard let stockLiveData = self.parseJSON(data: data) else {
                    completion(nil, nil)
                    return
                }
                completion(stockLiveData, nil)
            }
            task.resume()
            
        }
    }
    
    func parseJSON(data: Data) -> StockLiveData? {
        let decoder = JSONDecoder()
        do{
            let decodedStockLiveData = try decoder.decode(StockLiveData.self, from: data)
            return decodedStockLiveData
        } catch {
            return nil
        }
    }
    
    func getGraphParameters(period: String) -> GraphParameters { //returns [resolution, from, to]
        let to = Int(NSDate().timeIntervalSince1970)
        var from = 0
        var resolution = ""
        
        switch period {
        case timePeriod.all:
            from = to - 360 * 24 * 3600
            resolution = "W"
        case timePeriod.year:
            from = to - 360 * 24 * 3600
            resolution = "W"
        case timePeriod.sixMonth:
            from = to - 6 * 30 * 24 * 3600
            resolution = "W"
        case timePeriod.month:
            from = to - 30 * 24 * 3600
            resolution = "D"
        case timePeriod.week:
            from = to - 7 * 24 * 3600
            resolution = "60"
        case timePeriod.day:
            from = to - 24 * 3600
            resolution = "15"
        default:
            from = to - 24 * 3600
            resolution = "W"
        }
        
        return GraphParameters(resolution: resolution, from: String(from), to: String(to))
    }
    
    func performRequestGraphData(with stockTicker: String, period: String , completion: @escaping (StockGraphData?, Error?) -> Void) {
        
        let parameters = getGraphParameters(period: period)
        
        let urlString = baseURLforGraph + "resolution=" + parameters.resolution + "&from=" + parameters.from + "&to=" + parameters.to + "&token=" + apiKey + "&symbol=" + stockTicker
        print(urlString)
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                guard let stockGraphData = self.parseJSONgraph(data: data) else {
                    completion(nil, nil)
                    return
                }
                completion(stockGraphData, nil)
                
            }
            task.resume()
        }
    }
    
    func parseJSONgraph(data: Data) -> StockGraphData? {
        let decoder = JSONDecoder()
        do{
            let decodedStockGraphData = try decoder.decode(StockGraphData.self, from: data)
            for i in decodedStockGraphData.closePrices { print(i) }
            return decodedStockGraphData
        } catch {
            return nil
        }
    }
    
}

extension StockManager : stockManagerDelegate{
    func getSearchList() -> [StockData] {
        return searchList
    }
    
    func setSearchHistoryToUserDefaults() {
        defaults.set(searchHistoryList, forKey: "searchHistory")
    }
    
    func addStockToHistory(ticker: String) {
        searchHistoryList.reverse()
        searchHistoryList.append(ticker)
        if searchHistoryList.count > 12 {
            searchHistoryList.remove(at: 0)
        }
        searchHistoryList.reverse()
        
        print(searchHistoryList)
    }
    
    func getSearchHistoryList() -> [String] {
        return searchHistoryList
    }
    
    func clearSearchList() {
        searchList = []
    }
    
    func appendSearchList(stockData: StockData) {
        searchList.append(stockData)
    }
    
    func setFavToUserDefaults(val: Bool, ticker: String) {
        defaults.set(val,  forKey: ticker)
    }
    
    func isFav(ticker : String) -> Bool {
        guard let stockModel = stocksModelDic[ticker] else { return false }
        return stockModel.isFavorite
    }
    
    func getFavListCount() -> Int {
        favoriteList.count
    }
    
    func addtoFav(ticker : String) {
        guard let stockModel = stocksModelDic[ticker] else {
            return }
        if stocksModelDic[ticker]?.isFavorite == false {
            print("it is appending")
            favoriteList.append(StockData(name: stockModel.name, logo: stockModel.linkIcon, ticker: stockModel.ticker))
            stocksModelDic[ticker]?.isFavorite = true
        }
    }
    
    func removeFromFav(ticker : String) -> Bool{
        for i in 0..<favoriteList.count {
            if(favoriteList[i].ticker==ticker) {
                favoriteList.remove(at: i)
                stocksModelDic[ticker]?.isFavorite = false
                
                return true
            }
        }
        return false
    }
    
    func getStockList() -> [StockData] {
        stocksList = self.getStockProfiles()
        return stocksList
    }
    
    func getStockDicList(ticker:String) -> StockModel? {
        return self.stocksModelDic[ticker]
    }
    
    func getFavList() -> [StockData]{
        if favoriteList.isEmpty{
            return []
        }else{
            return favoriteList
        }
    }
}

