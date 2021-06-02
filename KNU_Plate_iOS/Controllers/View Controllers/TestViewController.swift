import UIKit
import SDWebImage

class TestViewController: UIViewController, ReviewListViewModelDelegate {
    
    
    func didFetchReviewListResults() {
        tableView.reloadData()
        refreshControl.endRefreshing()
        dismissProgressBar()
        tableView.tableFooterView = nil
    }
    
    func didFetchEmptyReviewListResults() {
        tableView.tableFooterView = nil
    }
    
    func failedFetchingReviewListResults() {
        showToast(message: "데이터 가져오기 실패")
    }
    
    private let refreshControl = UIRefreshControl()
    

    @IBOutlet var tableView: UITableView!
    
    private var viewModel = ReviewListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        
        let reviewNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        let cellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewWithoutImageNib = UINib(nibName: "ReviewWithoutImageTableViewCell", bundle: nil)
        let cellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        tableView.register(reviewNib, forCellReuseIdentifier: cellID)
        tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: cellID2)
        
        
        
        
        
        
        tableView.refreshControl = refreshControl
        
        
        viewModel.delegate = self
        viewModel.reviewList.removeAll()
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            
            self.viewModel.fetchReviewList(of: 2)
            
        }
    }
    
    @objc func refreshTable() {
        viewModel.reviewList.removeAll()
        viewModel.needToFetchMoreData = true
        viewModel.isPaginating = false
        viewModel.fetchReviewList(of: 2)
    }
    
    
}

extension TestViewController: UITableViewDataSource, UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewList.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reviewLists = viewModel.reviewList
        
        //리뷰 이미지에 대한 정보가 존재한다면 일반 reviewCell
        if reviewLists[indexPath.row].reviewImageFileFolder != nil {
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
            reviewCell.configure(with: reviewLists[indexPath.row])
            
            let path = reviewLists[indexPath.row].reviewImageFileFolder?.files?[0].path
            if let path = path {
                if let url = URL(string: path) {
                    reviewCell.reviewImageView.sd_setImage(with: url,
                                                           placeholderImage: UIImage(named: "default review image"),
                                                           options: .continueInBackground,
                                                           completed: nil)
                }
            }
            return reviewCell

        // 리뷰 이미지가 아예 없으면 reviewCellWithoutReviewImages
        } else {
            
            guard let reviewCellWithoutReviewImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
            
            reviewCellWithoutReviewImages.configure(with: reviewLists[indexPath.row])
            return reviewCellWithoutReviewImages
        }
        
    
    }
    
    
}


extension TestViewController: UIScrollViewDelegate {
    
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
   
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            guard !viewModel.isPaginating else { return }
            
            if viewModel.needToFetchMoreData {
                tableView.tableFooterView = createSpinnerFooter()
                let indexToFetch = viewModel.reviewList.count
                viewModel.fetchReviewList(pagination: true, of: 2, at: indexToFetch)
                tableView.tableFooterView = nil
            } else { return }
        }
    }
}
