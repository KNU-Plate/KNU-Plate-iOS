import UIKit
import Then
import SnapKit

class MainCollectionViewCell: UICollectionViewCell {
    
    let backView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let foodImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
    }
    
    let insideLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 30)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(backView)
        backView.addSubview(foodImageView)
        backView.addSubview(insideLabel)
        self.addSubview(titleLabel)
        
        let spacing: CGFloat = 5
        backView.snp.makeConstraints { make in
            make.height.equalTo(backView.snp.width)
            make.top.leading.trailing.equalToSuperview().inset(spacing)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.bottom).offset(spacing)
            make.leading.trailing.bottom.equalToSuperview().inset(spacing)
        }
        
        foodImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.edges.equalToSuperview().inset(spacing*3)
        }
        insideLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = backView.frame.height
        backView.layer.cornerRadius = height/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
