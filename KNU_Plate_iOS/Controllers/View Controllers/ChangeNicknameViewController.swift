import UIKit

class ChangeNicknameViewController: UIViewController {
    
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var changeButton: UIButton!
    
    private var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initialize()
    }
    
    
    @IBAction func pressedChangeButton(_ sender: UIButton) {
        
        if !validateUserInput() { return }
        if !checkIfDuplicate() { return }
        
        //그 다음에 통신
        

    }
    
    func checkIfDuplicate() -> Bool {
        
        let requestURL = UserManager.shared.checkDisplayNameDuplicateURL
        let checkDuplicateModel = CheckDuplicateModel(displayName: nickname!)
        
        UserManager.shared.checkDuplication(with: checkDuplicateModel,
                                            requestURL: requestURL) { isDuplicate in
            
            if isDuplicate {
                self.showToast(message: "사용하셔도 좋습니다 👍")
            } else {
                self.presentSimpleAlert(title: "이미 사용 중인 닉네임입니다 😢", message: "")
            }
        }
      
        return true
    }
    
    func validateUserInput() -> Bool {
        
        guard let nickname = nicknameTextField.text else {
            return false
        }
        
        guard !nickname.isEmpty else {
            self.presentSimpleAlert(title: "입력 오류", message: "빈 칸이 없는지 확인해주세요.")
            return false
        }
        
        guard nickname.count >= 2, nickname.count <= 10 else {
            self.presentSimpleAlert(title: "닉네임 길이 오류", message: "닉네임은 2자 이상, 10자 이하로 작성해주세요.")
            return false
        }
        
        
        self.nickname = nickname
        
        return true
    }


}



//MARK: - UI Configuration

extension ChangeNicknameViewController {
    
    func initialize() {
        
        initializeTextFields()
        initializeButton()
        
    }
    
    func initializeTextFields() {
        
        
        
    }
    
    func initializeButton() {
        
        changeButton.layer.cornerRadius = 10
    }
}
