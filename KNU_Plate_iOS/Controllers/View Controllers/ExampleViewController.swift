import UIKit
import ProgressHUD
import Alamofire
import SnackBar_swift
import SDWebImage

class ExampleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel = ReviewListViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    weak var parentVC: RestaurantInfoViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        let reviewNib = UINib(nibName: Constants.XIB.reviewTableViewCell, bundle: nil)
        let cellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewWithoutImageNib = UINib(nibName: Constants.XIB.reviewWithoutImageTableViewCell, bundle: nil)
        let cellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        tableView.register(reviewNib, forCellReuseIdentifier: cellID)
        tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: cellID2)
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        viewModel.delegate = self
        viewModel.reviewList.removeAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.fetchReviewList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("+++++ ExampleViewController viewWillAppear")
        
        viewModel.fetchReviewList()
    }

    @objc func refreshTable() {
        viewModel.resetValues()
        viewModel.fetchReviewList()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        parentVC = parent as? RestaurantInfoViewController
    }
    
}

//MARK: - ReviewListViewModelDelegate

extension ExampleViewController: ReviewListViewModelDelegate {
    func didDeleteMyReview() {
        //
    }
    
    func failedDeletingMyReview(with error: NetworkError) {
        //
    }
    
    
    func didFetchReviewListResults() {
        print("+++++ ExampleViewController didFetchReviewListResults")
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        dismissProgressBar()
        tableView.tableFooterView = nil
    }
    
    func didFetchEmptyReviewListResults() {
        tableView.tableFooterView = nil
    }
    
    func failedFetchingReviewListResults() {
        
        SnackBar.make(in: self.view,
                      message: "데이터 가져오기 실패. 잠시 후 다시 시도해주세요 🥲",
                      duration: .lengthLong).setAction(with: "재시도", action: {
                        
                        self.viewModel.fetchReviewList()
                        
                      }).show()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.reviewList.count
        
        // 0 개이면 0개라고 표시할만한 cell이 있어야 할듯
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //리뷰 이미지에 대한 정보가 존재한다면 일반 reviewCell
        if viewModel.reviewList[indexPath.row].reviewImageFileFolder != nil {
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
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
        
        // 리뷰 이미지가 아예 없으면 reviewCellWithoutReviewImages
        else {
            
            guard let reviewCellNoImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
            
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
        
        viewModel.selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.SegueIdentifier.goSeeDetailReview, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? ReviewDetailViewController else { return }
        guard let cell = tableView.cellForRow(at: viewModel.selectedIndex!) as? ReviewTableViewCell else { return }
        
        let reviewDetails = cell.getReviewDetails()
        
        vc.configure(with: reviewDetails)
    }
}

//MARK: - ReviewTableViewCellDelegate

extension ExampleViewController: ReviewTableViewCellDelegate {
    
    func presentDeleteActionAlert(reviewID: Int) {
        //
    }
    
    
    func goToReportReviewVC(reviewID: Int, displayName: String) {
    
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

//MARK: - UIScrollViewDelegate

extension ExampleViewController: UIScrollViewDelegate {
    
    func createSpinnerFooter() -> UIView {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
   
        if position > (tableView.contentSize.height - 80 - scrollView.frame.size.height) {
        
            if !viewModel.isFetchingData {
                tableView.tableFooterView = createSpinnerFooter()
                viewModel.fetchReviewList()
            }
        }
    }
}
