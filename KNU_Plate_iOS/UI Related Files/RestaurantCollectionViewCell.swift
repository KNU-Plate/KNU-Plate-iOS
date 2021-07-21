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
    
    
    let ratingStackView: RatingStackView = {
        let stackView = RatingStackView()
        return stackView
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
        let stackViewWidth: CGFloat = self.frame.width*(0.35)
        let nameLabelHeight: CGFloat = (self.frame.height - imageViewHeight)*(2/5)
        
        countStackView.addArrangedSubview(pencilImageView)
        countStackView.addArrangedSubview(countLabel)
        
        self.addSubview(imageView)
        self.addSubview(nameLabel)
        self.addSubview(countStackView)
        self.addSubview(ratingStackView)
        
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
        
        ratingStackView.snp.makeConstraints { (make) in
            make.width.equalTo(stackViewWidth)
            make.top.equalTo(nameLabel.snp.bottom).offset(inset)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(inset*2)
        }
    }
}
