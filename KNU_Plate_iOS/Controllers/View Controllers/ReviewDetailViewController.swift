import UIKit


class ReviewDetailViewController: UIViewController {
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMedalImageView: UIImageView!
    @IBOutlet var reviewImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var rating: RatingController!
    @IBOutlet var reviewTextView: UITextView!
    
    
    var reviewDetails = ReviewDetail()
    var reviewImages: [UIImage] = []
    
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
        reviewDetails.reviewImagesFileInfo = model.reviewImagesFileInfo
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
        
        // 다운 가능한 리뷰 이미지를 하나하나 다운 받는 과정
        
        OperationQueue().addOperation {
            
            if let fileFolder = self.reviewDetails.reviewImagesFileInfo {
                
                for eachImageInfo in fileFolder {
                    let downloadURL = URL(string: eachImageInfo.path)
                    let imageData = try! Data(contentsOf: downloadURL!)
                    DispatchQueue.main.async {
                        self.reviewImages.append(UIImage(data: imageData)!)
                    }
                }
                DispatchQueue.main.async {
                    self.configurePageControl(reviewImageExists: true)
                }
                
            } else {
                DispatchQueue.main.async {
                    self.configurePageControl(reviewImageExists: false)
                }
            }
        }

        configureUI()
    }
    
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.layer.borderWidth = 1
        userProfileImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        reviewImageView.layer.cornerRadius = 10
        

        
        
        
        
    }
    
    func configurePageControl(reviewImageExists: Bool) {
        
        // 리뷰 이미지가 없으면
        if !reviewImageExists {
            reviewImageView.image = UIImage(named: "default review image")!
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
