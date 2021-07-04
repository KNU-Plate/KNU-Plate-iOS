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
    
    let imageButton1 = UIButton().then {
        $0.backgroundColor = .red
    }
    let imageButton2 = UIButton().then {
        $0.backgroundColor = .blue
    }
    let imageButton3 = UIButton().then {
        $0.backgroundColor = .yellow
    }
    let imageButton4 = UIButton().then {
        $0.backgroundColor = .green
        $0.alpha = 0.5
        $0.setTitle("이미지 더보기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    // MARK: - Store Info Related View
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
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 20)
    }
    let numberLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15)
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
        stackView1.addArrangedSubview(favoriteButton)

        stackView2.addArrangedSubview(gateNameLabel)
        stackView2.addArrangedSubview(ratingStackView)

        stackView3.addArrangedSubview(foodCategoryLabel)
        stackView3.addArrangedSubview(numberLabel)
        
        headerView.addSubview(imageContentsView)
        headerView.addSubview(stackView1)
        headerView.addSubview(stackView2)
        headerView.addSubview(stackView3)
        
        self.addSubview(tableView)
        
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
        
        let stackViewHeight: CGFloat = 35

        stackView1.snp.makeConstraints { make in
            make.top.equalTo(imageContentsView.snp.bottom).offset(padding*2)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(stackViewHeight)
        }

        stackView2.snp.makeConstraints { make in
            make.top.equalTo(stackView1.snp.bottom).offset(padding*2)
            make.left.right.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(stackViewHeight)
        }

        ratingStackView.snp.makeConstraints { make in
            make.width.equalTo(frame.width/6)
        }

        stackView3.snp.makeConstraints { make in
            make.top.equalTo(stackView2.snp.bottom).offset(padding*2)
            make.left.right.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(stackViewHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
