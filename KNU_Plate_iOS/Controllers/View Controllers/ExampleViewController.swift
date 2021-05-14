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
        
        ProgressHUD.animationType = .multipleCirclePulse
        ProgressHUD.show("데이터 가져오는 중..")
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
        
        if indexPath.row < 4 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else {
                fatalError("Failed to dequeue cell for ReviewTableViewCell")
            }
            
            if let reviewLists = viewModel.reviewList {
                
                cell.configure(with: reviewLists[indexPath.row])
            } else { print("REVIEW LIST IS EMPTY") }
            
            
    
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else {
                fatalError()
            }
            cell.reviewLabel.text = "시험시험시험"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goSeeDetailReview", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let vc = segue.destination as? ReviewDetailViewController else { return }
        guard let indexSelected = tableView.indexPathForSelectedRow else { return }
        guard let cell = tableView.cellForRow(at: indexSelected) as? ReviewTableViewCell else { return }
        
        
        let reviewDetails = cell.getReviewDetails()

        vc.configure(with: reviewDetails)


    }

}
