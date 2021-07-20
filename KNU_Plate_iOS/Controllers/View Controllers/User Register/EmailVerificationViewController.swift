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
        sendVerificationCode()
    }
    
    @IBAction func pressedFinish(_ sender: UIBarButtonItem) {
        
        verificationCodeTextField.resignFirstResponder()
    }
    
    @IBAction func pressedResendButton(_ sender: UIButton) {
        
        sendVerificationCode()
        
        // 버튼 막 누르는거 방지하기 위해 한 번 누르고 비활성화 시키고 타이머 작동? 10초?
    }
    
    @IBAction func pressedSkipButton(_ sender: UIButton) {
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.congratulateViewController)
                as? CongratulateRegisterViewController else { fatalError() }
        
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func sendVerificationCode() {
        
        UserManager.shared.sendEmailVerificationCode { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(_):
                return
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
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
