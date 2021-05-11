import UIKit
import Then

class RestaurantView: UIView {
    
    // MARK: - Scroll View Declaration
    let scrollView = UIScrollView()
    
    // MARK: - Image Related View Declaration
    let imageContentsView = UIView()
    
    let imageButton1 = UIButton().then {
        $0.backgroundColor = UIColor.red
    }
    let imageButton2 = UIButton().then {
        $0.backgroundColor = UIColor.blue
    }
    let imageButton3 = UIButton().then {
        $0.backgroundColor = UIColor.yellow
    }
    let imageButton4 = UIButton().then {
        $0.backgroundColor = UIColor.green
        $0.alpha = 0.5
        $0.setTitle("이미지 더보기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
    }
    
    // MARK: - Store Info Related View Declaration
    let stackView1 = UIStackView().then {
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 25)
    }
    let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "favorite tab bar icon"), for: .normal)
        $0.setImage(UIImage(named: "favorite tab bar icon (filled)"), for: .highlighted)
        $0.setImage(UIImage(named: "favorite tab bar icon (filled)"), for: .selected)
        $0.addBounceReactionWithoutFeedback()
    }
    
    let stackView2 = UIStackView().then {
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    let gateNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    let ratingStackView = RatingStackView()
    
    let stackView3 = UIStackView().then {
        $0.axis = .horizontal
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    let foodCategoryLabel = UILabel().then {
        $0.textColor = UIColor.lightGray
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    let numberLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    // MARK: - Page Select Related View Declaration
    let topLine = UIView().then {
        $0.backgroundColor = UIColor.lightGray
    }
    
    let selectStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let reviewButton = UIButton(type: .custom).then {
        $0.tag = 0
        $0.setImage(UIImage(named: "review"), for: .normal)
        $0.setImage(UIImage(named: "review (selected)"), for: .selected)
        $0.setImage(UIImage(named: "review (selected)"), for: .highlighted)
        $0.setTitle("리뷰", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.setTitleColor(UIColor(named: Constants.Color.appDefaultColor), for: .selected)
        $0.setTitleColor(UIColor(named: Constants.Color.appDefaultColor), for: .highlighted)
        $0.alignTextBelow()
    }
    let locationButton = UIButton(type: .custom).then {
        $0.tag = 1
        $0.setImage(UIImage(named: "location"), for: .normal)
        $0.setImage(UIImage(named: "location (selected)"), for: .selected)
        $0.setImage(UIImage(named: "location (selected)"), for: .highlighted)
        $0.setTitle("위치", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.setTitleColor(UIColor(named: Constants.Color.appDefaultColor), for: .selected)
        $0.setTitleColor(UIColor(named: Constants.Color.appDefaultColor), for: .highlighted)
        $0.alignTextBelow()
    }
    let menuButton = UIButton().then {
        $0.tag = 2
        $0.setImage(UIImage(named: "menu"), for: .normal)
        $0.setImage(UIImage(named: "menu (selected)"), for: .selected)
        $0.setImage(UIImage(named: "menu (selected)"), for: .highlighted)
        $0.setTitle("메뉴", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.setTitleColor(UIColor(named: Constants.Color.appDefaultColor), for: .selected)
        $0.setTitleColor(UIColor(named: Constants.Color.appDefaultColor), for: .highlighted)
        $0.alignTextBelow()
    }
    
    let bottomLine = UIView().then {
        $0.backgroundColor = UIColor.lightGray
    }
    
    // MARK: - Bottom Content View Declaration
    let bottomContentsView = UIView()
    
    // MARK: - View Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageContentsView.addSubview(imageButton1)
        imageContentsView.addSubview(imageButton2)
        imageContentsView.addSubview(imageButton3)
        imageContentsView.addSubview(imageButton4)

        stackView1.addArrangedSubview(nameLabel)
        stackView1.addArrangedSubview(favoriteButton)

        stackView2.addArrangedSubview(gateNameLabel)
        stackView2.addArrangedSubview(ratingStackView)

        stackView3.addArrangedSubview(foodCategoryLabel)
        stackView3.addArrangedSubview(numberLabel)
        
        selectStackView.addArrangedSubview(reviewButton)
        selectStackView.addArrangedSubview(locationButton)
        selectStackView.addArrangedSubview(menuButton)

        scrollView.addSubview(imageContentsView)
        scrollView.addSubview(stackView1)
        scrollView.addSubview(stackView2)
        scrollView.addSubview(stackView3)
        scrollView.addSubview(topLine)
        scrollView.addSubview(selectStackView)
        scrollView.addSubview(bottomLine)
        scrollView.addSubview(bottomContentsView)

        self.addSubview(scrollView)
    }
    
    // MARK: - View Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let imageContentsViewHeight: CGFloat = 250
        let imageContentsViewWidth: CGFloat = frame.width

        imageContentsView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageContentsViewHeight)
            make.width.equalTo(imageContentsViewWidth)
        }

        let padding: CGFloat = 3
        let paddingSpace: CGFloat = padding*3
        let imageButtonHeight: CGFloat = (imageContentsViewHeight-paddingSpace)/2
        let imageButtonWidth: CGFloat = (imageContentsViewWidth-paddingSpace)/2

        imageButton1.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.equalTo(imageButtonWidth)
            make.top.left.equalToSuperview().inset(padding)
            make.right.equalTo(imageButton2.snp.left).offset(-padding)
        }

        imageButton2.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.equalTo(imageButtonWidth)
            make.top.right.equalToSuperview().inset(padding)
        }

        imageButton3.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.equalTo(imageButtonWidth)
            make.top.equalTo(imageButton1.snp.bottom).offset(padding)
            make.left.bottom.equalToSuperview().inset(padding)
            make.right.equalTo(imageButton4.snp.left).offset(-padding)
        }

        imageButton4.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight)
            make.width.equalTo(imageButtonWidth)
            make.top.equalTo(imageButton2.snp.bottom).offset(padding)
            make.right.bottom.equalToSuperview().inset(padding)
        }

        stackView1.snp.makeConstraints { make in
            make.top.equalTo(imageContentsView.snp.bottom).offset(padding*2)
            make.left.right.equalToSuperview()
        }

        stackView2.snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(padding*2)
            make.left.right.equalToSuperview()
        }

        ratingStackView.snp.makeConstraints { make in
            make.width.equalTo(frame.width/6)
        }

        stackView3.snp.makeConstraints { make in
            make.top.equalTo(stackView2.snp.bottom).offset(padding*2)
            make.left.right.equalToSuperview()
        }

        topLine.snp.makeConstraints { make in
            make.top.equalTo(stackView3.snp.bottom).offset(padding*4)
            make.height.equalTo(1)
            make.width.centerX.equalToSuperview()
        }

        selectStackView.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(padding*2)
            make.height.equalTo(70)
            make.width.centerX.equalToSuperview()
        }

        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(selectStackView.snp.bottom).offset(padding*2)
            make.height.equalTo(1)
            make.width.centerX.equalToSuperview()
        }

        bottomContentsView.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(padding*2)
            make.width.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
