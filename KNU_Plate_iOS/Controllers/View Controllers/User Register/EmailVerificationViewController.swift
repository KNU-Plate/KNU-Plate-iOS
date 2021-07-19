import UIKit
import TextFieldEffects

class EmailVerificationViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var verificationCodeTextField: HoshiTextField!
    @IBOutlet var resendButton: UIButton!
    
    var id: String = ""
    var nickname: String = ""
    var password: String = ""
    var email: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    @IBAction func pressedResendButton(_ sender: UIButton) {
        
        
    }
    
    func initialize() {
        
        initializeLabels()
    }
    
    func initializeLabels() {
        
        firstLineLabel.text = "이메일함을 확인해 주세요!"
        firstLineLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        firstLineLabel.textColor = .darkGray
        
        secondLineLabel.text = "메일로 발송된 인증코드를 입력해 주세요!"
        secondLineLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        secondLineLabel.textColor = .darkGray
        secondLineLabel.changeTextAttributeColor(fullText: secondLineLabel.text!, changeText: "인증코드")
        
    }
}
