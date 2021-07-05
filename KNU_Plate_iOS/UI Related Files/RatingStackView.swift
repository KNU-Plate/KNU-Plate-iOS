import UIKit
import Then
import SnapKit

/// Shows stars rating using ImageView
class RatingStackView: UIStackView {
    let starImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        $0.image = UIImage(named: "star rating (unfilled)")
    }
    
    let averageRatingLabel = UILabel()
    
    var averageRating: Double = 0.0 {
        didSet {
            averageRatingLabel.text = String(averageRating)
            if averageRating != 0.0 {
                starImage.image = UIImage(named: "star rating (filled)")
            } else {
                starImage.image = UIImage(named: "star rating (unfilled)")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        self.addArrangedSubview(starImage)
        self.addArrangedSubview(averageRatingLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
