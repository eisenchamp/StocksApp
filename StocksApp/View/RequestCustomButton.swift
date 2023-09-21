import UIKit

final class RequestCustomButton: UIButton {
    
    var text: String = ""
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupButton() {
        self.layer.cornerRadius = 20.0
        self.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 247/255, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configuration = UIButton.Configuration.plain()
        self.setAttributedTitle(NSAttributedString(string: self.text, attributes: [
            NSAttributedString.Key.font : MontserratFont.makefont(name: .semibold, size: 12.0),
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]), for: .normal)

    
    }
    
    func buttonLabel() -> String {
        return self.text
    }
    
    
}
