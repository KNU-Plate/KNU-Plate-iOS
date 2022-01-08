import UIKit
import Then
import SnapKit
import Lottie

class EmptyStateTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    let animationView = AnimationView().then {
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .playOnce
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleLabel)
        self.addSubview(animationView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        animationView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(titleText: String, animationName: String) {
        titleLabel.text = titleText
        animationView.animation = Animation.named(animationName)
        titleLabel.sizeToFit()
    }
}
