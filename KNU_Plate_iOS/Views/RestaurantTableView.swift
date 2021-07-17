import UIKit
import Then

class RestaurantTableView: UIView {

    // MARK: - Image Related View
    let imageContentsView = UIView()
    
    let imageView1 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let imageView2 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let imageView3 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let imageView4 = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let innerView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = 0.5
    }
    let innerLabel = UILabel().then {
        $0.text = "이미지 더보기"
        $0.textColor = .white
    }
    
    // MARK: - Store Info Related View
    let stackView1 = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill // .fillEqually는 안됨!!
        $0.spacing = 10
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
    }
    let foodCategoryLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 13)
    }
    
    let stackView2 = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 5
    }
    
    let gateNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.font = UIFont.systemFont(ofSize: 17)
    }
    let ratingStackView = RatingStackView()
    let numberLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .lightGray
    }
    
//    let favoriteButton = UIButton().then {
//        $0.setImage(UIImage(named: "favorite tab bar icon"), for: .normal)
//        $0.setImage(UIImage(named: "favorite tab bar icon (filled)"), for: .highlighted)
//        $0.setImage(UIImage(named: "favorite tab bar icon (filled)"), for: .selected)
//        $0.addBounceReactionWithoutFeedback()
//    }
    
    // MARK: - Table Header View
    let headerView = UIView()
    
    // MARK: - TableView
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviewAndLayout(frame: frame)
        tableView.tableHeaderView = headerView
    }
    
    func addSubviewAndLayout(frame: CGRect) {
        imageView4.addSubview(innerView)
        imageView4.addSubview(innerLabel)
        
        imageContentsView.addSubview(imageView1)
        imageContentsView.addSubview(imageView2)
        imageContentsView.addSubview(imageView3)
        imageContentsView.addSubview(imageView4)

        stackView1.addArrangedSubview(nameLabel)
        stackView1.addArrangedSubview(foodCategoryLabel)
        
        stackView2.addArrangedSubview(gateNameLabel)
        stackView2.addArrangedSubview(ratingStackView)
        stackView2.addArrangedSubview(numberLabel)
        
        headerView.addSubview(imageContentsView)
        headerView.addSubview(stackView1)
        headerView.addSubview(stackView2)
//        headerView.addSubview(favoriteButton)
        
        self.addSubview(tableView)
        
        let imageContentsViewHeight: CGFloat = 250
        let imageContentsViewWidth: CGFloat = frame.width

        imageContentsView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageContentsViewHeight)
            make.width.equalTo(imageContentsViewWidth).priority(.low)
        }

        let padding: CGFloat = 3
        let paddingSpace: CGFloat = padding*3
        let imageButtonHeight: CGFloat = (imageContentsViewHeight-paddingSpace)/2
        let imageButtonWidth: CGFloat = (imageContentsViewWidth-paddingSpace)/2

        imageView1.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.lessThanOrEqualTo(imageButtonWidth)
            make.top.left.equalToSuperview().inset(padding)
            make.right.equalTo(imageView2.snp.left).offset(-padding)
        }

        imageView2.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.lessThanOrEqualTo(imageButtonWidth)
            make.top.equalToSuperview().inset(padding)
            make.right.equalToSuperview().inset(padding).priority(.low)
        }

        imageView3.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.lessThanOrEqualTo(imageButtonWidth)
            make.top.equalTo(imageView1.snp.bottom).offset(padding)
            make.left.bottom.equalToSuperview().inset(padding)
            make.right.equalTo(imageView4.snp.left).offset(-padding)
        }

        imageView4.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.lessThanOrEqualTo(imageButtonWidth)
            make.top.equalTo(imageView2.snp.bottom).offset(padding)
            make.bottom.equalToSuperview().inset(padding)
            make.right.equalToSuperview().inset(padding).priority(.low)
        }
        
        innerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        innerLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        let stackViewHeight: CGFloat = 35
        
        nameLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(frame.width*0.8)
        }

        stackView1.snp.makeConstraints { make in
            make.top.equalTo(imageContentsView.snp.bottom).offset(padding*2)
            make.centerX.equalToSuperview()
            make.height.equalTo(stackViewHeight)
            make.width.lessThanOrEqualTo(frame.width)
        }

        gateNameLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(70)
        }
        
        stackView2.snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(padding*2)
            make.centerX.bottom.equalToSuperview()
            make.height.equalTo(stackViewHeight)
        }
        
//        favoriteButton.snp.makeConstraints { make in
//            make.centerY.equalTo(stackView2)
//            make.left.equalTo(stackView2.snp.right).priority(.low)
//            make.right.equalToSuperview().priority(.low)
//        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
