import UIKit
import SnapKit
import SDWebImage
import SnackBar_swift

class RestaurantInfoViewController: UIViewController {

    private lazy var customTableView = RestaurantTableView(frame: self.view.frame)
    private let tabBarView = RestaurantTabBarView()
    
    private lazy var currentButton: UIButton = self.tabBarView.reviewButton {
        didSet {
            oldValue.isSelected = false
            currentButton.isSelected = true
        }
    }
    
    private var restaurantInfoVM = RestaurantInfoViewModel()
    
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
        registerCells()
        
        currentButton.isSelected = true
        
        restaurantInfoVM.delegate = self
        restaurantInfoVM.setMallID(mallID: mallID)
        restaurantInfoVM.fetchRestaurantInfo()
        restaurantInfoVM.fetchTitleImages()
        restaurantInfoVM.fetchReviews()
    }
    
    private func setButtonTarget() {
        tabBarView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
    }
    
    private func setupTableView() {
        customTableView.tableView.dataSource = self
        customTableView.tableView.delegate = self
        customTableView.tableView.bounces = false
        customTableView.tableView.tableHeaderView?.frame.size.height = 320 + 3*4
        
//        customTableView.nameLabel.text = "반미리코"
//        customTableView.gateNameLabel.text = "북문"
//        customTableView.ratingStackView.averageRating = 4.7
//        customTableView.foodCategoryLabel.text = "세계 음식"
//        customTableView.numberLabel.text = "\(39)명 참여"
    }
    
    private func registerCells() {
        let reviewNib = UINib(nibName: Constants.XIB.reviewTableViewCell, bundle: nil)
        let reviewWithoutImageNib = UINib(nibName: Constants.XIB.reviewWithoutImageTableViewCell, bundle: nil)
        let reviewCellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewCellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        customTableView.tableView.register(reviewNib, forCellReuseIdentifier: reviewCellID)
        customTableView.tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: reviewCellID2)
        customTableView.tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: Constants.CellIdentifier.locationTableViewCell)
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

// MARK: - UITableViewDataSource
extension RestaurantInfoViewController: UITableViewDataSource {
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
            return self.restaurantInfoVM.numberOfReviews
        case 1:
            return self.restaurantInfoVM.numberOfLocations
        case 2:
            return self.restaurantInfoVM.numberOfMenus
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentButton.tag {
        case 0:
            return getReusableReviewCell(tableView, cellForRowAt: indexPath)
        case 1:
            return getReusableLocationCell(tableView, cellForRowAt: indexPath)
        case 2:
            return getReusableMenuCell(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func getReusableReviewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reviewVM = self.restaurantInfoVM.reviewAtIndex(indexPath.row)
        
        //리뷰 이미지에 대한 정보가 존재한다면 일반 reviewCell
        if reviewVM.hasReviewImage {
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
            reviewCell.delegate = self
            
            reviewCell.reviewID = reviewVM.reviewID
            reviewCell.userNickname = reviewVM.userNickname
            reviewCell.userMedalImageView.image = setUserMedalImage(medalRank: reviewVM.medal)
            reviewCell.rating.setStarsRating(rating: reviewVM.rating)
            reviewCell.userNicknameLabel.text = reviewVM.userNickname
            reviewCell.reviewLabel.text = reviewVM.reviewContent
            reviewCell.configureUI(reviewImageCount: reviewVM.reviewImageCount)
            reviewCell.configureShowMoreButton()
            
            let textViewStyle = NSMutableParagraphStyle()
            textViewStyle.lineSpacing = 2
            let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
            reviewCell.reviewLabel.attributedText = NSAttributedString(string: reviewVM.reviewContent, attributes: attributes)
            reviewCell.reviewLabel.font = UIFont.systemFont(ofSize: 14)
        
            reviewCell.reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            reviewCell.reviewImageView.sd_setImage(with: reviewVM.reviewImageURL,
                                                   placeholderImage: nil,
                                                   completed: nil)
            reviewCell.userProfileImageView.sd_setImage(with: reviewVM.profileImageURL,
                                                        placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                        completed: nil)
            return reviewCell
        }
        
        // 리뷰 이미지가 아예 없으면 reviewCellWithoutReviewImages
        else {
            
            guard let reviewCellNoImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
            
            reviewCellNoImages.delegate = self
            
            reviewCellNoImages.reviewID = reviewVM.reviewID
            reviewCellNoImages.userNickname = reviewVM.userNickname
            reviewCellNoImages.userMedalImageView.image = setUserMedalImage(medalRank: reviewVM.medal)
            reviewCellNoImages.rating.setStarsRating(rating: reviewVM.rating)
            reviewCellNoImages.userNicknameLabel.text = reviewVM.userNickname
            reviewCellNoImages.reviewLabel.text = reviewVM.reviewContent
            reviewCellNoImages.configureUI()
            reviewCellNoImages.configureShowMoreButton()
            
            let textViewStyle = NSMutableParagraphStyle()
            textViewStyle.lineSpacing = 2
            let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
            reviewCellNoImages.reviewLabel.attributedText = NSAttributedString(string: reviewVM.reviewContent, attributes: attributes)
            reviewCellNoImages.reviewLabel.font = UIFont.systemFont(ofSize: 14)
            
            reviewCellNoImages.userProfileImageView.sd_setImage(with: reviewVM.profileImageURL,
                                                        placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                        completed: nil)
            
            return reviewCellNoImages
        }
    }
    
    func getReusableLocationCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.locationTableViewCell, for: indexPath) as? LocationTableViewCell else { fatalError() }
        
