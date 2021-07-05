import UIKit

//MARK: - 매장에 등록된 개별적인 리뷰를 위한 TableViewCell -> 단, 리뷰용 사진이 없을 때만 사용

class ReviewWithoutImageTableViewCell: ReviewTableViewCell {
    
    private var viewModel = ReviewTableViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel.resetValues()
    }

    override func configure(with model: ReviewListResponseModel) {
    
        // Configure View Model
        viewModel.reviewID = model.reviewID
        viewModel.userID = model.userID
        viewModel.userNickname = model.userInfo.displayName
        viewModel.medal = model.userInfo.medal
        viewModel.review = model.review
        viewModel.rating = model.rating
       
        // Check if a user profile image exists
        
        if let profileImagePath = model.userInfo.fileFolder?.files?[0].path {
            
            viewModel.userProfileImagePath = profileImagePath
        }
        initialize()
    }
    
    override func configureUI() {
    
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        reviewImageView?.layer.cornerRadius = 10
    }
    
    override func initializeCellUIComponents() {
        
        userMedalImageView.image = setUserMedalImage(medalRank: viewModel.medal)
        rating.setStarsRating(rating: viewModel.rating)
        userNicknameLabel.text = viewModel.userNickname
        
         
        let textViewStyle = NSMutableParagraphStyle()
        textViewStyle.lineSpacing = 2
        let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
        reviewLabel.attributedText = NSAttributedString(string: viewModel.review,
                                                        attributes: attributes)
        reviewLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    
    @objc override func showMoreOptions() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let reportReview = UIAlertAction(title: "게시글 신고하기",
                                         style: .default) { alert in
            
            self.delegate?.goToReportReviewVC(reviewID: self.viewModel.reviewID,
                                              displayName: self.viewModel.userNickname)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(reportReview)
        actionSheet.addAction(cancelAction)
        
        let vc = self.window?.rootViewController
        vc?.present(actionSheet, animated: true)
    }
    
    
    
    override func getReviewDetails() -> ReviewDetail {

        let profileImage = userProfileImageView.image ?? UIImage(named: Constants.Images.defaultProfileImage)!
        let nickname = viewModel.userNickname
        let medal = viewModel.medal
        let rating = viewModel.rating
        let review = viewModel.review

        let reviewDetails = ReviewDetail(profileImage: profileImage,
                                         nickname: nickname,
                                         medal: medal,
                                         reviewImageFiles: nil,
                                         rating: rating,
                                         review: review)
        return reviewDetails

    }
    
    override func getProfileImageDownloadURL() -> URL? {

        guard let path = viewModel.userProfileImagePath else {
            return nil
        }
        guard let url = URL(string: path) else {
            return nil
        }
        return url

    }

}

