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
    
    private let tableHeaderViewHeight: CGFloat = 320 + 3*4
    private let sectionHeaderViewHeight: CGFloat = 72 + 3*4
    
    private var returnEmptyReviewCell: Bool = true
    private var returnEmptyLocationCell: Bool = false
    private var returnEmptyMenuCell: Bool = true
    
    var favoriteButton: UIBarButtonItem?
    
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
        configureFavoriteButton()
        
        currentButton.isSelected = true
        
        restaurantInfoVM.delegate = self
        restaurantInfoVM.setMallID(mallID: mallID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        restaurantInfoVM.refreshViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.restaurantInfoSegue {
            guard let nextVC = segue.destination as? NewReviewViewController else { fatalError() }
            guard let mallID = self.mallID else {
                print("RestaurantInfoViewController - prepare(for segue:) - mallID is empty")
                return
            }
            nextVC.configure(mallID: mallID, existingMenus: restaurantInfoVM.menusForNextVC)
        }
    }
}

// MARK: Private Functions & Selector Functions
extension RestaurantInfoViewController {
    private func setButtonTarget() {
        tabBarView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageView4Tapped))
        customTableView.imageView4.addGestureRecognizer(tapGesture)
        customTableView.imageView4.isUserInteractionEnabled = true
    }
    
    private func configureFavoriteButton() {
        self.favoriteButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteButtonTapped))
        self.favoriteButton?.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        self.favoriteButton?.isEnabled = false
        self.navigationItem.rightBarButtonItems?.insert(favoriteButton!, at: 1)
    }
    
    private func setFavoriteButton(_ isFavorite: Bool) {
        if isFavorite {
            self.favoriteButton?.image = UIImage(systemName: "heart.fill")
        } else {
            self.favoriteButton?.image = UIImage(systemName: "heart")
        }
    }
    
    private func setupTableView() {
        customTableView.tableView.dataSource = self
        customTableView.tableView.delegate = self
        customTableView.tableView.bounces = true
        customTableView.tableView.tableHeaderView?.frame.size.height = tableHeaderViewHeight
        customTableView.tableView.separatorStyle = .none
    }
    
    private func registerCells() {
        let reviewNib = UINib(nibName: Constants.XIB.reviewTableViewCell, bundle: nil)
        let reviewWithoutImageNib = UINib(nibName: Constants.XIB.reviewWithoutImageTableViewCell, bundle: nil)
        let menuNib = UINib(nibName: Constants.XIB.menuRecommendTableViewCell, bundle: nil)
        let reviewCellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewCellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        let locationCellID = Constants.CellIdentifier.locationTableViewCell
        let menuCellID = Constants.CellIdentifier.menuRecommendCell
        customTableView.tableView.register(reviewNib, forCellReuseIdentifier: reviewCellID)
        customTableView.tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: reviewCellID2)
        customTableView.tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: locationCellID)
        customTableView.tableView.register(menuNib, forCellReuseIdentifier: menuCellID)
    }
    
    @objc func buttonWasTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            currentButton = tabBarView.reviewButton
            customTableView.tableView.allowsSelection = true
        case 1:
            currentButton = tabBarView.locationButton
            customTableView.tableView.allowsSelection = false
        case 2:
            currentButton = tabBarView.menuButton
            customTableView.tableView.allowsSelection = false
        default:
            return
        }
        customTableView.tableView.reloadData()
    }
    
    @objc func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        sender.isEnabled = false
        if !restaurantInfoVM.isFavorite {
            // not marked favorite yet
            restaurantInfoVM.markFavorite(markMyFavorite: true)
        } else {
            // already marked favorite
            restaurantInfoVM.markFavorite(markMyFavorite: false)
        }
    }
    
    @objc func imageView4Tapped() {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantImageViewController) as? RestaurantImageViewController else { fatalError() }
        nextVC.navigationItem.title = "리뷰 사진"
        nextVC.mallID = self.mallID
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension RestaurantInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionHeaderViewHeight
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch currentButton.tag {
        case 2:
            return 80
        default:
            return UITableView.automaticDimension // tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentButton.tag {
        case 0:
            if restaurantInfoVM.numberOfReviews == 0 {
                returnEmptyReviewCell = true
                return 1
            } else {
                returnEmptyReviewCell = false
                return restaurantInfoVM.numberOfReviews
            }
        case 1:
            if restaurantInfoVM.numberOfLocations == 0 {
                returnEmptyLocationCell = true
                return 1
            } else {
                returnEmptyLocationCell = false
                return restaurantInfoVM.numberOfLocations
            }
        case 2:
            if restaurantInfoVM.numberOfMenus == 0 {
                returnEmptyMenuCell = true
                return 1
            } else {
                returnEmptyMenuCell = false
                return restaurantInfoVM.numberOfMenus
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentButton.tag {
        case 0:
            return getReusableReviewCell(tableView, cellForRowAt: indexPath, returnPlaceholderCell: returnEmptyReviewCell)
        case 1:
            return getReusableLocationCell(tableView, cellForRowAt: indexPath, returnPlaceholderCell: returnEmptyLocationCell)
        case 2:
            return getReusableMenuCell(tableView, cellForRowAt: indexPath, returnPlaceholderCell: returnEmptyMenuCell)
        default:
            return UITableViewCell()
        }
    }
    
    func getReusableReviewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, returnPlaceholderCell: Bool) -> UITableViewCell {
        if returnPlaceholderCell {
            return UITableViewCell()
        } else {
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
    }
    
    func getReusableLocationCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, returnPlaceholderCell: Bool) -> UITableViewCell {
        if returnPlaceholderCell {
            return UITableViewCell()
        } else {
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
    }
    
    func getReusableMenuCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, returnPlaceholderCell: Bool) -> UITableViewCell {
        if returnPlaceholderCell {
            return UITableViewCell()
        } else {
            guard let menuCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.menuRecommendCell, for: indexPath) as? MenuRecommendationTableViewCell else { fatalError() }
            
            let menuVM = self.restaurantInfoVM.menuAtIndex(indexPath.row)
            
            menuCell.menuLabel.text = menuVM.menuName
            menuCell.totalLikeNumberLabel.text = "\(menuVM.likes)"
            menuCell.totalDislikeNumberLabel.text = "\(menuVM.dislikes)"
            
            menuCell.initializeProgressBar(likePercentage: menuVM.likePercentage)
            menuCell.configureLabels(totalLikes: menuVM.totalLikes)
            
            return menuCell
        }
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
    
    func presentDeleteActionAlert(reviewID: Int) {
        
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
        default:
            return
        }
    }
}

// MARK: - RestaurantInfoViewModelDelegate
extension RestaurantInfoViewController: RestaurantInfoViewModelDelegate {
    func didMarkFavorite() {
        restaurantInfoVM.fetchRestaurantInfo()
        favoriteButton?.isEnabled = true
    }
    
    func didFailedMarkFavorite() {
        SnackBar.make(in: self.view,
                      message: "매장 좋아요에 실패하였습니다. 잠시 후 다시 시도해주세요",
                      duration: .lengthLong).show()
        favoriteButton?.isEnabled = true
    }
    
    func didFetchRestaurantInfo() {
        customTableView.nameLabel.text = restaurantInfoVM.mallName
        customTableView.gateNameLabel.text = restaurantInfoVM.gate
        customTableView.ratingStackView.averageRating = restaurantInfoVM.rating
        customTableView.foodCategoryLabel.text = restaurantInfoVM.category
        customTableView.numberLabel.text = "\(restaurantInfoVM.reviewCount)명 참여"
        setFavoriteButton(restaurantInfoVM.isFavorite)
        favoriteButton?.isEnabled = true
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
    
    func didFetchMenu() {
        customTableView.tableView.reloadData()
    }
}
