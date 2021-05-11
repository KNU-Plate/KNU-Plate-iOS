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
            make.top.bottom.equalTo(safeArea)
            make.left.right.equalToSuperview()
        }
        
        restaurantView.nameLabel.text = "반미리코"
        restaurantView.gateNameLabel.text = "북문"
        restaurantView.ratingStackView.setAverageRating(rating: 4.7)
        restaurantView.foodCategoryLabel.text = "세계 음식"
        restaurantView.numberLabel.text = "\(39)명 참여"
    }
    
    override func viewDidLayoutSubviews() {
        print("-> \(restaurantView.locationButton.frame.height)")
    }
}
