import UIKit
import SnapKit

class RestaurantInfoViewController: UIViewController {

    lazy var customTableView = RestaurantTableView(frame: self.view.frame)
    let tabBarView = RestaurantTabBarView()
    
    lazy var currentButton: UIButton = self.tabBarView.reviewButton
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(customTableView)
        
        customTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupTableView()
        
        currentButton.isSelected = true
        setButtonTarget()
    }
    
    func setButtonTarget() {
        tabBarView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
    }
    
    func setupTableView() {
        customTableView.tableView.dataSource = self
        customTableView.tableView.delegate = self
        customTableView.tableView.tableHeaderView?.frame.size.height = 355 + 3*6
        
        customTableView.nameLabel.text = "반미리코"
        customTableView.gateNameLabel.text = "북문"
        customTableView.ratingStackView.averageRating = 4.7
        customTableView.foodCategoryLabel.text = "세계 음식"
        customTableView.numberLabel.text = "\(39)명 참여"
    }
    
    @objc func buttonWasTapped(_ sender: UIButton) {
        currentButton.isSelected = false
        
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
        
        currentButton.isSelected = true
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
