import UIKit

final class SearchBarView: UIView {
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        addSubviews()
        setupLayout()
    }
    
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,  NSAttributedString.Key.font : MontserratFont.makefont(name: .semibold, size: 16)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .search
        return textField
    }()
    let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    
    let searchIconView: UIImageView = {
        let searchIcon = UIImage(systemName: "magnifyingglass")
        let iconView = UIImageView(image: searchIcon!)
        iconView.tintColor = .black
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    } ()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.isHidden = true
        return button
    } ()
    
    let backIconView: UIImageView = {
        let backIcon = UIImage(named: "returnIcon")
        let iconView = UIImageView(image: backIcon!)
        iconView.tintColor = .black
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    } ()
    
    let clearButton: UIButton = {
        let img = UIImage(named: "clearIcon")
        let button = UIButton()
        button.setImage(img, for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    
    func addSubviews() {
        
        searchButton.addSubview(searchIconView)
        backButton.addSubview(backIconView)
        self.addSubview(searchTextField)
        self.addSubview(searchButton)
        self.addSubview(backButton)
        self.addSubview(clearButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
            searchButton.heightAnchor.constraint(equalToConstant: 25),
            searchButton.widthAnchor.constraint(equalToConstant: 25),
            searchButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            searchIconView.widthAnchor.constraint(equalTo: searchButton.widthAnchor),
            searchIconView.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            
            searchTextField.leftAnchor.constraint(equalTo: searchIconView.rightAnchor, constant: 10),
            searchTextField.centerYAnchor.constraint(equalTo: searchIconView.centerYAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 25),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            
            backIconView.widthAnchor.constraint(equalToConstant: 20.0),
            backIconView.heightAnchor.constraint(equalToConstant: 14.0),
            backIconView.centerXAnchor.constraint(equalTo: backButton.centerXAnchor),
            backIconView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            
            clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 16),
            clearButton.widthAnchor.constraint(equalToConstant: 16),
            clearButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -21.0)
            
        ])
    }
    
}
