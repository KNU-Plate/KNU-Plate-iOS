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
    }
    
    func didFetchEmptyReviewListResults() {
        print("✏️ MyReviewListVC - didFetchEmptyReviewListResults")
        tableView.tableFooterView = nil
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
        
        // 아래 코드 수정 고민
        if indexPath.row > viewModel.reviewList.count - 1 {
            print("❗️ Index Out Of Range -- indexPathRow: \(indexPath.row), reviewList count: \(viewModel.reviewList.count)")
            return UITableViewCell()
        }
        
        let reviewVM = viewModel.reviewList[indexPath.row]
 
        if viewModel.reviewList[indexPath.row].reviewImageFileFolder != nil {
            
            let reviewCell = tableView.dequeueReusableCell(
                withIdentifier: Constants.CellIdentifier.reviewTableViewCell,
                for: indexPath) as! ReviewTableViewCell
    
            reviewCell.delegate = self
            
            reviewCell.reviewID                 = reviewVM.reviewID
            reviewCell.userNickname             = reviewVM.userInfo.displayName
            reviewCell.userNicknameLabel.text   = reviewVM.userInfo.displayName
            reviewCell.reviewLabel.text         = reviewVM.review
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
            
            
            reviewCell.reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            reviewCell.reviewImageView.sd_setImage(with: viewModel.getReviewImageURL(index: indexPath.row),
                                                   placeholderImage: nil,
                                                   completed: nil)

            reviewCell.userProfileImageView.sd_setImage(with: viewModel.getProfileImageURL(index: indexPath.row),
                                                        placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                        completed: nil)
            return reviewCell

        }
        
        else {
            
            let reviewCellNoImages = tableView.dequeueReusableCell(
                withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell,
                for: indexPath
            ) as! ReviewWithoutImageTableViewCell
            
            reviewCellNoImages.delegate = self
            
            reviewCellNoImages.reviewID                 = reviewVM.reviewID
            reviewCellNoImages.userNickname             = reviewVM.userInfo.displayName
            reviewCellNoImages.userNicknameLabel.text   = reviewVM.userInfo.displayName
            reviewCellNoImages.reviewLabel.text         = reviewVM.review
            reviewCellNoImages.userMedalImageView.image = setUserMedalImage(medalRank: reviewVM.userInfo.medal)
            reviewCellNoImages.rating.setStarsRating(rating: reviewVM.rating)

            reviewCellNoImages.configureUI()
            reviewCellNoImages.configureShowMoreButton()
            
            let textViewStyle = NSMutableParagraphStyle()
            textViewStyle.lineSpacing = 2
            let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
            reviewCellNoImages.reviewLabel.attributedText = NSAttributedString(string: reviewVM.review,
                                                                               attributes: attributes)
            reviewCellNoImages.reviewLabel.font = UIFont.systemFont(ofSize: 14)
            

            reviewCellNoImages.userProfileImageView.sd_setImage(with: viewModel.getProfileImageURL(index: indexPath.row),
                                                                placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                                           options: .continueInBackground,
                                                                           completed: nil)
            
            return reviewCellNoImages
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        viewModel.selectedIndex = indexPath
//
//        guard let vc = self.storyboard?.instantiateViewController(
//                identifier: Constants.StoryboardID.reviewDetailViewController
//        ) as? ReviewDetailViewController else { return }
//
//        guard let cell = tableView.cellForRow(
//                at: viewModel.selectedIndex!
//        ) as? ReviewTableViewCell else { return }
//
//        let reviewDetails = cell.getReviewDetails()
//        vc.configure(with: reviewDetails)
//
//        navigationController?.pushViewController(vc, animated: true)
//    }
}

//MARK: - ReviewTableViewCellDelegate

extension MyReviewListViewController: ReviewTableViewCellDelegate {
    
    // 내가 쓴 글만 불러오기 때문에 이건 사실 필요 X
    func goToReportReviewVC(reviewID: Int?, displayName: String?) {
        
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


