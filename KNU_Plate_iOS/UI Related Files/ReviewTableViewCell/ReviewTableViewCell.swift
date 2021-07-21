import UIKit
import SDWebImage
import Alamofire
import SnackBar_swift

protocol ReviewTableViewCellDelegate {
    func goToReportReviewVC(reviewID: Int?, displayName: String?)
    func presentDeleteActionAlert(reviewID: Int?)
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
    var userID: String?
    
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
    @objc func showMoreOptions() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        // 현재 리뷰가 내가 쓴 리뷰라면
        if self.userID == User.shared.id {
            
            let deleteAction = UIAlertAction(title: "리뷰 삭제하기",
                                             style: .destructive) { alert in
                self.delegate?.presentDeleteActionAlert(reviewID: self.reviewID!)
            }
            actionSheet.addAction(deleteAction)
        }
        // 남이 쓴 리뷰라면
        else {
            let reportAction = UIAlertAction(title: "게시글 신고하기",
                                             style: .default) { alert in
                
                self.delegate?.goToReportReviewVC(reviewID: self.reviewID,
                                                  displayName: self.userNickname)
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
}

