import UIKit
import SnapKit

/// Cell of the RestaurantCollectionViewController
class RestaurantCollectionViewCell: UICollectionViewCell {
    //MARK: - Declaration Of Views
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
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
    
    //MARK: - Initialization Of The Cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // make corner round
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 5.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
    }
    
    //MARK: - Basic Set Up For Cell
    /// Add views, autolayout using SnapKit and etc
    func setCell() {
        let inset: CGFloat = 3
        self.backgroundColor = .lightGray
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(ratingStackView)
        
        imageView.backgroundColor = .lightGray
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(self.frame.height*(0.8/Constants.heightPerWidthRestaurantCell))
            make.top.left.right.equalToSuperview().inset(inset)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(inset*2)
            make.left.right.equalToSuperview().inset(inset)
        }
        
        ratingStackView.snp.makeConstraints { (make) in
            make.width.equalTo(self.frame.width/2)
            make.top.equalTo(nameLabel.snp.bottom).offset(inset)
            make.left.bottom.equalToSuperview().inset(inset)
        }
    }
}
