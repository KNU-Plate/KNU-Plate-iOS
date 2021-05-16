import UIKit
import Kingfisher

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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel.reviewImages.removeAll()
    }
    
    func configure(with model: ReviewListResponseModel) {
        
        viewModel.userID = model.userID
        viewModel.userNickname = model.userInfo.displayName
        viewModel.medal = model.userInfo.medal ?? 3
        viewModel.review = model.review
        viewModel.rating = model.rating
        
        if let fileFolderID = model.userInfo.userProfileImage?[0].path {
            viewModel.userProfileImageURLInString = fileFolderID
        }
        if let fileFolderID = model.reviewImageFileInfo {
            viewModel.reviewImagesFolder = fileFolderID
        }
        
        initialize()
    }
    
    func initialize() {
        
        initializeCellUIComponents()
        configureUI()
        configureShowMoreButton()
    }
    
    func initializeCellUIComponents() {
        
        userMedalImageView.image = setUserMedalImage(medalRank: viewModel.medal)
        reviewLabel.text = viewModel.review
        rating.setStarsRating(rating: viewModel.rating)
        userNicknameLabel.text = viewModel.userNickname
         
        if let profileImageURL = viewModel.userProfileImageURL {
            userProfileImageView.kf.setImage(with: profileImageURL)
            userProfileImageView.image = viewModel.userProfileImage
        }
        if !viewModel.reviewImages.isEmpty {
            reviewImageView.image = viewModel.reviewImages[0]
            configurePageControl()
        }
    
    }
    
    func configurePageControl() {
        
        reviewImageView.isUserInteractionEnabled = true

        pageControl.numberOfPages = viewModel.reviewImages.count
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        

        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left


        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right

        self.reviewImageView.addGestureRecognizer(swipeLeft)
        self.reviewImageView.addGestureRecognizer(swipeRight)
    }
    
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.layer.borderWidth = 1
        userProfileImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    func configureShowMoreButton() {
        showMoreButton.addTarget(self,
                                 action: #selector(showMoreOptions),
                                 for: .touchUpInside)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {

            case UISwipeGestureRecognizer.Direction.left :
                pageControl.currentPage += 1
                reviewImageView.image = viewModel.reviewImages[pageControl.currentPage]
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                reviewImageView.image = viewModel.reviewImages[pageControl.currentPage]
            default:
                break
            }
        }
    }
    
    @objc func showMoreOptions() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let reportUser = UIAlertAction(title: "사용자 신고하기",
                                       style: .default) { alert in
            
            let userIDToReport = self.viewModel.userID
        
            
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
    
    func getReviewDetails() -> ReviewDetail {
        
        let profileImage = viewModel.userProfileImage
        let nickname = viewModel.userNickname
        let medal = viewModel.medal
        let rating = viewModel.rating
        let review = viewModel.review
        
        let reviewImages: [UIImage]?
        
        if !viewModel.reviewImages.isEmpty {
            reviewImages = viewModel.reviewImages
        } else { reviewImages = nil }
      
        let reviewDetails = ReviewDetail(profileImage: profileImage,
                                         nickname: nickname,
                                         medal: medal,
                                         reviewImages: reviewImages,
                                         rating: rating,
                                         review: review)
        return reviewDetails
    }
    
    
}
