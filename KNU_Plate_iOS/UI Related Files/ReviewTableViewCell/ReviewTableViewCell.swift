import UIKit
import SDWebImage
import Alamofire
import SnackBar_swift

protocol ReviewTableViewCellDelegate: AnyObject {
    func goToReportReviewVC(reviewID: Int?, displayName: String?)
    func presentDeleteActionAlert(reviewID: Int?)
    func didChooseToBlockUser(userID: String, userNickname: String)
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
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var multipleImageView: UIImageView!

    @IBOutlet var reviewImageHeight: NSLayoutConstraint!
    
    weak var delegate: ReviewTableViewCellDelegate?
    
    var reviewID: Int?
    var userNickname: String?
    var userID: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewImageHeight.constant = 240
    }
    
    func configureUI(reviewImageCount: Int?) {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        
        reviewImageView?.layer.cornerRadius = 5
        
        guard let imageCount = reviewImageCount else { return }
        
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
        if self.userID == User.shared.userUID {
            
            let deleteAction = UIAlertAction(title: "내 리뷰 삭제하기",
                                             style: .destructive) { alert in
                self.delegate?.presentDeleteActionAlert(reviewID: self.reviewID)
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
            
            let blockAction = UIAlertAction(title: "이 사용자의 글 보지 않기",
                                            style: .default) { alert in
                
                guard let userID = self.userID ,
                      let nickname = self.userNickname else { return }
                self.delegate?.didChooseToBlockUser(userID: userID, userNickname: nickname)
            }
            
            
            actionSheet.addAction(reportAction)
            actionSheet.addAction(blockAction)
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(cancelAction)
        let vc = self.window?.rootViewController
        vc?.present(actionSheet, animated: true)
    }
}

