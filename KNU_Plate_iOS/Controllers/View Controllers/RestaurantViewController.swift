import UIKit
import SnapKit

class RestaurantViewController: UIViewController {

    let restaurantView = RestaurantView()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(restaurantView)
        let safeArea = self.view.safeAreaLayoutGuide
        restaurantView.snp.makeConstraints { make in
            make.edges.equalTo(safeArea)
        }
        
        restaurantView.tableView.delegate = self
        restaurantView.tableView.dataSource = self
//        restaurantView.tableView.register
        
        restaurantView.nameLabel.text = "반미리코"
        restaurantView.gateNameLabel.text = "북문"
        restaurantView.ratingStackView.setAverageRating(rating: 4.7)
        restaurantView.foodCategoryLabel.text = "세계 음식"
        restaurantView.numberLabel.text = "\(39)명 참여"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("-> viewDidLayoutSubviews")
        guard let currentView = self.currentView else { return }
        currentView.snp.makeConstraints { make in
            make.edges.equalTo(restaurantView.bottomContentsView)
            make.height.equalTo(300)
        }
        restaurantView.bottomContentsView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
}

extension RestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

//extension RestaurantViewController {
//    func instantiateContentsViewControllers() {
//        guard let reviewVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.reviewViewController),
//              let locationVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.locationViewController),
//              let menuVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.menuViewController)
//        else {
//            fatalError()
//        }
//
//        self.reviewVC = reviewVC
//        self.locationVC = locationVC
//        self.menuVC = menuVC
//
//        self.addChild(reviewVC)
//        self.addChild(locationVC)
//        self.addChild(menuVC)
//    }
//
//    func setButtonTarget() {
//        restaurantView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
//        restaurantView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
//        restaurantView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
//    }
//
//    func setDefaultContentView() {
//        currentButton = restaurantView.locationButton
//        currentButton?.isSelected = true
//        currentView = locationVC?.view
//        restaurantView.bottomContentsView.addSubview(currentView!)
//    }
//
//    @objc func buttonWasTapped(_ sender: UIButton) {
//        let tempView: UIView?
//
//        currentButton?.isSelected = false
//
//        switch sender.tag {
//        case 0:
//            tempView = reviewVC?.view
//            currentButton = restaurantView.reviewButton
//        case 1:
//            tempView = locationVC?.view
//            currentButton = restaurantView.locationButton
//        case 2:
//            tempView = menuVC?.view
//            currentButton = restaurantView.menuButton
//        default:
//            return
//        }
//
//        currentButton?.isSelected = true
//
//        guard let view = tempView else { return }
//
//        currentView?.removeFromSuperview()
//        restaurantView.bottomContentsView.addSubview(view)
//        currentView = view
//    }
//}
