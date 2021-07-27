import UIKit
import TextFieldEffects

class EmailInputViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var thirdLineLabel: UILabel!
    @IBOutlet var emailTextField: HoshiTextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
    
    @IBAction func pressedNext(_ sender: UIBarButtonItem) {
        
        if !checkIfValidEmail() { return }
        
        registerUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        UserRegisterValues.shared.registerEmail = emailTextField.text!
    }
    
    func registerUser() {
        
        showProgressBar()
        
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
                    let nextVC = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.emailVerificationViewController) as! EmailVerificationViewController
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                
            case .failure(let error):
                
                self.showSimpleBottomAlert(with: error.errorDescription)

            }
        
        }
        
    }
    
}

//MARK: - UI Configuration & Initialization

extension EmailInputViewController {
    
    func initialize() {
        
        initializeLabels()
        initializeTextFields()
    }
    
    func initializeTextFields() {
        
        emailTextField.addTarget(self,
                              action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
    }
    
    func initializeLabels() {
        
        errorLabel.isHidden = true
        
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

//MARK: - User Input Validation

extension EmailInputViewController {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        dismissErrorMessage()
        
        guard let text = emailTextField.text else { return }
    }
    
    func checkIfValidEmail() -> Bool {
        
        guard let email = emailTextField.text else {
            showErrorMessage(message: "빈 칸이 없는지 확인해 주세요. 🤔")
            return false
        }
        
//        guard email.contains("@knu.ac.kr") else {
//            showErrorMessage(message: "경북대학교 이메일이 맞는지 확인해 주세요. 🧐")
//            return false
//        }
        
        guard email.count > 11 else {
            showErrorMessage(message: "유효한 이메일인지 확인해 주세요. 👀")
            return false
        }
        return true
    }
    
    func dismissErrorMessage() {
        errorLabel.isHidden = true
    }
    
    func showErrorMessage(message: String) {
        
        errorLabel.isHidden = false
        errorLabel.text = message
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        errorLabel.textColor = UIColor(named: Constants.Color.appDefaultColor)
        
    }
}
