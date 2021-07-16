import UIKit
import SDWebImage
import Alamofire
import SnackBar_swift

protocol ReviewTableViewCellDelegate {
    func goToReportReviewVC(reviewID: Int?, displayName: String?)
    func presentDeleteActionAlert(reviewID: Int)
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

    var delegate: ReviewTableViewCellDelegate?
    
    var reviewID: Int?
    var userNickname: String?
    
    func configureUI(reviewImageCount: Int?) {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        
        reviewImageView?.layer.cornerRadius = 10
        
        guard let imageCount = reviewImageCount else {
            return
        }
        
        if imageCount >= 2 {
            multipleImageView.image = UIImage(named: Constants.Images.multipleImageExistsIcon)
        } else {
            multipleImageView.image = nil
        }
    }

    func configureShowMoreButton() {
        showMoreButton.addTarget(self,
                                 action: #selector(showMoreOptions),
                                 for: .touchUpInside)
    }
    
    // 더보기 버튼
//    @objc func showMoreOptions() {
//
//        let actionSheet = UIAlertController(title: nil,
//                                            message: nil,
//                                            preferredStyle: .actionSheet)
//
//        let reportReview = UIAlertAction(title: "게시글 신고하기",
//                                         style: .default) { alert in
//
//            self.delegate?.goToReportReviewVC(reviewID: self.viewModel.reviewID,
//                                              displayName: self.viewModel.userNickname)
//        }
//
//        let cancelAction = UIAlertAction(title: "취소",
//                                         style: .cancel,
//                                         handler: nil)
//        actionSheet.addAction(reportReview)
//        actionSheet.addAction(cancelAction)
//
//        let vc = self.window?.rootViewController
//        vc?.present(actionSheet, animated: true)
//    }
    
    @objc func showMoreOptions() {
        
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
    
//    // ReviewDetailVC 로 넘아갈때 필요한 정보 전달용 함수
//    func getReviewDetails() -> ReviewDetail {
//
//        let profileImage = userProfileImageView.image ?? UIImage(named: Constants.Images.defaultProfileImage)!
//        let nickname = viewModel.userNickname
//        let medal = viewModel.medal
//        let rating = viewModel.rating
//        let review = viewModel.review
//        let reviewImageFiles = viewModel.reviewImagesFileFolder?.files
//
//        let reviewDetails = ReviewDetail(profileImage: profileImage,
//                                         nickname: nickname,
//                                         medal: medal,
//                                         reviewImageFiles: reviewImageFiles,
//                                         rating: rating,
//                                         review: review)
//        return reviewDetails
//    }
}

