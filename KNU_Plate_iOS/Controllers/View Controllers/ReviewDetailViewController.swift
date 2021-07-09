import UIKit
import SDWebImage
import ImageSlideshow

class ReviewDetailViewController: UIViewController {
    
    
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMedalImageView: UIImageView!
    @IBOutlet var reviewImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var rating: RatingController!
    @IBOutlet var reviewTextView: UITextView!
    
    var reviewDetails = ReviewDetail()
    var reviewImageFiles = [Files]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    // 객체 생성 전 초기화
    func configure(with model: ReviewDetail) {
        
        reviewDetails.profileImage = model.profileImage
        reviewDetails.nickname = model.nickname
        reviewDetails.medal = model.medal
        reviewDetails.rating = model.rating
        reviewDetails.review = model.review
        reviewDetails.reviewImageFiles = model.reviewImageFiles
    }
    
    // Review Cell
    func initialize() {
         
        userProfileImageView.image = reviewDetails.profileImage
        userNicknameLabel.text = reviewDetails.nickname
        userMedalImageView.image = setUserMedalImage(medalRank: reviewDetails.medal)
        rating.setStarsRating(rating: Int(exactly: reviewDetails.rating)!)
        
        
        let textViewStyle = NSMutableParagraphStyle()
        textViewStyle.lineSpacing = 3
        let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
        reviewTextView.attributedText = NSAttributedString(string: reviewDetails.review, attributes: attributes)
        reviewTextView.font = UIFont.systemFont(ofSize: 14.5)
        
        
        if let files = reviewDetails.reviewImageFiles {
        
            self.reviewImageFiles = files
            configurePageControl(reviewImageExists: true)
        } else {
            configurePageControl(reviewImageExists: false)
        }

        configureUI()
    }
    
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        reviewImageView.layer.cornerRadius = 10
    }
    
    func configurePageControl(reviewImageExists: Bool) {
        
        // 리뷰 이미지가 없으면
        if !reviewImageExists {
            reviewImageView.image = UIImage(named: Constants.Images.defaultReviewImage)
            return
        }
        
        // 리뷰 이미지가 1개 밖에 없을 때
        if reviewImageFiles.count == 1 {
            pageControl.isHidden = true
            reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            reviewImageView.sd_setImage(with: URL(string: reviewImageFiles[0].path),
                                        placeholderImage: nil,
                                        options: .continueInBackground,
                                        completed: nil)
            return
        }
        
        // 리뷰 이미지가 2개 이상일 때
        reviewImageView.isUserInteractionEnabled = true
        
        pageControl.numberOfPages = reviewImageFiles.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        
        reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        reviewImageView.sd_setImage(with: URL(string: reviewImageFiles[0].path),
                                    placeholderImage: nil,
                                    options: .continueInBackground,
                                    completed: nil)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(self.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(self.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        
        self.reviewImageView.addGestureRecognizer(swipeLeft)
        self.reviewImageView.addGestureRecognizer(swipeRight)
    }

    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left :
                pageControl.currentPage += 1
                reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                reviewImageView.sd_setImage(with: URL(string: reviewImageFiles[pageControl.currentPage].path),
                                            placeholderImage: nil,
                                            options: .continueInBackground,
                                            completed: nil)
                
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                reviewImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                reviewImageView.sd_setImage(with: URL(string: reviewImageFiles[pageControl.currentPage].path),
                                            placeholderImage: nil,
                                            options: .continueInBackground,
                                            completed: nil)
            default:
                break
            }
        }
    }

}
