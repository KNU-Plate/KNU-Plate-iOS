import UIKit
import ProgressHUD

class ExampleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private var viewModel = ReviewListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Test.shared.login()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let reviewNib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        let cellID = Constants.CellIdentifier.reviewTableViewCell
        let reviewWithoutImageNib = UINib(nibName: "ReviewWithoutImageTableViewCell", bundle: nil)
        let cellID2 = Constants.CellIdentifier.reviewWithoutImageTableViewCell
        tableView.register(reviewNib, forCellReuseIdentifier: cellID)
        tableView.register(reviewWithoutImageNib, forCellReuseIdentifier: cellID2)
        
        viewModel.delegate = self
    }
    
    @IBAction func pressedButton(_ sender: UIButton) {
        
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.colorAnimation = UIColor(named: Constants.Color.appDefaultColor) ?? .systemGray
        ProgressHUD.show()
        

        //TODO: - dynamic 하게 변경할 필요 있음
        viewModel.fetchReviewList(of: 2)
    }
    

}

extension ExampleViewController: ReviewListViewModelDelegate {
    
    func didFetchReviewListResults() {
        
        tableView.reloadData()
        ProgressHUD.dismiss()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let reviewLists = viewModel.reviewList else { return UITableViewCell() }

        //리뷰 이미지에 대한 정보가 존재한다면 일반 reviewCell
        if reviewLists[indexPath.row].reviewImageFileInfo != nil {
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
            reviewCell.configure(with: reviewLists[indexPath.row])
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
