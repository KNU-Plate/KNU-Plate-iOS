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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func showMoreOptions() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        let reportUser = UIAlertAction(title: "사용자 신고하기",
                                       style: .default) { alert in
            
            // 신고하기 action 을 여기서 취해야함
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)                            
        actionSheet.addAction(reportUser)
        actionSheet.addAction(cancelAction)
        
        let vc = self.window?.rootViewController
        vc?.present(actionSheet, animated: true)
    }
    
}

//MARK: - Page Control

extension ReviewTableViewCell {
    
    func configurePageControl() {
        
        reviewImageView?.isUserInteractionEnabled = true

//        pageControl.numberOfPages =
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        
//        itemImageView.image = UIImage(named: images[0])
//
//        let swipeLeft = UISwipeGestureRecognizer(target: self,
//                                                 action: #selector(self.respondToSwipeGesture(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
//
//
//        let swipeRight = UISwipeGestureRecognizer(target: self,
//                                                  action: #selector(self.respondToSwipeGesture(_:)))
//        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
//
//        self.itemImageView.addGestureRecognizer(swipeLeft)
//        self.itemImageView.addGestureRecognizer(swipeRight)
        
        
    }
    
//    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
//
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//
//            switch swipeGesture.direction {
//
//            case UISwipeGestureRecognizer.Direction.left :
//                pageControl.currentPage += 1
//                itemImageView.image = UIImage(named: images[pageControl.currentPage])
//
//            case UISwipeGestureRecognizer.Direction.right :
//                pageControl.currentPage -= 1
//                itemImageView.image = UIImage(named: images[pageControl.currentPage])
//            default:
//                break
//            }
//        }
//    }
    
}

//MARK: - UI Configuration

extension ReviewTableViewCell {
    
    func initialize() {
        
        configurePageControl()
        configureShowMoreButton()
        
        
        
    }
    
    func configureShowMoreButton() {
        
        showMoreButton.addTarget(self,
                                 action: #selector(showMoreOptions),
                                 for: .touchUpInside)
    }
}
