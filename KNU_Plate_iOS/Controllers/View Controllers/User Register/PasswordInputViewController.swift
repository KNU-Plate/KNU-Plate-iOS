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

    @IBAction func pressedNext(_ sender: UIBarButtonItem) {
        
        passwordTextField.endEditing(true)
        checkPasswordTextField.endEditing(true)
        
        if !checkPasswordLengthIsValid() || !checkIfPasswordFieldsAreIdentical() { return }
        
        UserRegisterValues.shared.registerPassword = passwordTextField.text!
        
        registerUser()
    }
    
    func registerUser() {
        
        showProgressBar()
        
        let model = RegisterRequestDTO(username: UserRegisterValues.shared.registerID,
                                       password: UserRegisterValues.shared.registerPassword,
                                       profileImage: nil)
        
        UserManager.shared.register(with: model) { [weak self] result in
            
            guard let self = self else { return }
            
            dismissProgressBar()
            
            switch result {
            case .success(_):
                self.presentCongratulateVC()
                                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    func presentCongratulateVC() {
        
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.congratulateViewController)
                as? CongratulateRegisterViewController else { fatalError() }
        
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
}

//MARK: - UI Configuration & Initialization

extension PasswordInputViewController {

    func initialize() {
        
        initializeLabels()
        initializeTextFields()
    }
    
    func initializeTextFields() {
        
        passwordTextField.addTarget(self,
                              action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
        checkPasswordTextField.addTarget(self,
                              action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
     
    }
    
    func initializeLabels() {
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .darkGray
        }
        
        thirdLineLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        thirdLineLabel.textColor = .lightGray
        
        firstLineLabel.text = "??????????????? ??? ????????? ???????????????"
        firstLineLabel.changeTextAttributeColor(fullText: firstLineLabel.text!, changeText: "????????????")
        secondLineLabel.text = "??????????????????!"
    }
}

//MARK: - User Input Validation

extension PasswordInputViewController {
    
    func checkPasswordLengthIsValid() -> Bool {
        
        guard let password = passwordTextField.text, let _ = checkPasswordTextField.text else {
            
            showErrorMessage(message: "??? ?????? ????????? ????????? ?????????. ????")
            return false
        }
        
        if password.count >= 4 && password.count <= 30 { return true }
        else {
            showErrorMessage(message: "4??? ??????, 30??? ????????? ???????????????. ????")
            return false
        }
    }
    
    func checkIfPasswordFieldsAreIdentical() -> Bool {
        
        if passwordTextField.text == checkPasswordTextField.text { return true }
        else {
            showErrorMessage(message: "??????????????? ???????????? ????????????. ????")
            checkPasswordTextField.text?.removeAll()
            passwordTextField.becomeFirstResponder()
            return false
        }
    }
    
    func showErrorMessage(message: String) {
    
        thirdLineLabel.text = message
        thirdLineLabel.textColor = UIColor(named: Constants.Color.appDefaultColor)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        thirdLineLabel.text = "4??? ??????, 30??? ????????? ???????????????."
        thirdLineLabel.textColor = .lightGray
    }
}
