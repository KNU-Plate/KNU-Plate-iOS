import UIKit

class JinRatingController: UIStackView {

    var starButtons: [UIButton] = []
    var starsRating = 3                             // 기본 별점은 3점으로 시작
    let starsEmptyPicName = "star"                  // Empty star name (SF Symbol)
    let starsFilledPicName = "star.fill"            // Filled star name (SF Symbol)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fillEqually
        var starTag = 1
        for _ in 0..<5 {
            let button = UIButton()
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(UIImage(systemName: starsEmptyPicName), for: [.normal, .disabled])
            button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
            button.tag = starTag
            self.addArrangedSubview(button)
            self.starButtons.append(button)
            starTag = starTag + 1
        }
        setStarsRating(rating: starsRating)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setStarsRating(rating: Int){
        self.starsRating = rating
        for button in starButtons {
            if button.tag > starsRating {
                button.setImage(UIImage(systemName: starsEmptyPicName), for: [.normal, .disabled])
                button.tintColor = .systemYellow
            } else{
                button.setImage(UIImage(systemName: starsFilledPicName), for: [.normal, .disabled])
                button.tintColor = .systemYellow
            }
        }
    }
    
    func disableAllButton() {
        for button in starButtons {
            button.isEnabled = false
        }
    }
    
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
}
