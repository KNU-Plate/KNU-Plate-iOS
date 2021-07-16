import UIKit

//MARK: - 매장에 등록된 개별적인 리뷰를 위한 TableViewCell -> 단, 리뷰용 사진이 없을 때만 사용

class ReviewWithoutImageTableViewCell: ReviewTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureUI() {
    
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        reviewImageView?.layer.cornerRadius = 10
    }
    
    @objc override func showMoreOptions() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        print("✏️ viewModel.usernickname: \(viewModel.userNickname)")
        print("✏️ user.shared.displayname: \(User.shared.displayName)")
        
        if viewModel.userNickname == User.shared.displayName {
            
            let deleteAction = UIAlertAction(title: "리뷰 삭제하기",
                                             style: .destructive) { onPress in
                
                self.delegate?.presentDeleteActionAlert(reviewID: self.viewModel.reviewID)
            }
            actionSheet.addAction(deleteAction)
        }
        else {
            let reportAction = UIAlertAction(title: "게시글 신고하기",
                                             style: .default) { onPress in
                self.delegate?.goToReportReviewVC(reviewID: self.viewModel.reviewID,
                                                  displayName: self.viewModel.userNickname)
            }
            actionSheet.addAction(reportAction)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
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
}

