import UIKit
import TextFieldEffects

class IDInputViewController: UIViewController {

    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var idTextField: HoshiTextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    @IBAction func pressedNext(_ sender: UIBarButtonItem) {
        
        if !checkIDLengthIsValid() {
            print("❗️ id length error")
            return
        }
        checkIDDuplication()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //guard let nextVC = segue.destination as? NicknameInputViewController else { fatalError() }
        UserRegisterValues.shared.registerID = idTextField.text!
    }
}

//MARK: - UI Configuration & Initialization

extension IDInputViewController {
    
    func initialize() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        initializeTextField()
        initializeLabels()
    }
    
    func initializeTextField() {
        
        idTextField.addTarget(self,
                              action: #selector(textFieldDidChange(_:)),
                              for: .editingChanged)
    }
  
    func initializeLabels() {
        
        errorLabel.isHidden = true
        
        labels.forEach { label in
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            label.textColor = .darkGray
        }
    
        firstLineLabel.text = "크슐랭가이드에 오신 것을 환영해요!"
        firstLineLabel.changeTextAttributeColor(fullText: firstLineLabel.text!, changeText: "크슐랭가이드")
        secondLineLabel.text = "로그인할 때 사용할 아이디를 입력해주세요!"
        secondLineLabel.changeTextAttributeColor(fullText: secondLineLabel.text!, changeText: "아이디")
    }
}

//MARK: - User Input Validation

extension IDInputViewController {
    
    func checkIDLengthIsValid() -> Bool {
        
        guard let id = idTextField.text else { return false }
        
        if id.count >= 4 && id.count <= 20 { return true }
        else {
       
            showErrorMessage(message: "아이디는 4자 이상, 20자 이하로 적어주세요.")
            return false
        }
    }
    
    func showErrorMessage(message: String) {
        
        errorLabel.isHidden = false
        errorLabel.text = message
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        errorLabel.textColor = UIColor(named: Constants.Color.appDefaultColor)
        
    }
    
    func checkIDDuplication() {
        
        let url = UserManager.shared.checkUserNameDuplicateURL
        let model = CheckDuplicateRequestDTO(username: idTextField.text!)
        
        UserManager.shared.checkDuplication(requestURL: url,
                                            model: model) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let isNotDuplicate):
                
                if isNotDuplicate {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: Constants.SegueIdentifier.goToNicknameVC, sender: self)
                    }
                }
                else { self.showErrorMessage(message: "이미 사용 중인 아이디입니다. 🥲") }
                
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

