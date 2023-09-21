import UIKit

final class RequestView: UIView {
    
    var requests: [String] = []
    let buttonAction: ((String) -> Void)
    
    init(requests: [String], title: String, buttonAction: @escaping ((String) -> Void)) {
        self.requests = requests
        titleLabel.text = title
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(titleLabel)
        self.addSubview(stockScrollView)
        stockScrollView.addSubview(mainStackView)
        var i = 0
        for item in requests {
            let requestButton = RequestCustomButton(text: item)
            requestButton.translatesAutoresizingMaskIntoConstraints = false
            requestButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            if i%2 == 0 {
                topStackView.addArrangedSubview(requestButton)
            } else {
                bottomStackView.addArrangedSubview(requestButton)
            }
            requestButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
            i = i + 1
        }
        
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        setupLayout()
    }
    
    func updateTheRequestView(requests: [String]) {
        let size = self.requests.count
        self.requests = requests
        
        
        let requestButton = RequestCustomButton(text: requests[0])
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if size%2 == 0 {
            topStackView.insertArrangedSubview(requestButton, at: 0)
        } else {
            bottomStackView.insertArrangedSubview(requestButton, at: 0)
        }
        
        
    }
    @objc func actionButton(_ sender: RequestCustomButton?) {
        print(sender?.text ?? "NO VALUE")
        guard let text = sender?.text,
              text.isEmpty == false else { return }
        buttonAction(text)
    }
    
    
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0),
            
            stockScrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stockScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
            stockScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stockScrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            
            mainStackView.leftAnchor.constraint(equalTo: stockScrollView.leftAnchor, constant: 16.0),
            mainStackView.rightAnchor.constraint(equalTo: stockScrollView.rightAnchor, constant: -16.0),
            mainStackView.heightAnchor.constraint(equalTo: stockScrollView.heightAnchor),
            
            topStackView.heightAnchor.constraint(equalToConstant: 44.0),
            
            bottomStackView.heightAnchor.constraint(equalToConstant: 44.0),
            
        ])
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = MontserratFont.makefont(name: .bold, size: 18.0)
        return label
    } ()
    let stockScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    } ()
    
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .leading
        stack.spacing = 8.0
        return stack
    } ()
    
    let topStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5.0
        stack.distribution = .fillProportionally
        return stack
    } ()
    
    let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = 5.0
        return stack
    } ()
    
    
}
