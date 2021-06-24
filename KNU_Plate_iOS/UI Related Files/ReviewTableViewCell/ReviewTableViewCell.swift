import UIKit
import SDWebImage
import Alamofire
import SnackBar_swift

protocol ReviewTableViewCellDelegate {
    func goToReportReviewVC(reviewID: Int)
}

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
    
    @IBOutlet var multipleImageView: UIImageView!
    
    private var viewModel = ReviewTableViewModel()

    var delegate: ReviewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetValues()
    }

    func resetValues() {
        
        userProfileImageView.image = nil
        userNicknameLabel.text?.removeAll()
        userMedalImageView.image = nil
        rating.setStarsRating(rating: 3)
        reviewLabel.text?.removeAll()
        
        viewModel.resetValues()
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
        if let profileImagePath = model.userInfo.fileFolder?.files?[0].path {
            viewModel.userProfileImagePath = profileImagePath
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
  
    }
    
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        
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
        let reportReview = UIAlertAction(title: "게시글 신고하기",
                                         style: .default) { alert in
            
            self.delegate?.goToReportReviewVC(reviewID: self.viewModel.reviewID)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(reportReview)
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
        let reviewImageFiles = viewModel.reviewImagesFileFolder?.files
      
        let reviewDetails = ReviewDetail(profileImage: profileImage,
                                         nickname: nickname,
                                         medal: medal,
                                         reviewImageFiles: reviewImageFiles,
                                         rating: rating,
                                         review: review)
        return reviewDetails
    }
    
    func getReviewImageDownloadURL() -> URL? {
        
        let path = viewModel.reviewImagesFileFolder?.files?[0].path
        
        if let path = path {
            if let url = URL(string: path) {
                return url
            }
        }
        return nil
    }
    
    func getProfileImageDownloadURL() -> URL? {
        
        guard let path = viewModel.userProfileImagePath else {
            return nil
        }
        guard let url = URL(string: path) else {
            return nil
        }
        return url
        
    }
    
}

