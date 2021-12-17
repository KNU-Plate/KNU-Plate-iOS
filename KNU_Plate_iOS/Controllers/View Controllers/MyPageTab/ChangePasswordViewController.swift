import UIKit
import SnackBar_swift

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkPasswordTextField: UITextField!
    @IBOutlet var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    @IBAction func pressedChangeButton(_ sender: UIButton) {
        
        changeButton.isUserInteractionEnabled = false
        self.view.endEditing(true)
        if !validateUserInput() { return }
        
        let model = EditUserInfoRequestDTO(password: passwordTextField.text!)
        
        showProgressBar()
        UserManager.shared.updatePassword(with: model) { [weak self] result in
            guard let self = self else { return }
            dismissProgressBar()
            self.changeButton.isUserInteractionEnabled = true
            switch result {
            case .success(_):
                self.showSimpleBottomAlert(with: "비밀번호 변경 성공 🎉")
            case .failure(_):
                self.showSimpleBottomAlert(with: "비밀번호 변경 실패. 잠시 후 다시 시도해주세요. 🥲")
            }
        }
    }
    
    func validateUserInput() -> Bool {
        
        guard let password = passwordTextField.text,
              let checkPassword = checkPasswordTextField.text else {
            return false
        }
        
        guard !password.isEmpty,
              !checkPassword.isEmpty else {
            showSimpleBottomAlert(with: "빈 칸이 없는지 확인해주세요 🥲")
            return false
        }
        
        guard password == checkPassword else {
            showSimpleBottomAlert(with: "비밀번호가 일치하지 않습니다 🥲")
            return false
        }
        
        guard password.count >= 4,
              password.count < 30,
              checkPassword.count >= 4,
              checkPassword.count < 30 else {
            showSimpleBottomAlert(with: "비밀번호는 4자 이상, 30자 미만으로 입력해주세요 🥲")
            return false
        }
        return true
    }
}

//MARK: - UI Configuration

extension ChangePasswordViewController {
    
    func initialize() {
        initializeTextFields()
        initializeButton()
    }
    
    func initializeTextFields() {
        
        passwordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
    }
    
    func initializeButton() {
        changeButton.layer.cornerRadius = 10
    }
    
    
}
