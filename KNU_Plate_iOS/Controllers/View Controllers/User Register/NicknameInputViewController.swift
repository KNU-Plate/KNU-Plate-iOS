import UIKit
import TextFieldEffects

class NicknameInputViewController: UIViewController {
    
    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var thirdLineLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var nicknameTextField: HoshiTextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    @IBAction func pressedNext(_ sender: UIBarButtonItem) {
        
        if !checkNicknameLengthIsValid() { return }
        checkNicknameDuplication()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //guard let nextVC = segue.destination as? PasswordInputViewController else { fatalError() }
        UserRegisterValues.shared.registerNickname = nicknameTextField.text!
    }
    
}

//MARK: - UI Configuration & Initialization

extension NicknameInputViewController {

    func initialize() {
        
        initializeLabels()
        initializeTextField()
    }
    
    func initializeTextField() {
        
        nicknameTextField.addTarget(self,
                              action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
    }
  
    
    func initializeLabels() {
        
        errorLabel.isHidden = true
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .darkGray
        }
        
        thirdLineLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        thirdLineLabel.textColor = .lightGray
        
        firstLineLabel.text = "\(UserRegisterValues.shared.registerID)님 만나서 반갑습니다!"
        firstLineLabel.changeTextAttributeColor(fullText: firstLineLabel.text!, changeText: "\(UserRegisterValues.shared.registerID)님")
        secondLineLabel.text = "사용하실 닉네임을 입력해주세요!"
        secondLineLabel.changeTextAttributeColor(fullText: secondLineLabel.text!, changeText: "닉네임을")
    }
    
}

//MARK: - User Input Validation

extension NicknameInputViewController {
    
    func checkNicknameLengthIsValid() -> Bool {
        
        guard let nickname = nicknameTextField.text else { return false }
        
        if nickname.count >= 2 && nickname.count <= 10 { return true }
        else {
            showErrorMessage(message: "닉네임은 2자 이상, 10자 이하로 적어주세요.")
            return false
        }
    }
    
    func showErrorMessage(message: String) {
        
        errorLabel.isHidden = false
        errorLabel.text = message
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        errorLabel.textColor = UIColor(named: Constants.Color.appDefaultColor)
        
    }
    
    func checkNicknameDuplication() {
        
        let url = UserManager.shared.checkDisplayNameDuplicateURL
        let model = CheckDuplicateRequestDTO(displayName: nicknameTextField.text!)
        
        UserManager.shared.checkDuplication(requestURL: url,
                                            model: model) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let isNotDuplicate):
                
                if isNotDuplicate {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: Constants.SegueIdentifier.goToPasswordVC, sender: self)
                    }
                }
                else { self.showErrorMessage(message: "이미 사용 중인 닉네임입니다. 🥲") }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    func dismissErrorMessage() {
        errorLabel.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        dismissErrorMessage()
    }
}
