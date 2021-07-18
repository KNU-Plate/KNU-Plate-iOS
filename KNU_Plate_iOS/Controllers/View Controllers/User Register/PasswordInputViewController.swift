import UIKit
import TextFieldEffects

class PasswordInputViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var thirdLineLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet var passwordTextField: HoshiTextField!
    @IBOutlet var checkPasswordTextField: HoshiTextField!
    
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
        
        firstLineLabel.text = "로그인하실 때 사용할 비밀번호를"
        firstLineLabel.changeTextAttributeColor(fullText: firstLineLabel.text!, changeText: "비밀번호")
        secondLineLabel.text = "입력해주세요!"
    }
}
