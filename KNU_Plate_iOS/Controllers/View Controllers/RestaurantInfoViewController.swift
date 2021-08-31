import UIKit
import SnapKit
import SDWebImage
import SnackBar_swift

protocol NewReviewDelegate: AnyObject {
    func didCompleteReviewUpload()
}

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
    
    private var favoriteButton: UIBarButtonItem?
    
    var mallID: Int?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(customTableView)
        
        customTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        createWelcomeVCObserver()
        createRefreshTokenExpirationObserver()
        setupTableView()
        setButtonTarget()
        registerCells()
        configureFavoriteButton()
        createObservers()
        
        currentButton.isSelected = true
        
        restaurantInfoVM.delegate = self
        restaurantInfoVM.setMallID(mallID: mallID)
        
        restaurantInfoVM.fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.restaurantInfoSegue {
            guard let nextVC = segue.destination as? NewReviewViewController else { fatalError() }
            guard let mallID = self.mallID else {
                print("RestaurantInfoViewController - prepare(for segue:) - mallID is empty")
                return
            }
            nextVC.delegate = self
            nextVC.configure(mallID: mallID, existingMenus: restaurantInfoVM.menusForNextVC)
        }
    }
}

// MARK: - Private Functions & Selector Functions
extension RestaurantInfoViewController {
    private func setButtonTarget() {
        tabBarView.reviewButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.locationButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        tabBarView.menuButton.addTarget(self, action: #selector(buttonWasTapped(_:)), for: .touchUpInside)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        customTableView.imageView1.addGestureRecognizer(tapGesture1)
        customTableView.imageView2.addGestureRecognizer(tapGesture2)
        customTableView.imageView3.addGestureRecognizer(tapGesture3)
        customTableView.imageView4.addGestureRecognizer(tapGesture4)
        customTableView.imageView1.isUserInteractionEnabled = true
        customTableView.imageView2.isUserInteractionEnabled = true
        customTableView.imageView3.isUserInteractionEnabled = true
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
        customTableView.tableView.showsVerticalScrollIndicator = false
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
            customTableView.tableView.allowsSelection = true
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
            // not marked favorite
            restaurantInfoVM.markFavorite(markMyFavorite: true)
        } else {
            // already marked favorite
            restaurantInfoVM.markFavorite(markMyFavorite: false)
        }
    }
    
