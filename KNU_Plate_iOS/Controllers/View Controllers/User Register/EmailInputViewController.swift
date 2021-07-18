import UIKit
import TextFieldEffects

class EmailInputViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var thirdLineLabel: UILabel!
    @IBOutlet var emailTextField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    
    func initialize() {
        
        initializeLabels()
    }
    
    func initializeLabels() {
        
        
        firstLineLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        firstLineLabel.textColor = .gray
        
        secondLineLabel.text = "마지막으로 이메일 인증을 해주세요!"
        secondLineLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        secondLineLabel.textColor = .darkGray
        secondLineLabel.changeTextAttributeColor(fullText: secondLineLabel.text!, changeText: "이메일 인증")

        
        
        thirdLineLabel.text = "크슐랭가이드는 건전한 리뷰 문화 형성과 경대생들의 솔직한 리뷰 공유를 위해 이메일 인증을 실시하고 있습니다."
        thirdLineLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        thirdLineLabel.textColor = .lightGray
        thirdLineLabel.changeTextAttributeColor(fullText: thirdLineLabel.text!, changeText: "크슐랭가이드")
    }

}
