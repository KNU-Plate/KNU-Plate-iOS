//
//  RestaurantTabBarView.swift
//  KNU_Plate_iOS
//
//  Created by Jinyoung Kim on 2021/06/29.
//

import UIKit
import Then

class RestaurantTabBarView: UIView {
    
    let contentView = UIView()
    
    // MARK: - Page Select Related View
    let topLine = UIView().then {
        $0.backgroundColor = .lightGray
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
        $0.backgroundColor = .lightGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectStackView.addArrangedSubview(reviewButton)
        selectStackView.addArrangedSubview(locationButton)
        selectStackView.addArrangedSubview(menuButton)
        
        contentView.addSubview(topLine)
        contentView.addSubview(selectStackView)
        contentView.addSubview(bottomLine)
        
        self.addSubview(contentView)
        
        let lineHeight: CGFloat = 1
        let selectStackViewHeight: CGFloat = 70
        let padding: CGFloat = 3
        
        topLine.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(lineHeight)
            make.width.centerX.equalToSuperview()
        }

        selectStackView.snp.makeConstraints { make in
            make.top.equalTo(topLine.snp.bottom).offset(padding*2)
            make.height.equalTo(selectStackViewHeight)
            make.width.centerX.equalToSuperview()
        }

        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(selectStackView.snp.bottom).offset(padding*2)
            make.height.equalTo(lineHeight)
            make.width.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
