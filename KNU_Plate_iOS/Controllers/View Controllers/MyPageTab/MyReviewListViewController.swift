import UIKit
import SDWebImage


class MyReviewListViewController: UIViewController  {
    
    @IBOutlet var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var viewModel = MyReviewListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchReviewList()
    }
}

//MARK: - Initialization

extension MyReviewListViewController {
    
    func initialize() {
        
        createWelcomeVCObserver()
        createRefreshTokenExpirationObserver()
        initializeViewModel()
        initializeTableView()
    }
    
    func initializeViewModel() {
        
        viewModel.delegate = self
        viewModel.reviewList.removeAll()
    }
    
    func initializeTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let reviewNib = UINib(nibName: Constants.XIB.reviewTableViewCell, bundle: nil)
        let reviewWithoutImageNib = UINib(nibName: Constants.XIB.reviewWithoutImageTableViewCell, bundle: nil)
        
        let reviewCellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewWithoutCellID = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        
        tableView.register(reviewNib, forCellReuseIdentifier: reviewCellID)
        tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: reviewWithoutCellID)
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
}

//MARK: - ReviewListViewModelDelegate

extension MyReviewListViewController: ReviewListViewModelDelegate {
    
    func didFetchReviewListResults() {
        print("✏️ MyReviewListVC - didFetchReviewListResults")
        tableView.reloadData()
        refreshControl.endRefreshing()
        dismissProgressBar()
        tableView.tableFooterView = nil
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func didFetchEmptyReviewListResults() {
        print("✏️ MyReviewListVC - didFetchEmptyReviewListResults")
        tableView.tableFooterView = nil
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    func failedFetchingReviewListResults() {
        
        showSimpleBottomAlertWithAction(message: NetworkError.internalError.localizedDescription,
                                        buttonTitle: "재시도") {
            self.viewModel.fetchReviewList()
        }
    }
    
    func didDeleteMyReview() {
        
        showSimpleBottomAlert(with: "리뷰 삭제 완료 🎉")
        let indexPath = NSIndexPath(row: NSNotFound, section: 0)
        self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        refreshTable()
    }
    
    func failedDeletingMyReview(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MyReviewListViewController: UITableViewDelegate, UITableViewDataSource {
    
    @objc func refreshTable() {
        viewModel.resetValues()
        viewModel.fetchReviewList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > viewModel.reviewList.count - 1 {
            return UITableViewCell()
        }
        
        let reviewVM = viewModel.reviewList[indexPath.row]
        
        let reviewCell = tableView.dequeueReusableCell(
            withIdentifier: Constants.CellIdentifier.reviewTableViewCell,
            for: indexPath) as! ReviewTableViewCell
        
        reviewCell.delegate = self
        
        reviewCell.reviewID                 = reviewVM.reviewID
        reviewCell.userNickname             = reviewVM.userInfo.username
        reviewCell.userNicknameLabel.text   = reviewVM.userInfo.username
        reviewCell.reviewLabel.text         = reviewVM.review
        reviewCell.userID                   = reviewVM.userID
        reviewCell.userMedalImageView.image = setUserMedalImage(medalRank: reviewVM.userInfo.medal)
        reviewCell.rating.setStarsRating(rating: reviewVM.rating)
        reviewCell.configureUI(reviewImageCount: reviewVM.reviewImageFileFolder?.files?.count)
        reviewCell.configureShowMoreButton()
        
        let textViewStyle = NSMutableParagraphStyle()
        textViewStyle.lineSpacing = 2
        let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
        reviewCell.reviewLabel.attributedText = NSAttributedString(string: reviewVM.review,
                                                                   attributes: attributes)
        reviewCell.reviewLabel.font = UIFont.systemFont(ofSize: 14)
        
        if reviewVM.reviewImageFileFolder != nil {
            reviewCell.reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            reviewCell.reviewImageView.sd_setImage(with: viewModel.getReviewImageURL(index: indexPath.row),
                                                   placeholderImage: nil,
                                                   completed: nil)
        } else {
            reviewCell.reviewImageHeight.constant = 0
        }
        
        
        
        reviewCell.userProfileImageView.sd_setImage(with: viewModel.getProfileImageURL(index: indexPath.row),
                                                    placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                    completed: nil)
        return reviewCell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = self.storyboard?.instantiateViewController(
            identifier: Constants.StoryboardID.reviewDetailViewController
        ) as? ReviewDetailViewController else { return }
        
        viewModel.selectedIndex = indexPath
        let reviewDetailVM = viewModel.reviewList[indexPath.row]
        
        let reviewID = reviewDetailVM.reviewID
        let userID = reviewDetailVM.userID
        let profileImageURL = viewModel.getProfileImageURL(index: indexPath.row)
        let reviewImageFiles = reviewDetailVM.reviewImageFileFolder?.files
        let nickname = reviewDetailVM.userInfo.displayName
        let medal = reviewDetailVM.userInfo.medal
        let rating = reviewDetailVM.rating
        let review = reviewDetailVM.review
        
        let reviewDetails = ReviewDetail(userID: userID,
                                         reviewID: reviewID,
                                         profileImageURL: profileImageURL,
                                         nickname: nickname,
                                         medal: medal,
                                         reviewImageFiles: reviewImageFiles,
                                         rating: rating,
                                         review: review)
        
        vc.configure(with: reviewDetails)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - ReviewTableViewCellDelegate

extension MyReviewListViewController: ReviewTableViewCellDelegate {
    
    func presentDeleteActionAlert(reviewID: Int?) {
        
        guard let reviewID = reviewID else { return }
        self.viewModel.deleteMyReview(reviewID: reviewID)
    }
    
    
    // 내가 쓴 글만 불러오기 때문에 이건 사실 필요 X
    func goToReportReviewVC(reviewID: Int?, displayName: String?) {
        //
    }
    
    func presentDeleteActionAlert(reviewID: Int) {
        
        self.presentAlertWithConfirmAction(title: "정말 삭제하시겠습니까?",
                                           message: "") { selectedOk in
            if selectedOk {
                self.viewModel.deleteMyReview(reviewID: reviewID)
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension MyReviewListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 80 - scrollView.frame.size.height) {
            
            if !viewModel.isFetchingData {
                tableView.tableFooterView = createSpinnerFooterView()
                viewModel.fetchReviewList()
            }
        }
    }
}


