import UIKit
import SnapKit
import SDWebImage

class RestaurantInfoViewController: UIViewController {

    lazy var customTableView = RestaurantTableView(frame: self.view.frame)
    let tabBarView = RestaurantTabBarView()
    
    lazy var currentButton: UIButton = self.tabBarView.reviewButton {
        didSet {
            oldValue.isSelected = false
            currentButton.isSelected = true
        }
    }
    
    var restaurantInfoViewModel = RestaurantInfoViewModel()
    
    var mallID: Int?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(customTableView)
        
        customTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupTableView()
        setButtonTarget()
        
        currentButton.isSelected = true
        
//        restaurantInfoViewModel.delegate = self
//        restaurantInfoViewModel.setMallID(mallID: mallID)
//        restaurantInfoViewModel.fetchRestaurantInfo()
//        restaurantInfoViewModel.fetchTitleImages()
    }
    
    func setButtonTarget() {
        tabBarView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
    }
    
    func setupTableView() {
        customTableView.tableView.dataSource = self
        customTableView.tableView.delegate = self
        customTableView.tableView.bounces = false
        customTableView.tableView.tableHeaderView?.frame.size.height = 320 + 3*4
        
        customTableView.nameLabel.text = "반미리코"
        customTableView.gateNameLabel.text = "북문"
        customTableView.ratingStackView.averageRating = 4.7
        customTableView.foodCategoryLabel.text = "세계 음식"
        customTableView.numberLabel.text = "\(39)명 참여"
    }
    
    @objc func buttonWasTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentButton = tabBarView.reviewButton
        case 1:
            currentButton = tabBarView.locationButton
        case 2:
            currentButton = tabBarView.menuButton
        default:
            return
        }
        
        customTableView.tableView.reloadData()
    }
}

extension RestaurantInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 72 + 3*4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return tabBarView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentButton.tag {
        case 0:
            return 5
        case 1:
            return 1
        case 2:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension RestaurantInfoViewController: RestaurantInfoViewModelDelegate {
    func didFetchRestaurantInfo() {
        customTableView.nameLabel.text = restaurantInfoViewModel.mallName
        customTableView.gateNameLabel.text = restaurantInfoViewModel.gate
        customTableView.ratingStackView.averageRating = restaurantInfoViewModel.rating
        customTableView.foodCategoryLabel.text = restaurantInfoViewModel.category
//        customTableView.favoriteButton.isSelected = restaurantInfoViewModel.isFavorite
//        customTableView.numberLabel.text = "\(39)명 참여"
    }
    
    func didFetchRestaurantImages() {
        customTableView.imageButton1.sd_setImage(with: restaurantInfoViewModel.image1URL,
                                                 for: .normal,
                                                 placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
        customTableView.imageButton2.sd_setImage(with: restaurantInfoViewModel.image2URL,
                                                 for: .normal,
                                                 placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
        customTableView.imageButton3.sd_setImage(with: restaurantInfoViewModel.image3URL,
                                                 for: .normal,
                                                 placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
        customTableView.imageButton4.sd_setImage(with: restaurantInfoViewModel.image4URL,
                                                 for: .normal,
                                                 placeholderImage: UIImage(systemName: "photo.on.rectangle.angled"))
    }
}
