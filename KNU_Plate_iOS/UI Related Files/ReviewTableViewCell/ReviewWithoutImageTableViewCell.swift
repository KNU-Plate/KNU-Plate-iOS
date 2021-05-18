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
    
    override func configure(with model: ReviewListResponseModel) {
        
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
        if let fileFolderID = model.userInfo.userProfileImage?[0].path {
            viewModel.userProfileImageURLInString = fileFolderID
        }
        initialize()
      
    }
    
    override func initializeCellUIComponents() {
        
        userMedalImageView.image = setUserMedalImage(medalRank: viewModel.medal)
        reviewLabel.text = viewModel.review
        rating.setStarsRating(rating: viewModel.rating)
        userNicknameLabel.text = viewModel.userNickname
        
        if let profileImageURL = viewModel.userProfileImageURL {
            userProfileImageView.loadImage(from: profileImageURL)
        } else {
            userProfileImageView.image = UIImage(named: "default profile image")
        }
    }
    
    override func getReviewDetails() -> ReviewDetail {
        
        let profileImage = viewModel.userProfileImage
        let nickname = viewModel.userNickname
        let medal = viewModel.medal
        let rating = viewModel.rating
        let review = viewModel.review
        
        let reviewDetails = ReviewDetail(profileImage: profileImage,
                                         nickname: nickname,
                                         medal: medal,
                                         reviewImagesFileInfo: nil,
                                         rating: rating,
                                         review: review)
        return reviewDetails
        
    }
   
}

