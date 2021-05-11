import UIKit

class ReviewDetailViewController: UIViewController {
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMedalImageView: UIImageView!
    @IBOutlet var reviewImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var rating: RatingController!
    @IBOutlet var reviewLabel: UILabel!
    
    var reviewDetails: ReviewDetail?
    var reviewImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let reviewDetail = reviewDetails {
            initialize(with: reviewDetail)
        } else { return }
    }
    
    func initialize(with model: ReviewDetail) {
        
        userProfileImageView.image = model.profileImage
        userNicknameLabel.text = model.nickname
        userMedalImageView.image = model.medal
        rating.setStarsRating(rating: Int(exactly: model.rating)!)
        reviewLabel.text = model.review
        
        if let images = model.reviewImages {
            reviewImages.append(contentsOf: images)
            configurePageControl(reviewImageExists: true)
        } else {
            configurePageControl(reviewImageExists: false)
        }
    }
    
    func configurePageControl(reviewImageExists: Bool) {
        
        if !reviewImageExists {
            reviewImageView.image = nil
            return
        }
        
        reviewImageView.isUserInteractionEnabled = true
        
        pageControl.numberOfPages = reviewImages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        
        reviewImageView.image = reviewImages[0]
        
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
                reviewImageView.image = reviewImages[pageControl.currentPage]
                
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                reviewImageView.image = reviewImages[pageControl.currentPage]
            default:
                break
            }
        }
    }

}
