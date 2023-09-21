//
//  ViewModel.swift
//  StocksApp
//
//  Created by Temirlan Tursynbekov on 10.09.2023.
//

import Foundation
import UIKit

enum Statement {
    case stock
    case favorite
    case search
    case searchStarted
}

protocol ViewModelProtocol {
    func getCurrentState() -> Statement
    
    func setCurrentState(for state : Statement)
    
    func favButtonTapped() //for the favButton pressed
    
    func stockButtonTapped() //for the stockButton pressed
    
    func getTableRowCount() -> Int //to get the number of the cells for the table
    
    func getStockDic(ticker: String) -> StockModel?
        
    func getStockData(index: Int, currentState: Statement) -> StockData?
    
    func getStockModel(ticker: String) -> StockModel?
    
    func isFavouriteStock(ticker: String) -> Bool
        
    func addToFavourites(ticker: String)
        
    func removeFromFavourites(ticker: String) -> Bool
        
    func getFavouriteListSize() -> Int
        
    func getStocksList( for state: Statement) -> [StockData]
                
    func getElementFromStocksDictionary(ticker: String) -> StockModel?
        
    func setFavouriteInUserDefaults(val: Bool, ticker: String)
    
    func appendSearchList(stockData: StockData)
    
    func clearSearchList()
    
    func getSearchHistoryList() -> [String]
        
    func addStockToSearchHistory(ticker: String)
    
    func setSearchHistoryToUserDefaults()
}

final class ViewModel{
    weak var viewControllerDelegate : viewControllerDelegate?
    var stockManagerDelegate : stockManagerDelegate?
    weak var viewController : ViewController?
    
    init(viewControllerDelegate: viewControllerDelegate? = nil, stockManagerDelegate : stockManagerDelegate? = nil, viewController : ViewController? = nil) {
        self.viewController = viewController
        self.viewControllerDelegate = viewControllerDelegate
        self.stockManagerDelegate = stockManagerDelegate
    }
    
    var statement : Statement = .stock{
        didSet {
            if(statement == .stock || statement == .favorite) { viewController!.lastMainPageState = statement }
            viewController!.searchBarView.searchTextField.resignFirstResponder()
            viewController!.currentStateConfigurations()
        }
    }
}

extension ViewModel: ViewModelProtocol {
    func appendSearchList(stockData: StockData) {
        stockManagerDelegate?.appendSearchList(stockData: stockData)
    }
    
    func clearSearchList() {
        stockManagerDelegate?.clearSearchList()
    }
    
    func getSearchHistoryList() -> [String] {
        return stockManagerDelegate!.getSearchHistoryList()
    }
    
    func addStockToSearchHistory(ticker: String) {
        stockManagerDelegate?.addStockToHistory(ticker: ticker)
    }
    
    func setSearchHistoryToUserDefaults() {
        stockManagerDelegate?.setSearchHistoryToUserDefaults()
    }
    
    func setCurrentState(for state: Statement) {
        self.statement = state
    }
    
    func getCurrentState() -> Statement {
        return statement
    }
    
    func getStockData(index: Int, currentState: Statement) -> StockData? {
        if(currentState == .stock) {
            return stockManagerDelegate?.getStockList()[index]
        } else if(currentState == .favorite) {
            return stockManagerDelegate?.getFavList()[index]
        } else if (currentState == .search){
            return stockManagerDelegate?.getSearchList()[index]
        }
        return nil
    }
    
    func getStocksList(for state: Statement) -> [StockData] {
        if (state == .stock){
            return (stockManagerDelegate?.getStockList())!
        }else if (state == .favorite){
            return (stockManagerDelegate?.getFavList())!
        }else{
            return (stockManagerDelegate?.getSearchList())!
        }
    }
    
    func getStockModel(ticker: String) -> StockModel? {
        guard let stockModel = stockManagerDelegate?.getStockDicList(ticker: ticker) else { return nil }
        return stockModel
    }
    
    func isFavouriteStock(ticker: String) -> Bool {
        guard let bool = stockManagerDelegate?.isFav(ticker: ticker) else {return false}
        return bool
    }
    
    func addToFavourites(ticker: String) {
        stockManagerDelegate?.addtoFav(ticker: ticker)
    }
    
    func removeFromFavourites(ticker: String) -> Bool {
        ((stockManagerDelegate?.removeFromFav(ticker: ticker)) != nil)
    }
    
    func getFavouriteListSize() -> Int {
        (stockManagerDelegate?.getFavListCount())!
    }
        
    func getElementFromStocksDictionary(ticker: String) -> StockModel? {
        return stockManagerDelegate?.getStockDicList(ticker: ticker)
    }
    
    func setFavouriteInUserDefaults(val: Bool, ticker: String) {
        stockManagerDelegate?.setFavToUserDefaults(val: val, ticker: ticker)
    }
    
    func getStockDic(ticker : String) -> StockModel? {
        if let stockManagerDelegate = stockManagerDelegate {
            return stockManagerDelegate.getStockDicList(ticker: ticker)
        } else {
            print("stockManagerDelegate is nil")
            return nil
        }
    }
    
    func getTableRowCount() -> Int {
        if self.statement == .stock{
            return 30
        }else if self.statement == .favorite{
            return (stockManagerDelegate?.getFavListCount())!
        }else{
            return (stockManagerDelegate?.getSearchList().count)!
        }
    }
    
    func stockButtonTapped() {
        self.statement = .stock
        viewControllerDelegate?.tableUpdate()
        viewControllerDelegate?.stockButtonPressed()
        print ("Changed to stock")
    }
    
    func favButtonTapped() {
        self.statement = .favorite
        viewControllerDelegate?.tableUpdate()
        viewControllerDelegate?.favButtonPressed()
        print ("Changed to favorite")
    }
    
    
}
