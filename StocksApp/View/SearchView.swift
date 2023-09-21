import UIKit

struct RequestData {
    
}

final class SearchView: UIView {
    
    let buttonAction: ((String) -> Void)
    
    let popularRequests = ["Apple","Amazon","Google","Tesla","Microsoft","Facebook","Alibaba","Yandex","Mastercard","Booking","Firstsolar"]
    var recentRequests: [String] = []
    
    
    init(searchHistory: [String], buttonAction: @escaping ((String) -> Void)) {
        self.buttonAction = buttonAction
        recentRequests = searchHistory
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(popularRequestView)
        self.addSubview(recentRequestView)
        setupLayout()
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            popularRequestView.topAnchor.constraint(equalTo: self.topAnchor),
            popularRequestView.leftAnchor.constraint(equalTo: self.leftAnchor),
            popularRequestView.rightAnchor.constraint(equalTo: self.rightAnchor),
            popularRequestView.heightAnchor.constraint(equalToConstant: 123.0),
            recentRequestView.topAnchor.constraint(equalTo: popularRequestView.bottomAnchor, constant: 20),
            recentRequestView.leftAnchor.constraint(equalTo: self.leftAnchor),
            recentRequestView.rightAnchor.constraint(equalTo: self.rightAnchor),
            recentRequestView.heightAnchor.constraint(equalToConstant: 123.0),
            
        ])
    }
    
    func updateRequestView(requests: [String] ) {
        self.recentRequests = requests
        recentRequestView.updateTheRequestView(requests: recentRequests)
    }
    
    let titleButton: UIButton = {
        let label = UIButton()
        label.setTitle("Hello", for: .normal)
        return label
    } ()
    
    private lazy var popularRequestView: RequestView = {
        let view = RequestView(requests: popularRequests, title: "Popular Requests", buttonAction: self.buttonAction)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    private lazy var recentRequestView: RequestView = {
        let view = RequestView(requests: recentRequests, title: "Recent Requests", buttonAction: self.buttonAction)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
}
