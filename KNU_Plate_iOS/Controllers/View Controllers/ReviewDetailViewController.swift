import UIKit
import SDWebImage
import ImageSlideshow

class ReviewDetailViewController: UIViewController {
    
    @IBOutlet var slideShow: ImageSlideshow!
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userMedalImageView: UIImageView!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var rating: RatingController!
    
    var reviewDetails = ReviewDetail()
    
    private var reviewImageFiles = [Files]()
    private var imageSources = [InputSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    // 객체 생성 전 초기화
    func configure(with model: ReviewDetail) {
        
        reviewDetails = model
        
//        reviewDetails.profileImageURL = model.profileImageURL
//        reviewDetails.nickname = model.nickname
//        reviewDetails.medal = model.medal
//        reviewDetails.rating = model.rating
//        reviewDetails.review = model.review
//        reviewDetails.reviewImageFiles = model.reviewImageFiles
     
    }
    
    // Review Cell
    func initialize() {
         
        userProfileImageView.sd_setImage(with: reviewDetails.profileImageURL,
                                         placeholderImage: UIImage(named: Constants.Images.defaultProfileImage))
        userNicknameLabel.text = reviewDetails.nickname
        userMedalImageView.image = setUserMedalImage(medalRank: reviewDetails.medal)
        rating.setStarsRating(rating: Int(exactly: reviewDetails.rating)!)
        dateLabel.text = reviewDetails.date
        
        let textViewStyle = NSMutableParagraphStyle()
        textViewStyle.lineSpacing = 3
        let attributes = [NSAttributedString.Key.paragraphStyle : textViewStyle]
        reviewLabel.attributedText = NSAttributedString(string: reviewDetails.review, attributes: attributes)
        reviewLabel.font = UIFont.systemFont(ofSize: 14.5)
        
        
        if let files = reviewDetails.reviewImageFiles {
        
            self.reviewImageFiles = files
            convertURLsToImageSource()
            configureImageSlideShow(imageExists: true)
            
        } else {
            configureImageSlideShow(imageExists: false)
        }

        configureUI()
    }
    
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        slideShow.layer.cornerRadius = 10
    }
    
    func convertURLsToImageSource() {
        
        imageSources.removeAll()
        
        for file in reviewImageFiles {
            
            do {
                let url = try file.path.asURL()
                imageSources.append(SDWebImageSource(url: url,
                                                     placeholder: UIImage(named: Constants.Images.defaultReviewImage)))
            } catch {
                print("❗️ ReviewDetailVC - URL Conversion Error")
            }
        }
    }

}

//MARK: - Image Slide Show

extension ReviewDetailViewController {
    
    func configureImageSlideShow(imageExists: Bool) {
        
        if imageExists {
            
            slideShow.setImageInputs(self.imageSources)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.pressedImage))
            slideShow.addGestureRecognizer(recognizer)
        } else {
            slideShow.setImageInputs([ImageSource(image: UIImage(named: Constants.Images.defaultReviewImage)!)])
        }
        
        slideShow.contentScaleMode = .scaleAspectFill
        slideShow.slideshowInterval = 5
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
    }
    
    @objc func pressedImage() {
        
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }}
