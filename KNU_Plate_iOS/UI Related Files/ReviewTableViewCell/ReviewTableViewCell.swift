import UIKit

//MARK: - 매장에 등록된 개별적인 리뷰를 위한 TableViewCell

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var userProfileImageView: ProfileImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMedalImageView: UIImageView!
    @IBOutlet var showMoreButton: UIButton!
    @IBOutlet var reviewImageView: ReviewImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var rating: RatingController!
    @IBOutlet var reviewLabel: UILabel!
    
    @IBOutlet var multipleImageView: ReviewImageView!
    
    private var viewModel = ReviewTableViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func resetValues() {
        userProfileImageView.image = nil
        userNicknameLabel.text = nil
        userMedalImageView.image = nil
        rating.setStarsRating(rating: 3)
        reviewLabel.text = nil
        //multipleImageView.image = nil
    }
    
    func configure(with model: ReviewListResponseModel) {
        
        //Reset Every Content-Related attributes
        resetValues()

        // Configure View Model
        viewModel.reviewID = model.reviewID
        viewModel.userID = model.userID
        viewModel.userNickname = model.userInfo.displayName
        viewModel.medal = model.userInfo.medal ?? 3
        viewModel.review = model.review
        viewModel.rating = model.rating
        
        // Check if a user profile image exists
        if let fileFolderID = model.userInfo.userProfileImageFolderID {
            viewModel.userProfileImageFolderID = fileFolderID
        }
        // Check if review images exists
        if let fileFolder = model.reviewImageFileFolder {
            viewModel.reviewImagesFileFolder = fileFolder
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
        rating.setStarsRating(rating: viewModel.rating)
        userNicknameLabel.text = viewModel.userNickname
        reviewLabel.text = viewModel.review
        
        let textViewStyle = NSMutableParagraphStyle()
        textViewStyle.lineSpacing = 2
        let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
        reviewLabel.attributedText = NSAttributedString(string: viewModel.review, attributes: attributes)
        reviewLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        if let profileImageURL = viewModel.userProfileImageURL {
            userProfileImageView.loadImage(from: profileImageURL)
        } else {
            userProfileImageView.image = UIImage(named: "default profile image")
        }
        
        // 리뷰 이미지 배열의 첫 번째 이미지 가져오기
        guard let path = viewModel.reviewImagesFileFolder?.files?[0].path else { return }
        
        if let downloadURL = URL(string: path) {
            reviewImageView.loadImage(from: downloadURL)
        }
  
    }
    
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.layer.borderWidth = 1
        userProfileImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        reviewImageView?.layer.cornerRadius = 10
        
        guard let imageCount = viewModel.reviewImagesFileFolder?.files?.count else {
            return
        }
        
        if imageCount >= 2 {
            multipleImageView.image = UIImage(named: "multiple images")
        } else {
            multipleImageView.image = nil
        }
        
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
        
        let profileImage = userProfileImageView.image ?? UIImage(named: "default profile image")!
        let nickname = viewModel.userNickname
        let medal = viewModel.medal
        let rating = viewModel.rating
        let review = viewModel.review
        let reviewImagesFileInfo = viewModel.reviewImagesFileFolder
      
        let reviewDetails = ReviewDetail(profileImage: profileImage,
                                         nickname: nickname,
                                         medal: medal,
                                         reviewImagesFileFolder: reviewImagesFileInfo,
                                         rating: rating,
                                         review: review)
        return reviewDetails
    }
    
    
}