        let mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: restaurantInfoVM.latitude, longitude: restaurantInfoVM.longitude))
        
        cell.mapView.setMapCenter(mapPoint, zoomLevel: 1, animated: true)
        cell.poiItem.markerType = .bluePin
        cell.poiItem.mapPoint = mapPoint
        cell.poiItem.itemName = restaurantInfoVM.mallName
        cell.mapView.add(cell.poiItem)
        cell.mapView.select(cell.poiItem, animated: true)
        
        cell.addressLabel.text = restaurantInfoVM.address
        
        return cell
    }
    
    func getReusableMenuCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - ReviewTableViewCellDelegate
extension RestaurantInfoViewController: ReviewTableViewCellDelegate {
    func goToReportReviewVC(reviewID: Int?, displayName: String?) {
        guard let reviewID = reviewID, let displayName = displayName else {
            SnackBar.make(in: self.view,
                          message: "정보를 불러올 수 없습니다. 다시 시도해주세요.",
                          duration: .lengthLong).show()
            return
        }
        
        guard displayName != User.shared.displayName else {
            
            SnackBar.make(in: self.view,
                          message: "본인 게시글을 본인이 신고할 수는 없습니다 🤔",
                          duration: .lengthLong).show()
            return
        }
   
        let storyboard = UIStoryboard(name: "Kevin", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.reportReviewViewController) as? ReportReviewViewController else {
            fatalError()
        }
        vc.reviewID = reviewID
        self.present(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension RestaurantInfoViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = customTableView.tableView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        switch currentButton.tag {
        case 0:
            if contentHeight > frameHeight + 100 && contentOffsetY > contentHeight - frameHeight - 100 && restaurantInfoVM.hasMoreReview && !restaurantInfoVM.isFetchingReview {
                // fetch more
                restaurantInfoVM.fetchReviews()
            }
        case 1:
            return
        case 2:
            return
        default:
            return
        }
    }
}

// MARK: - RestaurantInfoViewModelDelegate
extension RestaurantInfoViewController: RestaurantInfoViewModelDelegate {
    func didFetchRestaurantInfo() {
        customTableView.nameLabel.text = restaurantInfoVM.mallName
        customTableView.gateNameLabel.text = restaurantInfoVM.gate
        customTableView.ratingStackView.averageRating = restaurantInfoVM.rating
        customTableView.foodCategoryLabel.text = restaurantInfoVM.category
        customTableView.favoriteButton.isSelected = restaurantInfoVM.isFavorite
        customTableView.numberLabel.text = "\(restaurantInfoVM.reviewCount)명 참여"
    }
    
    func didFetchRestaurantImages() {
        customTableView.imageView1.sd_setImage(with: restaurantInfoVM.image1URL,
                                               placeholderImage: UIImage(named: Constants.Images.defaultRestaurantTitleImage))
        customTableView.imageView2.sd_setImage(with: restaurantInfoVM.image2URL,
                                               placeholderImage: UIImage(named: Constants.Images.defaultRestaurantTitleImage))
        customTableView.imageView3.sd_setImage(with: restaurantInfoVM.image3URL,
                                               placeholderImage: UIImage(named: Constants.Images.defaultRestaurantTitleImage))
        customTableView.imageView4.sd_setImage(with: restaurantInfoVM.image4URL,
                                               placeholderImage: UIImage(named: Constants.Images.defaultRestaurantTitleImage))
    }
    
    func didFetchReview() {
        customTableView.tableView.reloadData()
    }
}
