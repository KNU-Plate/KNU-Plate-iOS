import UIKit

//MARK: - 매장에 등록된 개별적인 리뷰를 위한 TableViewCell

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMedalImageView: UIImageView!
    @IBOutlet var showMoreButton: UIButton!
    @IBOutlet var reviewImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var rating: RatingController!
    @IBOutlet var reviewLabel: UILabel!
    
    private var viewModel = ReviewTableViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
 

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: ReviewListResponseModel) {
        
        viewModel.userID = model.userID
        viewModel.review = model.review
        viewModel.rating = model.rating
        
        if let reviewImageData = model.reviewImages {
            for eachImage in reviewImageData {
                viewModel.reviewImages?.append(UIImage(data: eachImage)!)
            }
        } else {
            print("ReviewTableViewCell - No review images available")
        }
        
        initialize()
    }
    
    func initialize() {
        
        configurePageControl()
        configureShowMoreButton()
    }
    
    func configureShowMoreButton() {
        showMoreButton.addTarget(self,
                                 action: #selector(showMoreOptions),
                                 for: .touchUpInside)
    }
    
    @objc func showMoreOptions() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let reportUser = UIAlertAction(title: "사용자 신고하기",
                                       style: .default) { alert in
            
            // 신고하기 action 을 여기서 취해야함
            //UserManager.shared.report(userID: viewModel.userID) 이런 식으로 해야할듯
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)                            
        actionSheet.addAction(reportUser)
        actionSheet.addAction(cancelAction)
        
        let vc = self.window?.rootViewController
        vc?.present(actionSheet, animated: true)
    }
    
    func configurePageControl() {
        
        reviewImageView.isUserInteractionEnabled = true

        pageControl.numberOfPages = viewModel.reviewImages!.count
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        
        reviewImageView.image = viewModel.reviewImages![0]

        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left


        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        self.reviewImageView.addGestureRecognizer(swipeLeft)
        self.reviewImageView.addGestureRecognizer(swipeRight)
        
        
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {

            case UISwipeGestureRecognizer.Direction.left :
                pageControl.currentPage += 1
                reviewImageView.image = viewModel.reviewImages![pageControl.currentPage]
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                reviewImageView.image = viewModel.reviewImages![pageControl.currentPage]
            default:
                break
            }
        }
    }
    
}
