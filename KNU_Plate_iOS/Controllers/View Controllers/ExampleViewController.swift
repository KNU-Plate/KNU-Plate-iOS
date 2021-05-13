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
            } else {
                print("REVIEW LIST IS EMPTY")
            }
            
            
    
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else {
                fatalError("Failed to dequeue cell for ReviewWithoutImageTableViewCell")
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
       
        guard let vc = segue.destination as? ReviewDetailViewController else {
            return
        }

//        guard let cell = sender as? ReviewTableViewCell else {
//            return
//        }

        
        let profileImage = UIImage(named: "default profile image")!
        let nickname = "kevinkim"
        let medal = UIImage(named: "first medal")!
        let rating = 5
        let review = "완전 맛있었어요! 사장님도 친절하시구 ㅎㅎ"

        var reviewImages: [UIImage] = []
        reviewImages.append(UIImage(named: "american food")!)
        reviewImages.append(UIImage(named: "beer")!)

        let reviewDetails = ReviewDetail(profileImage: profileImage, nickname: nickname, medal: medal, reviewImages: reviewImages, rating: rating, review: review)

        vc.configure(with: reviewDetails)


    }

}
