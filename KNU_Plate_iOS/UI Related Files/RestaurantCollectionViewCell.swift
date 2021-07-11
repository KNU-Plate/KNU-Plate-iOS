import UIKit
import SnapKit

/// Cell of the RestaurantCollectionViewController
class RestaurantCollectionViewCell: UICollectionViewCell {
    //MARK: - Declaration Of Views
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let ratingStackView: RatingStackView = {
        let stackView = RatingStackView()
        return stackView
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        button.setImage(UIImage(named: "favorite"), for: .normal)
        button.addBounceReaction()
        return button
    }()
    
    var mallID: Int?
    
    //MARK: - Initialization Of The Cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        makeCornerRound(self)
        makeCornerRound(self.imageView)
        self.imageView.layer.borderWidth = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // make corner round
    func makeCornerRound(_ view: UIView) {
        view.layer.cornerRadius = Constants.Layer.cornerRadius
        view.layer.borderWidth = Constants.Layer.borderWidth
        view.layer.borderColor = Constants.Layer.borderColor
        view.layer.masksToBounds = true
    }
    
    //MARK: - Basic Set Up For Cell
    /// Add views, autolayout using SnapKit and etc
    func setCell() {
        let inset: CGFloat = 3
        let imageViewHeight: CGFloat = self.frame.height*(0.7/Constants.heightPerWidthRestaurantCell)
        let ratingStackViewWidth: CGFloat = self.frame.width*(1/3)
        let nameLabelHeight: CGFloat = (self.frame.height - imageViewHeight)*(2/5)
        
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(ratingStackView)
        self.addSubview(favoriteButton)
        
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(imageViewHeight).labeled("error label: 1")
            make.top.left.right.equalToSuperview().labeled("error label: 2")
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(nameLabelHeight).labeled("error label: 3")
            make.top.equalTo(imageView.snp.bottom).offset(inset*2).labeled("error label: 4")
            make.left.right.equalToSuperview().inset(inset*2).labeled("error label: 5")
        }
        
        ratingStackView.snp.makeConstraints { (make) in
            make.width.equalTo(ratingStackViewWidth).labeled("error label: 6")
            make.top.equalTo(nameLabel.snp.bottom).offset(inset).labeled("error label: 7")
            make.left.equalToSuperview().inset(inset).labeled("error label: 8")
            make.bottom.equalToSuperview().inset(inset*2).labeled("error label: 9")
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.width.equalTo(favoriteButton.snp.height).labeled("error label: 10")
            make.top.equalTo(nameLabel.snp.bottom).offset(inset/2).labeled("error label: 11")
            make.right.equalToSuperview().inset(inset*2).labeled("error label: 12")
            make.bottom.equalToSuperview().inset(inset*2).labeled("error label: 13")
        }
    }
}
