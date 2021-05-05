import UIKit

class RestaurantViewController: UIViewController {

    let stackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins.left = 30
//        stackView.layoutMargins.right = 30
        return stackView
    }()
    
    let nameLabel: UILabel = UILabel()
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favorite tab bar icon"), for: .normal)
//        button.setImage(UIImage(named: "favorite tab bar icon(filled)"), for: .selected)
        button.addBounceReactionWithoutFeedback()
        return button
    }()
    let nameLabel2: UILabel = UILabel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let safeArea = self.view.safeAreaLayoutGuide
        nameLabel.text = "반미리코"
        nameLabel2.text = "끄악"
        stackView1.addArrangedSubview(nameLabel)
        stackView1.addArrangedSubview(favoriteButton)
        stackView1.addArrangedSubview(nameLabel2)
        self.view.addSubview(stackView1)
        stackView1.snp.makeConstraints { make in
            make.top.equalTo(safeArea.snp.top)
            make.left.right.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }
}
