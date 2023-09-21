//
//  ViewController.swift
//  StocksApp
//
//  Created by Temirlan Tursynbekov on 07.09.2023.
//

import UIKit

protocol viewControllerDelegate : NSObject{
    func favButtonPressed()
    
    func stockButtonPressed()
    
    func tableUpdate()
}

class ViewController: UIViewController {
    
    private let stockManager: StockManager
    
    var vm: ViewModelProtocol
    
    var lastMainPageState: Statement = .stock
    
    init(vm : ViewModelProtocol, stockManager : StockManager){
        self.vm = vm
        self.stockManager = stockManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //
    let searchBarView: SearchBarView = {
        let searchBarView = SearchBarView()
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        return searchBarView
    } ()
    
    lazy var searchView : SearchView = {
        let search = SearchView(searchHistory: vm.getSearchHistoryList(), buttonAction: { string in
            self.popularButtonAction(name: string)
        })
        search.translatesAutoresizingMaskIntoConstraints = false
        search.isHidden = true
        return search
    } ()
    
    
    let buttonView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stockTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(TableViewCell.self, forCellReuseIdentifier: "reusableCell")
        table.separatorColor = .white
        table.allowsSelection = true
        return table
    }()
    
    let stockButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 0.0
        ]),
                                  for: .normal)
        return button
    }()
    
    let favButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.baselineOffset : 1.5
        ]),
                                  for: .normal)
        return button
    }()
    
    private let noElementLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No favourite stocks"
        label.font = MontserratFont.makefont(name: .semibold, size: 18.0)
        label.textColor = .gray
        return label
    } ()
    
    let stocksButtonInSearch: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 1.5
        ]),
                                  for: .normal)
        button.isHidden = true
        return button
    } ()
    
    var stockDicList : [String:StockModel]?
    var stockList : [StockData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        viewSetup()
        searchBarView.searchTextField.delegate = self
        stockTable.delegate = self
        stockTable.dataSource = self
        addButtonActions()
    }
    
    func viewSetup () {
        searchBarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        searchBarView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        searchBarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        searchBarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        searchBarView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 30).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        
        buttonView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor).isActive = true
        buttonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        buttonView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stockButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        stockButton.leftAnchor.constraint(equalTo: buttonView.leftAnchor).isActive = true
        
        favButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        favButton.leftAnchor.constraint(equalTo: stockButton.rightAnchor, constant: 20).isActive = true
        
        stocksButtonInSearch.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor).isActive = true
        stocksButtonInSearch.leftAnchor.constraint(equalTo: buttonView.leftAnchor).isActive = true
        
        stockTable.topAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 10).isActive = true
        stockTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stockTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stockTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func addSubviews () {
        view.addSubview(searchBarView)
        view.addSubview(buttonView)
        buttonView.addSubview(stockButton)
        buttonView.addSubview(favButton)
        buttonView.addSubview(stocksButtonInSearch)
        view.addSubview(stockTable)
        view.addSubview(searchView)
    }
    
    func addButtonActions(){
        favButton.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        stockButton.addTarget(self, action: #selector(stockButtonAction), for: .touchUpInside)
        searchBarView.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        searchBarView.clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
    }
    
    func popularButtonAction(name: String) {
        searchBarView.searchTextField.text = name
    }
    
    @objc func favButtonAction() {
        vm.favButtonTapped()
    }
    
    @objc func stockButtonAction(){
        vm.stockButtonTapped()
    }
    
    @objc func clearButtonAction(_sender: UIButton?) {
        searchBarView.searchTextField.text = ""
    }
    
    
    @objc func backButtonAction(_sender: UIButton?) {
        vm.setCurrentState(for: lastMainPageState)
    }
    
    private func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func currentStateConfigurations() {
        stockTable.isHidden = (vm.getCurrentState() != .search) ? false : true
        if (vm.getCurrentState() == .favorite && vm.getFavouriteListSize() == 0) { stockTable.isHidden = true }
        
        searchView.isHidden = vm.getCurrentState() == .search ? false : true
        
        searchBarView.searchButton.isHidden = (vm.getCurrentState() == .stock || vm.getCurrentState() == .favorite) ? false : true
        searchBarView.backButton.isHidden = (vm.getCurrentState() == .stock || vm.getCurrentState() == .favorite) ? true : false
        searchBarView.clearButton.isHidden = vm.getCurrentState() == .searchStarted ? false : true
        
        noElementLabel.isHidden = (vm.getCurrentState() == .favorite && vm.getFavouriteListSize() == 0) ? false : true
        
        stockButton.isHidden = (vm.getCurrentState() == .stock || vm.getCurrentState() == .favorite) ? false : true
        favButton.isHidden = (vm.getCurrentState() == .stock || vm.getCurrentState() == .favorite) ? false : true
        stocksButtonInSearch.isHidden = (vm.getCurrentState() == .searchStarted) ? false : true
        
        stockTable.reloadData()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        vm.setCurrentState(for: .search)
        isEditing = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if((vm.getCurrentState() != .search && vm.getCurrentState() != .searchStarted)
           || isEditing == false
        )  {
            isEditing = true
            return true
        }
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if(vm.getCurrentState() != .search && vm.getCurrentState() != .searchStarted)  {
            return true
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        vm.clearSearchList()
        
        if(searchText == "") {
            vm.setCurrentState(for: .search)
        } else {
            var count = 0;
            for item in vm.getStocksList(for: .stock) {
                print(item)
                let ticker = item.ticker.lowercased()
                let name = item.name.lowercased()
                var isfound = false
                if (searchText.count <= ticker.count) {
                    if(searchText.lowercased() == ticker[..<ticker.index(ticker.startIndex, offsetBy: searchText.count)]) {
                        vm.appendSearchList(stockData: item)
                        isfound = true
                    }
                }
                
                if(searchText.count <= name.count && isfound == false) {
                    if(searchText.lowercased() == name[..<name.index(name.startIndex, offsetBy: searchText.count)]) {
                        vm.appendSearchList(stockData: item)
                    }
                }
                count+=1;
                
                if count == 30 {
                    break
                }
            }
            vm.setCurrentState(for: .searchStarted)
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text != ""{
            vm.addStockToSearchHistory(ticker: text)
        }
        vm.setSearchHistoryToUserDefaults()
        
        searchView.updateRequestView(requests: vm.getSearchHistoryList())
        
        isEditing = false
        resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}


extension ViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.getTableRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        if (vm.getCurrentState() == .stock) {
            cell.configureCell(stocksList: vm.getStocksList(for: .stock), index: indexPath.row)
            let ticker = vm.getStocksList(for: .stock)[indexPath.row].ticker
            if let stockModel = vm.getElementFromStocksDictionary(ticker: ticker) {
                cell.stockModel = stockModel
            }
        } else if (vm.getCurrentState() == .favorite) {
            cell.configureCell(stocksList: vm.getStocksList(for: .favorite), index: indexPath.row)
            let ticker = vm.getStocksList(for: .favorite)[indexPath.row].ticker
            if let stockModel = vm.getElementFromStocksDictionary(ticker: ticker) {
                cell.stockModel = stockModel
            }
        }else if(vm.getCurrentState() == .searchStarted) {
            cell.configureCell(stocksList: vm.getStocksList(for: .search), index: indexPath.row)
            let ticker = vm.getStocksList(for: .search)[indexPath.row].ticker
            if let stockModel = vm.getElementFromStocksDictionary(ticker: ticker) {
                cell.stockModel = stockModel
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print(vm.getStocksList(for: .stock)[indexPath.row])
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentTicker = vm.getStocksList(for: vm.getCurrentState())[indexPath.row].ticker
        
        guard let currentStockModel = vm.getElementFromStocksDictionary(ticker: currentTicker) else { return }
        
        let stockDetailsModel = StockDetailsModel(currentStockModel: currentStockModel)
        let stockDetailsViewModel = StockDetailsViewModel(stockDetailsModel: stockDetailsModel, stockManager: self.stockManager)
        let stockDetailsViewController = StockDetailsViewController(stockDetailsViewModel: stockDetailsViewModel, starPressed: { ticker in
            if(self.isFavouriteStock(ticker: ticker)) {
                self.removeFromFavourites(ticker: ticker)
            } else {
                self.addToFavourites(ticker: ticker)
            }
            self.updateStockTableView()
        })
        stockDetailsViewModel.setStockDetailsView(stockDetailsView: stockDetailsViewController)
        stockDetailsViewController.modalPresentationStyle = .fullScreen
        presentDetail(stockDetailsViewController)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82.0
    }
}

extension ViewController : viewControllerDelegate{
    func tableUpdate() {
        self.stockTable.reloadData()
    }
    
    func favButtonPressed() {
        self.favButton.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 0.0
        ]),
                                          for: .normal)
        self.stockButton.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.baselineOffset : 1.5
        ]),
                                            for: .normal)
    }
    
    func stockButtonPressed() {
        self.favButton.setAttributedTitle(NSAttributedString(string: "Favourite", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 18),
            NSAttributedString.Key.foregroundColor : UIColor.gray,
            NSAttributedString.Key.baselineOffset : 1.5
        ]),
                                          for: .normal)
        self.stockButton.setAttributedTitle(NSAttributedString(string: "Stocks", attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .bold, size: 28),
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.baselineOffset : 0.0
        ]),
                                            for: .normal)
    }
}

extension ViewController : TableViewCellDelegate{
    func getStockData(index: Int, currentState: Statement) -> StockData? {
        return vm.getStockData(index: index, currentState: currentState)
    }
    
    func getStockTableViewState() -> Statement {
        return vm.getCurrentState()
    }
    
    func getStockModel(ticker: String) -> StockModel? {
        return vm.getStockModel(ticker: ticker)
    }
    
    func isFavouriteStock(ticker: String) -> Bool {
        return vm.isFavouriteStock(ticker: ticker)
    }
    
    func addToFavourites(ticker: String) {
        vm.addToFavourites(ticker: ticker)
    }
    
    func removeFromFavourites(ticker: String){
        vm.removeFromFavourites(ticker: ticker)
    }
    
    func updateStockTableView() {
        self.stockTable.reloadData()
    }
}
