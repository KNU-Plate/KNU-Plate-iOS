import UIKit
import SnackBar_swift

class ChangeNicknameViewController: UIViewController {
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var changeButton: UIButton!
    @IBOutlet var checkAlreadyInUseButton: UIButton!
    
    private var nickname: String?
    private var didCheckNicknameDuplicate: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initialize()
    }
    
    
    @IBAction func pressedCheckDuplicateButton(_ sender: UIButton) {
        
        checkIfDuplicate()
    }

    @IBAction func pressedChangeButton(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        showProgressBar()

        if !didCheckNicknameDuplicate {
            SnackBar.make(in: self.view,
                          message: "🤔 닉네임 중복 확인을 먼저해주세요.",
                          duration: .lengthLong).show()

            dismissProgressBar()
            return
        }
        
        guard let nickname = self.nickname else {
            SnackBar.make(in: self.view,
                          message: "🤔 빈 칸이 없는지 확인해주세요.",
                          duration: .lengthLong).show()
            return
        }
        
        let editUserModel = EditUserInfoModel(nickname: nickname)
        
        UserManager.shared.updateNickname(with: editUserModel) { isSuccess in
        
            if isSuccess {
                
                dismissProgressBar()
                self.navigationController?.popViewController(animated: true)
                
            } else {
                DispatchQueue.main.async {
                    SnackBar.make(in: self.view,
                                  message: "닉네임 변경 실패. 잠시 후 다시 시도해주세요 🥲",
                                  duration: .lengthLong).show()
                }
            }
            dismissProgressBar()
        }
    }
    
    func checkIfDuplicate() {
        
        self.view.endEditing(true)
        
        if !validateUserInput() { return }
        
        let requestURL = UserManager.shared.checkDisplayNameDuplicateURL
        let checkDuplicateModel = CheckDuplicateModel(displayName: nickname!)
        
        UserManager.shared.checkDuplication(with: checkDuplicateModel,
                                            requestURL: requestURL) { isNotDuplicate in
            
            if isNotDuplicate {
                
                DispatchQueue.main.async {
                    print("Check Duplication: 중복 아님!")
                    self.checkAlreadyInUseButton.setTitle("사용하셔도 좋습니다 👍", for: .normal)
                    self.didCheckNicknameDuplicate = true
                }
            } else {
                
                DispatchQueue.main.async {
                    print("Check Duplication: 중복이다!")
                    self.checkAlreadyInUseButton.setTitle("이미 사용 중인 닉네임입니다 😢", for: .normal)
                    self.didCheckNicknameDuplicate = false
                }
            }
        }
    }
    
    func validateUserInput() -> Bool {
        
        guard let nickname = nicknameTextField.text else {
            return false
        }
        guard !nickname.isEmpty else {
            SnackBar.make(in: self.view,
                          message: "빈 칸이 없는지 확인해주세요 🥲",
                          duration: .lengthLong).show()
            return false
        }
        guard nickname.count >= 2, nickname.count <= 10 else {
            SnackBar.make(in: self.view,
                          message: "닉네임은 2자 이상, 10자 이하로 작성해주세요❗️ ",
                          duration: .lengthLong).show()
            return false
        }
        self.nickname = nickname
        return true
    }
}

//MARK: - UITextFieldDelegate

extension ChangeNicknameViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == nicknameTextField {
            didCheckNicknameDuplicate = false
            checkAlreadyInUseButton.setTitle("중복 확인", for: .normal)
            checkAlreadyInUseButton.titleLabel?.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        }
    }
    
}

//MARK: - UI Configuration

extension ChangeNicknameViewController {
    
    func initialize() {
    
        initializeTextField()
        initializeButton()
    }
    
    func initializeTextField() {
        
        nicknameTextField.delegate = self
    }
    
    func initializeButton() {
        
        changeButton.layer.cornerRadius = 10
    }
}
