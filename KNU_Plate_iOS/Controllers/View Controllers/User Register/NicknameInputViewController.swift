import UIKit
import TextFieldEffects

class NicknameInputViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var thirdLineLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var nicknameTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    

    func initialize() {
        
        initializeLabels()
    }
    
    func initializeLabels() {
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .darkGray
        }
        
        thirdLineLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        thirdLineLabel.textColor = .lightGray
        
        firstLineLabel.text = "님 만나서 반갑습니다!"
        firstLineLabel.changeTextAttributeColor(fullText: firstLineLabel.text!, changeText: "님")
        secondLineLabel.text = "사용하실 닉네임을 입력해주세요!"
        secondLineLabel.changeTextAttributeColor(fullText: secondLineLabel.text!, changeText: "닉네임을")
    }
}
