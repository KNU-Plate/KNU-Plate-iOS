//
//  RestaurantTableView.swift
//  KNU_Plate_iOS
//
//  Created by Jinyoung Kim on 2021/06/29.
//

import UIKit
import Then

class RestaurantTableView: UIView {

    // MARK: - Image Related View
    let imageContentsView = UIView()
    
    let imageButton1 = UIButton()
    let imageButton2 = UIButton()
    let imageButton3 = UIButton()
    let imageButton4 = UIButton().then {
        $0.alpha = 0.5
        $0.setTitle("이미지 더보기", for: .normal)
        $0.setTitleColor(.systemGray, for: .normal)
    }
    
    // MARK: - Store Info Related View
    let stackView1 = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 25)
    }
    let foodCategoryLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    
    let stackView2 = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 10
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
    
    let favoriteButton = UIButton().then {
        $0.setImage(UIImage(named: "favorite tab bar icon"), for: .normal)
        $0.setImage(UIImage(named: "favorite tab bar icon (filled)"), for: .highlighted)
        $0.setImage(UIImage(named: "favorite tab bar icon (filled)"), for: .selected)
        $0.addBounceReactionWithoutFeedback()
    }
    
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
        imageContentsView.addSubview(imageButton1)
        imageContentsView.addSubview(imageButton2)
        imageContentsView.addSubview(imageButton3)
        imageContentsView.addSubview(imageButton4)

        stackView1.addArrangedSubview(nameLabel)
        stackView1.addArrangedSubview(foodCategoryLabel)
        
        stackView2.addArrangedSubview(gateNameLabel)
        stackView2.addArrangedSubview(ratingStackView)
        stackView2.addArrangedSubview(numberLabel)
        
        headerView.addSubview(imageContentsView)
        headerView.addSubview(stackView1)
        headerView.addSubview(stackView2)
        headerView.addSubview(favoriteButton)
        
        self.addSubview(tableView)
        
        let imageContentsViewHeight: CGFloat = 250
        let imageContentsViewWidth: CGFloat = frame.width

        imageContentsView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().labeled("error label: 1")
            make.height.equalTo(imageContentsViewHeight).labeled("error label: 2")
            make.width.equalTo(imageContentsViewWidth).labeled("error label: 3")
        }

        let padding: CGFloat = 3
        let paddingSpace: CGFloat = padding*3
        let imageButtonHeight: CGFloat = (imageContentsViewHeight-paddingSpace)/2
        let imageButtonWidth: CGFloat = (imageContentsViewWidth-paddingSpace)/2

        imageButton1.snp.makeConstraints { make in
            make.height.equalTo(imageButtonHeight).labeled("error label: 4")
            make.width.equalTo(imageButtonWidth).labeled("error label: 5")
            make.top.left.equalToSuperview().inset(padding).labeled("error label: 6")
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
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalTo(stackView2)
            make.left.equalTo(stackView2.snp.right)
            make.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
