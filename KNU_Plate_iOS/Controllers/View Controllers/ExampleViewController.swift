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
        //tableView.prefetchDataSource = self
        
        
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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let reviewLists = viewModel.reviewList else { return UITableViewCell() }
//
//        guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
//        guard let reviewCellWithoutReviewImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
//
//
//        if reviewCell.alreadyConfigured {
//
//
//
//
//        }
//
//
//
//
//        if reviewLists[indexPath.row].reviewImageFileInfo != nil {
//
//            if reviewCell.alreadyConfigured {
//                return reviewCell
//            } else {
//                reviewCell.userProfileImageView.image = UIImage(named: "default profile image")
//                reviewCell.userNicknameLabel.text = nil
//                reviewCell.userMedalImageView.image = setUserMedalImage(medalRank: 3)
//                reviewCell.reviewLabel.text = nil
//                reviewCell.alreadyConfigured = false
//                reviewCell.reviewImageView.isUserInteractionEnabled = false
//                reviewCell.reviewImageView.image = UIImage(named: "default review image")
//
//                reviewCell.configure(with: reviewLists[indexPath.row])
//                return reviewCell
//            }
//
//        } else {
//
//            if reviewCellWithoutReviewImages.alreadyConfigured {
//                return reviewCellWithoutReviewImages
//            } else {
//                reviewCellWithoutReviewImages.userProfileImageView.image = UIImage(named: "default profile image")
//                reviewCellWithoutReviewImages.userNicknameLabel.text = nil
//                reviewCellWithoutReviewImages.userMedalImageView.image = setUserMedalImage(medalRank: 3)
//                reviewCellWithoutReviewImages.reviewLabel.text = nil
//                reviewCellWithoutReviewImages.alreadyConfigured = false
//
//                reviewCellWithoutReviewImages.configure(with: reviewLists[indexPath.row])
//                return reviewCellWithoutReviewImages
//            }
//
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let reviewLists = viewModel.reviewList else { return UITableViewCell() }

        //리뷰 이미지에 대한 정보가 존재한다면 일반 reviewCell
        if reviewLists[indexPath.row].reviewImageFileInfo != nil {
            
            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
            
            
            reviewCell.reviewLabel.text = reviewLists[indexPath.row].review
            reviewCell.userMedalImageView.image = setUserMedalImage(medalRank: reviewLists[indexPath.row].userInfo.medal ?? 1)
            
    
            if let pathString = reviewLists[indexPath.row].userInfo.userProfileImage?[0].path {
                
                if let url = URL(string: pathString) {
                    reviewCell.userProfileImageView.loadImage(from: url)
                } else {
                    reviewCell.userProfileImageView.image = UIImage(named: "default profile image")
                }
            }
            
            if let pathString = reviewLists[indexPath.row].reviewImageFileInfo?[0].path {
                
                if let url = URL(string: pathString) {
                    reviewCell.reviewImageView.loadImage(from: url)
                }
            }
            

            
            //reviewCell.configure(with: reviewLists[indexPath.row])
            return reviewCell

            
        // 리뷰 이미지가 아예 없으면 reviewCellWithoutReviewImages
        } else {
            
            guard let reviewCellWithoutReviewImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
            
            
            reviewCellWithoutReviewImages.reviewLabel.text = reviewLists[indexPath.row].review
            reviewCellWithoutReviewImages.userMedalImageView.image = setUserMedalImage(medalRank: reviewLists[indexPath.row].userInfo.medal ?? 1)
            
            
            
            if let pathString = reviewLists[indexPath.row].userInfo.userProfileImage?[0].path {
                
                if let url = URL(string: pathString) {
                    reviewCellWithoutReviewImages.userProfileImageView.loadImage(from: url)
                }
            } else {
                reviewCellWithoutReviewImages.userProfileImageView.image = UIImage(named: "default profile image")
            }
            
            
            

            //reviewCellWithoutReviewImages.configure(with: reviewLists[indexPath.row])
            return reviewCellWithoutReviewImages
        }
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.selectedIndex = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.SegueIdentifier.goSeeDetailReview, sender: self)
    }
    
    
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//
//
//        print("--------prefetchrows ACTIVATED----------")
//        print(indexPaths)
//
//
//        for indexPath in indexPaths {
//
//            guard let reviewLists = self.viewModel.reviewList else { return }
//            guard let reviewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewTableViewCell, for: indexPath) as? ReviewTableViewCell else { fatalError() }
//            guard let reviewCellWithoutReviewImages = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.reviewWithoutImageTableViewCell, for: indexPath) as? ReviewWithoutImageTableViewCell else { fatalError() }
//
//            if reviewLists[indexPath.row].reviewImageFileInfo != nil {
//                reviewCell.configure(with: reviewLists[indexPath.row])
//
//            } else {
//                reviewCellWithoutReviewImages.configure(with: reviewLists[indexPath.row])
//            }
//
//        }
//
//
//
//
//
//
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let vc = segue.destination as? ReviewDetailViewController else { return }
        guard let cell = tableView.cellForRow(at: viewModel.selectedIndex!) as? ReviewTableViewCell else { return }
        
        let reviewDetails = cell.getReviewDetails()
        
        vc.configure(with: reviewDetails)
    }

}
