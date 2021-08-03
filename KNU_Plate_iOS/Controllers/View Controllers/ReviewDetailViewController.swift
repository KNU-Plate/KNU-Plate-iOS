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
    
    
    @IBOutlet var imageViewHeight: NSLayoutConstraint!
    
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
    }
    
    // Review Cell
    func initialize() {
        
        self.title = reviewDetails.nickname + "님의 리뷰"
         
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
            imageViewHeight.constant = 0
            configureImageSlideShow(imageExists: false)
        }

        // 내가 쓴 리뷰면 삭제 UIBarButton 추가하기
        if reviewDetails.userID == User.shared.id {
            
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteReview))
            self.navigationItem.rightBarButtonItem = trashButton
        }
        configureUI()
    }
       
    func configureUI() {
        
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        slideShow.layer.cornerRadius = 5
    }
    
    @objc func deleteReview() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "내 리뷰 삭제하기",
                                         style: .destructive) { alert in
            
            UserManager.shared.deleteMyReview(reviewID: self.reviewDetails.reviewID) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case .failure(let error):
                    self.showSimpleBottomAlert(with: error.errorDescription)
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
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
            slideShow.setImageInputs([ImageSource(image: UIImage(named: Constants.Images.defaultReviewCellPlaceHolder)!)])
        }
        
        slideShow.contentScaleMode = .scaleAspectFill
        slideShow.slideshowInterval = 5
        slideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
    }
    
    @objc func pressedImage() {
        
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }}
