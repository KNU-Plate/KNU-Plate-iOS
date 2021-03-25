import UIKit

// 맛집 별점 Stack View 컨트롤러

class RatingController: UIStackView {
    
    var starsRating = 3                             // 기본 별점은 3점으로 시작
    
    var starsEmptyPicName = "star"                  // Empty star name (SF Symbol)
    var starsFilledPicName = "star.fill"            // Filled star name (SF Symbol)
    
    override func draw(_ rect: CGRect) {
        
        let starButtons = self.subviews.filter{$0 is UIButton}
        var starTag = 1
        for button in starButtons {
            if let button = button as? UIButton {
                button.setImage(UIImage(named: starsEmptyPicName), for: .normal)
                button.addTarget(self, action: #selector(self.pressed(sender:)), for: .touchUpInside)
                button.tag = starTag
                starTag = starTag + 1
            }
        }
        setStarsRating(rating:starsRating)
    }
    
    func setStarsRating(rating:Int){
        self.starsRating = rating
        let stackSubViews = self.subviews.filter {$0 is UIButton}
        for subView in stackSubViews {
            if let button = subView as? UIButton {
                if button.tag > starsRating {
                    
                    let configuration = UIImage.SymbolConfiguration(pointSize: 35.0)
                    button.setImage(UIImage(systemName: starsEmptyPicName, withConfiguration: configuration), for: .normal)
                    button.tintColor = .systemYellow
                    
                    
                } else{
                    
                    let configuration = UIImage.SymbolConfiguration(pointSize: 35.0)
                    button.setImage(UIImage(systemName: starsFilledPicName, withConfiguration: configuration), for: .normal)
                    button.tintColor = .systemYellow
                    
                }
            }
        }
    }
    
    @objc func pressed(sender: UIButton) {
        setStarsRating(rating: sender.tag)
    }
    
}
