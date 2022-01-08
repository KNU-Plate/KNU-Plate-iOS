import UIKit
import SnapKit
import Lottie
import Then

class EmptyStateView: UIView {
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    let animationView = AnimationView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFit
        $0.loopMode = .playOnce
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(animationView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(animationView.snp.bottom).offset(10)
        }
        
        animationView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
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
