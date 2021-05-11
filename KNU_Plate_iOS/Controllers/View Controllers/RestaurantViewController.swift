import UIKit
import SnapKit

class RestaurantViewController: UIViewController {

    let restaurantView = RestaurantView()
    
    var reviewVC: UIViewController?
    var locationVC: UIViewController?
    var menuVC: UIViewController?
    
    var currentView: UIView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(restaurantView)
        let safeArea = self.view.safeAreaLayoutGuide
        restaurantView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeArea)
            make.left.right.equalToSuperview()
        }
        
        restaurantView.nameLabel.text = "반미리코"
        restaurantView.gateNameLabel.text = "북문"
        restaurantView.ratingStackView.setAverageRating(rating: 4.7)
        restaurantView.foodCategoryLabel.text = "세계 음식"
        restaurantView.numberLabel.text = "\(39)명 참여"
        
        instantiateContentsViewControllers()
        setButtonTarget()
        
    }
    
    override func viewDidLayoutSubviews() {
        print("-> \(restaurantView.locationButton.frame.height)")
    }
}

extension RestaurantViewController {
    func instantiateContentsViewControllers() {
        guard let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.reviewViewController),
              let locationVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.locationViewController),
              let menuVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.menuViewController)
        else {
            fatalError()
        }
        
        self.reviewVC = reviewVC
        self.locationVC = locationVC
        self.menuVC = menuVC
        
        self.addChild(reviewVC)
        self.addChild(locationVC)
        self.addChild(menuVC)
    }
    
    func setButtonTarget() {
        restaurantView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        restaurantView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        restaurantView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
    }
    
    @objc func buttonWasTapped(_ sender: UIButton) {
        let tempView: UIView?
        switch sender.tag {
        case 0:
            tempView = reviewVC?.view
        case 1:
            tempView = locationVC?.view
        case 2:
            tempView = menuVC?.view
        default:
            return
        }
        guard let view = tempView else { fatalError() }
        currentView?.removeFromSuperview()
        restaurantView.bottomContentsView.addSubview(view)
        currentView = view
    }
}