    @objc func imageViewTapped() {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantImageViewController) as? RestaurantImageViewController else { fatalError() }
        nextVC.navigationItem.title = "리뷰 사진"
        nextVC.mallID = self.mallID
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func createObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didMarkFavorite),
                                               name: NSNotification.Name.didMarkFavorite,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didFailedMarkFavorite),
                                               name: NSNotification.Name.didFailedMarkFavorite,
                                               object: nil)
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
        if currentButton.tag == 2 && restaurantInfoVM.numberOfMenus > 0 {
            return 80
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentButton.tag {
        case 0:
            if restaurantInfoVM.numberOfReviews == 0 {
                return 1
            } else {
                return restaurantInfoVM.numberOfReviews
            }
        case 1:
            if restaurantInfoVM.numberOfLocations == 0 {
                return 1
            } else {
                return restaurantInfoVM.numberOfLocations
            }
        case 2:
            if restaurantInfoVM.numberOfMenus == 0 {
                return 1
            } else {
                return restaurantInfoVM.numberOfMenus
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentButton.tag {
        case 0:
            return getReusableReviewCell(tableView, cellForRowAt: indexPath, returnPlaceholderCell: restaurantInfoVM.numberOfReviews == 0)
        case 1:
            return getReusableLocationCell(tableView, cellForRowAt: indexPath, returnPlaceholderCell: restaurantInfoVM.numberOfLocations == 0)
        case 2:
            return getReusableMenuCell(tableView, cellForRowAt: indexPath, returnPlaceholderCell: restaurantInfoVM.numberOfMenus == 0)
        default:
            return UITableViewCell()
        }
    }
    
    func getReusableReviewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, returnPlaceholderCell: Bool) -> UITableViewCell {
        
        if returnPlaceholderCell {
            let cell = EmptyStateTableViewCell()
            cell.update(titleText: "아직 작성된 리뷰가 없어요.\n첫 리뷰를 작성해보세요!", animationName: "empty")
            cell.animationView.play()
            return cell
        } else {
            
            let reviewVM = self.restaurantInfoVM.reviewAtIndex(indexPath.row)
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
            reviewCell.delegate = self
            
            reviewCell.reviewID = reviewVM.reviewID
            reviewCell.userNickname = reviewVM.userNickname
            reviewCell.userID = reviewVM.userID
            reviewCell.userMedalImageView.image = setUserMedalImage(medalRank: reviewVM.medal)
            reviewCell.rating.setStarsRating(rating: reviewVM.rating)
            reviewCell.userNicknameLabel.text = reviewVM.userNickname
            reviewCell.reviewLabel.text = reviewVM.reviewContent
            reviewCell.dateLabel.text = reviewVM.getFormattedDate()
            reviewCell.configureUI(reviewImageCount: reviewVM.reviewImageCount)
            reviewCell.configureShowMoreButton()
            
            let textViewStyle = NSMutableParagraphStyle()
            textViewStyle.lineSpacing = 2
            let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
            reviewCell.reviewLabel.attributedText = NSAttributedString(string: reviewVM.reviewContent, attributes: attributes)
            reviewCell.reviewLabel.font = UIFont.systemFont(ofSize: 14)
            
            if reviewVM.hasReviewImage {
                reviewCell.reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                reviewCell.reviewImageView.sd_setImage(with: reviewVM.reviewImageURL,
                                                       placeholderImage: nil,
                                                       completed: nil)
            } else {
                reviewCell.reviewImageHeight.constant = 0
            }
    
            reviewCell.userProfileImageView.sd_setImage(with: reviewVM.profileImageURL,
                                                        placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                        completed: nil)
            return reviewCell
            
        }
    }
    
    func getReusableLocationCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, returnPlaceholderCell: Bool) -> UITableViewCell {
        if returnPlaceholderCell {
            let cell = EmptyStateTableViewCell()
            cell.update(titleText: "아직 위치가 등록되지 않았어요.", animationName: "empty")
            cell.animationView.play()
            return cell
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
            let cell = EmptyStateTableViewCell()
            cell.update(titleText: "아직 작성된 리뷰가 없어요.\n첫 리뷰를 작성해보세요!", animationName: "empty")
            cell.animationView.play()
            return cell
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
    // 게시글 신고하기
    func goToReportReviewVC(reviewID: Int?, displayName: String?) {
        guard let reviewID = reviewID, let displayName = displayName else {
            self.showSimpleBottomAlert(with: "일시적인 서비스 오류입니다. 잠시 후 다시 시도해주세요. 😥")
            return
        }
        let storyboard = UIStoryboard(name: "Kevin", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardID.reportReviewViewController) as? ReportReviewViewController else {
            fatalError()
        }
        vc.reviewID = reviewID
        self.present(vc, animated: true)
    }
    
    // 내가 쓴 리뷰 삭제
    func presentDeleteActionAlert(reviewID: Int?) {
        guard let reviewID = reviewID else {
            self.showSimpleBottomAlert(with: "일시적인 서비스 오류입니다. 잠시 후 다시 시도해주세요. 😥")
            return
        }
        self.presentAlertWithConfirmAction(title: "정말 삭제하시겠습니까?",
                                           message: "") { selectedOk in
            if selectedOk {
                //
                self.restaurantInfoVM.deleteMyReview(reviewID: reviewID)
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentButton.tag {
        case 0:
            if restaurantInfoVM.numberOfReviews == 0 {
                tableView.deselectRow(at: indexPath, animated: false)
                return
            }
            
            let kevinSB = UIStoryboard(name: "Kevin", bundle: nil)
            guard let nextVC = kevinSB.instantiateViewController(withIdentifier: Constants.StoryboardID.reviewDetailViewController) as? ReviewDetailViewController else { fatalError() }
            let reviewVM = self.restaurantInfoVM.reviewAtIndex(indexPath.row)
            
            let userID = reviewVM.userID
            let reviewID = reviewVM.reviewID
            let profileImageURL = reviewVM.profileImageURL
            let nickname = reviewVM.userNickname
            let medal = reviewVM.medal
            let rating = reviewVM.rating
            let review = reviewVM.reviewContent
            let reviewImageFiles = reviewVM.reviewImageFiles
            let date = reviewVM.getFormattedDate()
            
            let reviewDetails = ReviewDetail(userID: userID,
                                             reviewID: reviewID,
                                             profileImageURL: profileImageURL,
                                             nickname: nickname,
                                             medal: medal,
                                             reviewImageFiles: reviewImageFiles,
                                             rating: rating,
                                             review: review,
                                             date: date)
            nextVC.configure(with: reviewDetails)
            self.navigationController?.pushViewController(nextVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        case 1:
            if restaurantInfoVM.numberOfLocations == 0 {
                tableView.deselectRow(at: indexPath, animated: false)
                return
            }
            
            let url: String
            if let kakaoMallID = restaurantInfoVM.kakaoMallID {
                url = "kakaomap://place?id=\(kakaoMallID)"
            } else {
                url = "kakaomap://look?p=\(restaurantInfoVM.latitude),\(restaurantInfoVM.longitude)"
            }
            
            guard let url = URL(string: url) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                print("open URL: \(url)")
                self.presentAlertWithConfirmAction(title: "카카오맵 열기",
                                                   message: "카카오맵으로 연결하시겠습니까?") { isOKAction in
                    if isOKAction {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            } else {
                guard let baseURL = URL(string: "https://itunes.apple.com/us/app/id304608425?mt=8") else { return }
                print("open baseURL: \(baseURL)")
                self.presentAlertWithConfirmAction(title: "카카오맵 설치",
                                                   message: "카카오맵 설치 화면으로 이동하시겠습니까?") { isOKAction in
                    if isOKAction {
                        UIApplication.shared.open(baseURL, options: [:], completionHandler: nil)
                    }
                }
            }
            tableView.deselectRow(at: indexPath, animated: false)
        default:
            return
        }
    }
}

// MARK: - Mark Favorite Functions
extension RestaurantInfoViewController {
    @objc func didMarkFavorite() {
        restaurantInfoVM.fetchRestaurantInfo()
    }
    
    @objc func didFailedMarkFavorite() {
        self.showSimpleBottomAlert(with: "매장 좋아요에 실패하였습니다. 잠시 후 다시 시도해주세요")
        favoriteButton?.isEnabled = true
    }
}

// MARK: - RestaurantInfoViewModelDelegate
extension RestaurantInfoViewController: RestaurantInfoViewModelDelegate {
    func didFetchRestaurantInfo() {
        customTableView.nameLabel.text = restaurantInfoVM.mallName
        customTableView.gateNameLabel.text = restaurantInfoVM.gate
        customTableView.ratingView.averageRating = restaurantInfoVM.rating
        customTableView.foodCategoryLabel.text = restaurantInfoVM.category
        customTableView.numberLabel.text = "\(restaurantInfoVM.reviewCount)명 참여"
        favoriteButton?.isEnabled = true
        setFavoriteButton(restaurantInfoVM.isFavorite)
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
        print("didFetchReview reloadData")
        customTableView.tableView.reloadData()
    }
    
    func didFetchMenu() {
        print("didFetchMenu reloadData")
        customTableView.tableView.reloadData()
    }
    
    func didDeleteMyReview() {
        print("✏️ didDeleteMyReview")
        restaurantInfoVM.refreshViewModel()
    }
    
    func didFailedDeletingMyReview() {
        print("❗️ didFailedDeletiangMyReview")
        self.showSimpleBottomAlert(with: "리뷰 삭제에 실패했습니다. 잠시 후 다시 시도해주세요 😥")
    }
}

// MARK: - NewReviewDelegate
extension RestaurantInfoViewController: NewReviewDelegate {
    func didCompleteReviewUpload() {
        restaurantInfoVM.refreshViewModel()
    }
}
