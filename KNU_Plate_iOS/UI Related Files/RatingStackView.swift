import UIKit

/// Shows stars rating using ImageView
class RatingStackView: UIStackView {
    var starImages: [UIImageView] = []
    let starPicName = "star rating (filled)"            // Filled star name
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor(named: Constants.Color.appDefaultColor)
            self.addArrangedSubview(imageView)
            self.starImages.append(imageView)
        }
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Set starts rating
    func setStarsRating(rating: Int){
        for i in 0..<5 {
            if i+1 <= rating {
                starImages[i].image = UIImage(named: starPicName)
            }
        }
    }
}
