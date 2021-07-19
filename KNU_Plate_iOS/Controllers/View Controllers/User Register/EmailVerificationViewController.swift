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
        
        showProgressBar()
        
        verificationCodeTextField.resignFirstResponder()
        
        // 이메일 인증을 했는지 안 했는지 확인하는 API 실행
        
        registerUser()
        
    
    }
    
    
    @IBAction func pressedResendButton(_ sender: UIButton) {
        
        
    }
    
    @IBAction func pressedSkipButton(_ sender: UIButton) {
        
        
        registerUser()
        
    }
    
    func registerUser() {
        
        let model = RegisterRequestDTO(username: UserRegisterValues.shared.registerID,
                                       displayName: UserRegisterValues.shared.registerNickname,
                                       password: UserRegisterValues.shared.registerPassword,
                                       email: UserRegisterValues.shared.registerEmail,
                                       profileImage: nil)
        
        UserManager.shared.register(with: model) { [weak self] result in
            
            guard let self = self else { return }
            
            dismissProgressBar()
            
            switch result {
            
            case .success(_):
                
                DispatchQueue.main.async {
                    
                    let nextVC = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.congratulateViewController) as! CongratulateRegisterViewController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
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
