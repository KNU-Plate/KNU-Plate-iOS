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
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    let countStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    let pencilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "square.and.pencil")
        imageView.tintColor = UIColor.systemGray
        return imageView
    }()
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        return label
    }()
    
    
    let ratingView: RatingView = {
        let ratingView = RatingView()
        return ratingView
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
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.masksToBounds = true
    }
    
    //MARK: - Basic Set Up For Cell
    /// Add views, autolayout using SnapKit and etc
    func setCell() {
        let inset: CGFloat = 3
        let imageViewHeight: CGFloat = self.frame.height*(0.7/Constants.heightPerWidthRestaurantCell)
        let stackViewWidth: CGFloat = self.frame.width*(0.35)
        let nameLabelHeight: CGFloat = (self.frame.height - imageViewHeight)*(2/5)
        
        countStackView.addArrangedSubview(pencilImageView)
        countStackView.addArrangedSubview(countLabel)
        
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(countStackView)
        self.addSubview(ratingView)
        
        imageView.snp.makeConstraints { (make) in
            make.height.equalTo(imageViewHeight)
            make.top.left.right.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(nameLabelHeight)
            make.top.equalTo(imageView.snp.bottom).offset(inset*2)
            make.left.right.equalToSuperview().inset(inset*2)
        }
        
        countStackView.snp.makeConstraints { make in
            make.width.equalTo(stackViewWidth)
            make.top.equalTo(nameLabel.snp.bottom).offset(inset)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().inset(inset*2)
        }
        
        ratingView.snp.makeConstraints { (make) in
            make.centerY.equalTo(countStackView)
            make.right.equalToSuperview().inset(inset)
        }
    }
}
