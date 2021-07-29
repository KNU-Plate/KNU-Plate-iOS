import UIKit
import Then
import SnapKit

/// Shows stars rating using ImageView
class RatingView: UIView {
    let starImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        $0.image = UIImage(named: Constants.Images.starsUnfilled)
    }
    
    let averageRatingLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    var averageRating: Double = 0.0 {
        didSet {
            averageRatingLabel.text = String(format: "%.1f", averageRating)
            if averageRating != 0.0 {
                starImage.image = UIImage(named: Constants.Images.starsFilled)
            } else {
                starImage.image = UIImage(named: Constants.Images.starsUnfilled)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(starImage)
        self.addSubview(averageRatingLabel)
        starImage.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        averageRatingLabel.snp.makeConstraints { make in
            make.left.equalTo(starImage.snp.right)
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(30).priority(.low)
            make.height.equalTo(20)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
