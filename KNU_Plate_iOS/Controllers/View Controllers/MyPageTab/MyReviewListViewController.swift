import UIKit
import SDWebImage


class MyReviewListViewController: UIViewController  {
 
    @IBOutlet var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var viewModel = ReviewListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchReviewList(myReview: "Y")
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
            self.viewModel.fetchReviewList(myReview: "Y")
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
        viewModel.fetchReviewList(myReview: "Y")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row > viewModel.reviewList.count - 1 {
            print("❗️ Index Out Of Range -- indexPathRow: \(indexPath.row), reviewList count: \(viewModel.reviewList.count)")
            return UITableViewCell()
        }
 
        if viewModel.reviewList[indexPath.row].reviewImageFileFolder != nil {
            
            let reviewCell = tableView.dequeueReusableCell(
                withIdentifier: Constants.CellIdentifier.reviewTableViewCell,
                for: indexPath
            ) as! ReviewTableViewCell
    
            reviewCell.delegate = self
            reviewCell.configure(with: viewModel.reviewList[indexPath.row])
            
            let reviewImageURL = reviewCell.getReviewImageDownloadURL()
            let profileImageURL = reviewCell.getProfileImageDownloadURL()
        
            reviewCell.reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            reviewCell.reviewImageView.sd_setImage(with: reviewImageURL,
                                                   placeholderImage: nil,
                                                   options: .continueInBackground,
                                                   completed: nil)
            reviewCell.userProfileImageView.sd_setImage(with: profileImageURL,
                                                        placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                        options: .continueInBackground,
                                                        completed: nil)
            return reviewCell
        }
        
        else {
            
            let reviewCellNoImages = tableView.dequeueReusableCell(
                withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell,
                for: indexPath
            ) as! ReviewWithoutImageTableViewCell
            
            reviewCellNoImages.delegate = self
            reviewCellNoImages.configure(with: viewModel.reviewList[indexPath.row])
            
            let profileImageURL = reviewCellNoImages.getProfileImageDownloadURL()

            reviewCellNoImages.userProfileImageView.sd_setImage(with: profileImageURL,
                                                                placeholderImage: UIImage(named: Constants.Images.defaultProfileImage),
                                                                           options: .continueInBackground,
                                                                           completed: nil)
            
            return reviewCellNoImages
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectedIndex = indexPath
        
        guard let vc = self.storyboard?.instantiateViewController(
                identifier: Constants.StoryboardID.reviewDetailViewController
        ) as? ReviewDetailViewController else { return }
        
        guard let cell = tableView.cellForRow(
                at: viewModel.selectedIndex!
        ) as? ReviewTableViewCell else { return }
        
        let reviewDetails = cell.getReviewDetails()
        vc.configure(with: reviewDetails)
    
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ReviewTableViewCellDelegate

extension MyReviewListViewController: ReviewTableViewCellDelegate {
    
    func goToReportReviewVC(reviewID: Int, displayName: String) {
        // 사실 내 글 불러오기인데 이건 없어도 될듯
        return
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
                viewModel.fetchReviewList(myReview: "Y")
            }
        }
    }
}


