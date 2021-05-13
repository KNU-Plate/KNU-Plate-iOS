import UIKit

class ExampleViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
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

        
        
  
    }
    
    let array = ["괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요","괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요",
                 "괜찮아요괜찮아요괜찮아요괜찮아요"]
    
}


extension ExampleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
  
        if indexPath.row < 4 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else {
                fatalError("Failed to dequeue cell for ReviewTableViewCell")
            }
            cell.reviewImageView.image = UIImage(named: "test1")!
            cell.reviewLabel.text = array[indexPath.row]
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
  
        let model = FetchReviewListModel(mallID: 2, page: 1)
        
        
        RestaurantManager.shared.fetchReviewList(with: model) { responseModel in
            
        
            print("CLOSURE ACTIVATED IN EXAMPLE VIEW CONTROLLER")
        }
        
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
