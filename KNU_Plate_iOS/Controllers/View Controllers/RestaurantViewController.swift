import UIKit
import SnapKit

class RestaurantViewController: UIViewController {

    lazy var restaurantView = RestaurantView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
    
    weak var reviewVC: ExampleViewController?
    weak var locationVC: LocationViewController?
    weak var menuVC: MenuViewController?
    
    var currentView: UIView?
    var currentButton: UIButton?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("+++++ RestaurantViewController viewDidLoad")
        print("+++++ safeAreaLayoutGuide height: \(self.view.safeAreaLayoutGuide.layoutFrame.height)")
        
        restaurantView.scrollView.delegate = self
        restaurantView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.view.addSubview(restaurantView)
        
        // 위에서 lazy로 frame 잡아줬어도 autolayout 안하면
        // contentInsetAdjustmentBehavior = .never로 했을때 inset이 이상해진다.
        
        let safeArea = self.view.safeAreaLayoutGuide
        restaurantView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        
        restaurantView.nameLabel.text = "반미리코"
        restaurantView.gateNameLabel.text = "북문"
        restaurantView.ratingStackView.setAverageRating(rating: 4.7)
        restaurantView.foodCategoryLabel.text = "세계 음식"
        restaurantView.numberLabel.text = "\(39)명 참여"
        
        instantiateContentsViewControllers()
        setButtonTarget()
        setDefaultContentView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("+++++ RestaurantViewController viewDidLayoutSubviews")
        
//        guard let currentView = self.currentView else { return }
//        currentView.snp.makeConstraints { make in
//            make.edges.equalTo(restaurantView.bottomContentsView)
//            make.height.equalTo(250).priority(.low)
//        }
    }
}

extension RestaurantViewController {
    func instantiateContentsViewControllers() {
        let kevinSB = UIStoryboard(name: "Kevin", bundle: nil)
        guard let reviewVC = kevinSB.instantiateViewController(withIdentifier: "ExampleViewController") as? ExampleViewController,
              let locationVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.locationViewController) as? LocationViewController,
              let menuVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.menuViewController) as? MenuViewController
        else {
            fatalError()
        }
        
        self.reviewVC = reviewVC
        self.locationVC = locationVC
        self.menuVC = menuVC
        
//        reviewVC.view.translatesAutoresizingMaskIntoConstraints = false
//        locationVC.view.translatesAutoresizingMaskIntoConstraints = false
//        menuVC.view.translatesAutoresizingMaskIntoConstraints = false

        self.addChild(reviewVC)
        self.addChild(locationVC)
        self.addChild(menuVC)
        
        reviewVC.didMove(toParent: self)
        menuVC.didMove(toParent: self)
    }
    
    func setButtonTarget() {
        restaurantView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        restaurantView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        restaurantView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
    }
    
    func setDefaultContentView() {
        currentButton = restaurantView.reviewButton
        currentButton?.isSelected = true
        currentView = reviewVC?.view
        
        guard let currentView = currentView else { return }
        
        restaurantView.bottomContentView.addSubview(currentView)
        
        currentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func buttonWasTapped(_ sender: UIButton) {
        let tempView: UIView?
        
        currentButton?.isSelected = false
        
        switch sender.tag {
        case 0:
            tempView = reviewVC?.view
            currentButton = restaurantView.reviewButton
        case 1:
            tempView = locationVC?.view
            currentButton = restaurantView.locationButton
        case 2:
            tempView = menuVC?.view
            currentButton = restaurantView.menuButton
        default:
            return
        }
        
        currentButton?.isSelected = true
        
        guard let view = tempView else { return }
        
        currentView?.removeFromSuperview()
        restaurantView.bottomContentView.addSubview(view)
        currentView = view
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RestaurantViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentView = self.currentView,
              let reviewVC = self.reviewVC,
              let menuVC = self.menuVC
        else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        let topContentViewHeight: CGFloat = restaurantView.topContentView.frame.height
        
        print("***** safeArea y: \(self.view.safeAreaLayoutGuide.layoutFrame.origin.y)")
        print("+++++ RestaurantViewController - scrollViewDidScroll - contentOffsetY: \(contentOffsetY)")
//        print("+++++ RestaurantViewController - scrollViewDidScroll - topContentViewHeight: \(topContentViewHeight)")
        if topContentViewHeight == 0 { return }
        
        switch currentView {
        case reviewVC.view:
            if contentOffsetY >= topContentViewHeight {
                scrollView.contentOffset.y = topContentViewHeight
            }
        case menuVC.view:
//            if yPosition >= topContentViewHeight {
//                menuVC.tableView.isScrollEnabled = true
//                restaurantView.scrollView.isScrollEnabled = false
//            }
            return
        default:
            return
        }
    }
}
