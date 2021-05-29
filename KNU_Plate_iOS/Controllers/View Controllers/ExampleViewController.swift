import UIKit
import ProgressHUD
import Alamofire

class ExampleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var viewModel = ReviewListViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Test.shared.login()

        
        

        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        let reviewNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        let cellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewWithoutImageNib = UINib(nibName: "ReviewWithoutImageTableViewCell", bundle: nil)
        let cellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        tableView.register(reviewNib, forCellReuseIdentifier: cellID)
        tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: cellID2)
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        viewModel.delegate = self
        viewModel.reviewList.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            
            self.viewModel.fetchReviewList(of: 3)
            
        }
        
    }
    
    
    @objc func refreshTable() {
        viewModel.reviewList.removeAll()
        viewModel.needToFetchMoreData = true
        viewModel.isPaginating = false
        viewModel.fetchReviewList(of: 3)
    }
}

//MARK: - ReviewListViewModelDelegate

extension ExampleViewController: ReviewListViewModelDelegate {
    
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
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.reviewList.count
        
        // 0 개이면 0개라고 표시할만한 cell이 있어야 할듯
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reviewLists = viewModel.reviewList

        //리뷰 이미지에 대한 정보가 존재한다면 일반 reviewCell
        if reviewLists[indexPath.row].reviewImageFileFolder != nil {
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
            reviewCell.configure(with: reviewLists[indexPath.row])
            
//            let path = (reviewLists[indexPath.row].reviewImageFileFolder?.files?[0].path)!
//            
//            let url = URL(string: path)!
//
//            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
//
//                reviewCell.reviewImageView.image = cachedImage
//            }
//
//            else {
//
//                DispatchQueue.global(qos: .background).async {
//
//
//                    if let data = try? Data(contentsOf: url) {
//                        let image = UIImage(data: data)!
//
//                        DispatchQueue.main.async {
//
//                            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
//                            reviewCell.reviewImageView.image = image
//                        }
//
//                    }
//                }
//
//
//
//            }
//
//
            
            
            
            
            
            
            
            
            
            
            
            return reviewCell

        // 리뷰 이미지가 아예 없으면 reviewCellWithoutReviewImages
        } else {
            
            guard let reviewCellWithoutReviewImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
            
            reviewCellWithoutReviewImages.configure(with: reviewLists[indexPath.row])
            return reviewCellWithoutReviewImages
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
   
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            
            guard !viewModel.isPaginating else { return }
            
            if viewModel.needToFetchMoreData {
                tableView.tableFooterView = createSpinnerFooter()
                let indexToFetch = viewModel.reviewList.count
                viewModel.fetchReviewList(pagination: true, of: 3, at: indexToFetch)
                tableView.tableFooterView = nil
            } else { return }
        }
    }
}
