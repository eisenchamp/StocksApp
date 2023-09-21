//
//  StockDetailsViewController.swift
//  StocksApp
//
//  Created by Temirlan Tursynbekov on 20.09.2023.
//

import UIKit
import SwiftChart

struct timePeriod{
    static let all = "All"
    static let year = "1Y"
    static let sixMonth = "6M"
    static let month = "M"
    static let week = "W"
    static let day = "D"
}

class StockDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let stockDetailsViewModel: StockDetailsViewModelProvider
    private let constants = Constants()
    
    private let starPressed: ((String) -> Void)?
    
    //MARK: - Lifecycle
    
    init(stockDetailsViewModel: StockDetailsViewModelProvider, starPressed: ((String) -> Void)?) {
        self.stockDetailsViewModel = stockDetailsViewModel
        self.starPressed = starPressed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        view = UIView()
        view.backgroundColor = .white
        stocksChart.delegate = self
        stockDetailsViewModel.loadGraphData(period: timePeriod.all)
        addSubviews()
        setupStackOfbuttons()
        setupLayout()
        setupButtons()
        loadDataToPage()
        activityIndicator.startAnimating()
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(tickerLabelView)
        headerView.addSubview(nameLabelView)
        headerView.addSubview(starButton)
        starButton.addSubview(starImageView)
        backButton.addSubview(backImageView)
        view.addSubview(stockPriceLabel)
        view.addSubview(stockRateLabel)
        view.addSubview(buyButton)
        view.addSubview(divider)
        view.addSubview(stocksChart)
        view.addSubview(stackOfButtons)
        view.addSubview(activityIndicator)
    }
    
    private func setupButtons() {
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        starButton.addTarget(self, action: #selector(starButtonAction), for: .touchUpInside)
    }
    
    private func setupStackOfbuttons() {
        let buttonLabels = ["D", "W", "M", "6M", "1Y", "All"]
        
        for buttonText in buttonLabels {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(string: buttonText, attributes: [
                NSAttributedString.Key.font : MontserratFont.makefont(name: .semibold, size: 12.0)
            ]), for: .normal)
            if(buttonText == "All") {
                button.tintColor = .white
                button.backgroundColor = constants.activeChipColor
            } else {
                button.tintColor = .black
                button.backgroundColor = constants.inactiveChipColor
            }
            button.translatesAutoresizingMaskIntoConstraints = false
            button.configuration = UIButton.Configuration.plain()
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 16.0, bottom: .zero, trailing: 16.0)
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            button.layer.cornerRadius = 12.0
            button.addTarget(self, action: #selector(chipButtonAction), for: .touchUpInside)
            
            self.stackOfButtons.addArrangedSubview(button)
        }
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 75),
            
            divider.heightAnchor.constraint(equalToConstant: 1.0),
            divider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -15.0),
            divider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            divider.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            backButton.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 16.0),
            backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16.0),
            backButton.heightAnchor.constraint(equalToConstant: 48.0),
            backButton.widthAnchor.constraint(equalToConstant: 48.0),
            
            backImageView.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 17.0),
            backImageView.leftAnchor.constraint(equalTo: backButton.leftAnchor, constant: 2.0),
            backImageView.widthAnchor.constraint(equalToConstant: 20.0),
            backImageView.heightAnchor.constraint(equalToConstant: 14.0),
            
            tickerLabelView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            tickerLabelView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 18),
            
            nameLabelView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            nameLabelView.topAnchor.constraint(equalTo: tickerLabelView.bottomAnchor, constant: 4.0),
            
            starButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            starButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            starButton.heightAnchor.constraint(equalToConstant: 48.0),
            starButton.widthAnchor.constraint(equalToConstant: 48.0),
            
            starImageView.topAnchor.constraint(equalTo: starButton.topAnchor, constant: 14.0),
            starImageView.rightAnchor.constraint(equalTo: starButton.rightAnchor, constant: -1.0),
            starImageView.widthAnchor.constraint(equalToConstant: 22.0),
            starImageView.heightAnchor.constraint(equalToConstant: 22.0),
            
            stockPriceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stockPriceLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 48.0),
            
            stockRateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stockRateLabel.topAnchor.constraint(equalTo: stockPriceLabel.bottomAnchor, constant: 8.0),
            buyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16.0),
            buyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16.0),
            buyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0),
            buyButton.heightAnchor.constraint(equalToConstant: 56.0),
            
            stocksChart.topAnchor.constraint(equalTo: stockRateLabel.bottomAnchor, constant: 5.0),
            stocksChart.heightAnchor.constraint(equalToConstant: 330.0),
            stocksChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stocksChart.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            stackOfButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackOfButtons.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -52.0),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
            
            
        ])
    }
    
    
    //MARK: - Privete Methods
    
    private func loadDataToPage() {
        guard let currentStockModel = stockDetailsViewModel.getCurrentStockModel() else { return }
        tickerLabelView.text = currentStockModel.ticker
        nameLabelView.text = currentStockModel.name
        
        if(currentStockModel.isFavorite) {
            starImageView.image = UIImage(named: "starIcon.fill")
        } else {
            starImageView.image = UIImage(named: "starIcon")
        }
        stockPriceLabel.text = "$" + String(format: "%.2f", currentStockModel.stockLiveData.currentPrice)
        
        if(currentStockModel.stockLiveData.change>=0) {
            stockRateLabel.text = "+$" + String(format: "%.2f", currentStockModel.stockLiveData.change) + " (" + String(format: "%.2f", currentStockModel.stockLiveData.changePercent) + "%)"
            stockRateLabel.textColor = constants.positiveRateColor
        } else {
            stockRateLabel.text = "-$" + String(format: "%.2f", currentStockModel.stockLiveData.change*(-1)) + " (" + String(format: "%.2f", currentStockModel.stockLiveData.changePercent*(-1)) + "%)"
            stockRateLabel.textColor = constants.negativeRateColor
        }
        
        let buyButtonText = "Buy for $" + String(format: "%.2f", currentStockModel.stockLiveData.currentPrice + 0.006*currentStockModel.stockLiveData.currentPrice)
        buyButton.setAttributedTitle(NSAttributedString(string: buyButtonText , attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .semibold, size: 16),
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]), for: .normal)
        
    }
    
    private func updateChips(button: UIButton) {
        guard let text = button.titleLabel?.text else { return }
        for button in stackOfButtons.arrangedSubviews {
            guard let button = button as? UIButton else {return}
            guard let currentText = button.titleLabel?.text else { return }
            if(currentText == text) {
                button.tintColor = .white
                button.backgroundColor = constants.activeChipColor
            } else {
                button.tintColor = .black
                button.backgroundColor = constants.inactiveChipColor
            }
            
        }
    }
    
    //MARK: - Constants
    
    struct Constants {
        let activeChipColor: UIColor = .black
        let inactiveChipColor: UIColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1.0)
        
        let positiveRateColor: UIColor = UIColor(red: 36/255, green: 179/255, blue: 93/255, alpha: 1.0)
        let negativeRateColor: UIColor = .red
        
    }
    
    
    //MARK: - Button Actions
    
    @objc private func chipButtonAction(_ sender: UIButton?) {
        guard let sender = sender else { return }
        guard let text = sender.titleLabel?.text else { return }
        activityIndicator.startAnimating()
        updateChips(button: sender)
        stocksChart.removeAllSeries()
        stockDetailsViewModel.loadGraphData(period: text)
    }
    
    @objc private func backButtonAction() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func starButtonAction() {
        guard let currentStockModel = stockDetailsViewModel.getCurrentStockModel() else { return }
        starPressed?(currentStockModel.ticker)
        if(starImageView.image == UIImage(named: "starIcon.fill")) {
            starImageView.image = UIImage(named: "starIcon")
        } else {
            starImageView.image = UIImage(named: "starIcon.fill")
        }
    }
    
    //MARK: - UI Elements
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .gray
        return indicator
    } ()
    
    private let stackOfButtons: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10.0
        stack.distribution = .fillProportionally
        return stack
    } ()
    
    private let stocksChart: Chart = {
        let chart = Chart(frame: .zero)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.showXLabelsAndGrid = false
        chart.showYLabelsAndGrid = false
        return chart
    } ()
    
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    } ()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    } ()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    } ()
    
    private let backImageView: UIImageView = {
        let img = UIImage(named: "returnIcon")
        let imageView = UIImageView(image: img)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let tickerLabelView: UILabel = {
        let label = UILabel()
        label.font = MontserratFont.makefont(name: .bold, size: 18.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let nameLabelView: UILabel = {
        let label = UILabel()
        label.font = MontserratFont.makefont(name: .semibold, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        return button
    } ()
    
    private let starImageView: UIImageView = {
        let img = UIImage(named: "starIcon")
        let imageView = UIImageView(image: img)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private let stockPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = MontserratFont.makefont(name: .bold, size: 28.0)
        return label
    } ()
    
    private let stockRateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = MontserratFont.makefont(name: .semibold, size: 12.0)
        return label
    } ()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    } ()
}

//MARK: - StockDetailsViewModelOutput

extension StockDetailsViewController: StockDetailsViewModelOutput {
    
    func updateGraph(stockGraphData: StockGraphData) {
        DispatchQueue.main.async {
            let series = ChartSeries(stockGraphData.closePrices)
            print(stockGraphData.closePrices.count)
            series.color = .black
            self.activityIndicator.stopAnimating()
            self.stocksChart.add(series)
        }
    }
    
}
//MARK: - ChartDelegate

extension StockDetailsViewController: ChartDelegate {
    
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
                guard let value = value else {
                    return
                }
                stockPriceLabel.text = "$" + String(format: "%.2f", value)
            }
        }
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        chart.hideHighlightLineOnTouchEnd = true
        guard let currentStockModel = stockDetailsViewModel.getCurrentStockModel() else { return }
        stockPriceLabel.text = "$" + String(format: "%.2f", currentStockModel.stockLiveData.currentPrice)
    }
    
}
