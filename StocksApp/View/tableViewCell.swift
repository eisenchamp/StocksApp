//
//  tableViewCell.swift
//  StocksApp
//
//  Created by Temirlan Tursynbekov on 10.09.2023.
//

import Foundation
import UIKit
import SDWebImage

protocol TableViewCellDelegate: AnyObject {
    func getStockData(index: Int, currentState: Statement) -> StockData?
    
    func getStockModel(ticker: String) -> StockModel?
    
    func isFavouriteStock(ticker: String) -> Bool
    
    func addToFavourites(ticker: String)
    
    func removeFromFavourites(ticker: String)
    
    func getStockTableViewState() -> Statement
    
    func updateStockTableView()
    
}

final class TableViewCell : UITableViewCell {
    weak var delegate: TableViewCellDelegate?
    var currentIndex: Int?
    let mainContentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    } ()
    
    let stockImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 15
        img.clipsToBounds = true
        return img
    } ()
    
    let starButton: UIButton = {
        let starIcon = UIImage(named: "starIcon.gray")
        let button = UIButton()
        button.setImage(starIcon, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor  = .systemGray
        return button
    } ()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AAPL"
        label.font = MontserratFont.makefont(name: .bold, size: 18)
        return label
    } ()
    
    let stockName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apple Inc."
        label.font = MontserratFont.makefont(name: .semibold, size: 12)
        return label
    } ()
    
    let stockPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "$999.9"
        label.font = MontserratFont.makefont(name: .bold, size: 18)
        return label
    } ()
    
    let stockRate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+$0.00 (0.00%)"
        label.textColor = .init(red: 36/255, green: 179/255, blue: 93/255, alpha: 1.0)
        label.font = MontserratFont.makefont(name: .semibold, size: 12)
        return label
    } ()
    
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    } ()
    
    func setupCell() {
        self.contentView.addSubview(mainContentView)
        mainContentView.addSubview(stockImageView)
        mainContentView.addSubview(containerView)
        
        containerView.addSubview(stockLabel)
        containerView.addSubview(stockPrice)
        containerView.addSubview(stockName)
        containerView.addSubview(stockRate)
        containerView.addSubview(starButton)
        starButton.addTarget(self, action: #selector(starButtonPressed), for: .touchUpInside)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            self.contentView.heightAnchor.constraint(equalToConstant: 76),
            
            mainContentView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            mainContentView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            mainContentView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            mainContentView.heightAnchor.constraint(equalToConstant: 68),
            
            stockImageView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            stockImageView.leftAnchor.constraint(equalTo: mainContentView.leftAnchor, constant: 8),
            stockImageView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            stockImageView.widthAnchor.constraint(equalToConstant: 52),
            stockImageView.heightAnchor.constraint(equalToConstant: 52),
            
            containerView.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: stockImageView.rightAnchor, constant: 12),
            containerView.rightAnchor.constraint(equalTo: mainContentView.rightAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 40),
            
            stockPrice.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -17),
            stockName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            starButton.leftAnchor.constraint(equalTo: stockLabel.rightAnchor, constant: 6),
            starButton.heightAnchor.constraint(equalToConstant: 16),
            starButton.widthAnchor.constraint(equalToConstant: 16),
            starButton.centerYAnchor.constraint(equalTo: stockLabel.centerYAnchor),
            
            stockRate.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stockRate.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
        ])
    }
    
    var stockModel: StockModel? {
        didSet {
            
            guard let stockModel = stockModel else { return }
            
            stockPrice.text = "$" + String(format: "%.2f", stockModel.stockLiveData.currentPrice)
            
            if(stockModel.linkIcon.count != 0) {
                stockImageView.sd_setImage(with: URL(string: stockModel.linkIcon), placeholderImage: UIImage(named: "placeholder.png"))
            }
            
            if(stockModel.stockLiveData.change>=0) {
                stockRate.text = "+$" + String(format: "%.2f", stockModel.stockLiveData.change) + " (" + String(format: "%.2f", stockModel.stockLiveData.changePercent) + "%)"
                stockRate.textColor = .init(red: 36/255, green: 179/255, blue: 93/255, alpha: 1.0)
            } else {
                stockRate.text = "-$" + String(format: "%.2f", stockModel.stockLiveData.change*(-1)) + " (" + String(format: "%.2f", stockModel.stockLiveData.changePercent*(-1)) + "%)"
                stockRate.textColor = .red
            }
            if stockModel.isFavorite == true {
                starButton.setImage(UIImage(named: "starIcon.yellow"), for: .normal)
            } else {
                starButton.setImage(UIImage(named: "starIcon.gray"), for: .normal)
            }
        }
    }
    
    @objc func starButtonPressed(){
        guard let currentIndex = currentIndex else {return}
        if(delegate?.getStockTableViewState() == .favorite) {
            guard let currentStock = delegate?.getStockData(index: currentIndex, currentState: .favorite) else { return }
            delegate?.removeFromFavourites(ticker: currentStock.ticker)
            delegate?.updateStockTableView()
        } else if(delegate?.getStockTableViewState() == .stock) {
            guard let currentStock = delegate?.getStockData(index: currentIndex, currentState: .stock) else { return }
            if(delegate?.isFavouriteStock(ticker: currentStock.ticker) == true) {
                starButton.setImage(UIImage(named: "starIcon.gray"), for: .normal)
                delegate?.removeFromFavourites(ticker: currentStock.ticker)
            } else {
                starButton.setImage(UIImage(named: "starIcon.yellow"), for: .normal)
                delegate?.addToFavourites(ticker: currentStock.ticker)
            }
        } else{
            guard let currentStock = delegate?.getStockData(index: currentIndex, currentState: .search) else { return }
            if(delegate?.isFavouriteStock(ticker: currentStock.ticker) == true) {
                starButton.setImage(UIImage(named: "starIcon.gray"), for: .normal)
                delegate?.removeFromFavourites(ticker: currentStock.ticker)
            } else {
                starButton.setImage(UIImage(named: "starIcon.yellow"), for: .normal)
                delegate?.addToFavourites(ticker: currentStock.ticker)
            }
        }
    }
    
    func configureCell(stocksList: [StockData], index: Int) {
        
        if(index%2==0) {
            mainContentView.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1.0)
        } else {
            mainContentView.backgroundColor = .white
        }
            
        
        currentIndex = index
        
        stockLabel.text = stocksList[index].ticker
        stockName.text = stocksList[index].name
        
        if let char = stocksList[index].ticker.first {
            stockImageView.image = UIImage(systemName: "\(char.lowercased()).square")
            stockImageView.tintColor = .black
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
