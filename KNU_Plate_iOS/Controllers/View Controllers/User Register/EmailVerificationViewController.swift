import UIKit
import TextFieldEffects

class EmailVerificationViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var verificationCodeTextField: HoshiTextField!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    @IBAction func pressedFinish(_ sender: UIBarButtonItem) {
        
        // 인증
        
    
    }
    
    
    @IBAction func pressedResendButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func pressedSkipButton(_ sender: UIButton) {
        
        
        
        
    }
    
    


}

//MARK: - UI Configuration & Initialization

extension EmailVerificationViewController {
    
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
