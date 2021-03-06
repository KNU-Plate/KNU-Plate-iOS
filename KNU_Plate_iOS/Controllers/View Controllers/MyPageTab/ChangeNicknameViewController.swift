//import UIKit
//import SnackBar_swift
//
//class ChangeNicknameViewController: UIViewController {
//    
//    @IBOutlet var nicknameTextField: UITextField!
//    @IBOutlet var changeButton: UIButton!
//    @IBOutlet var checkAlreadyInUseButton: UIButton!
//    
//    private var nickname: String?
//    private var didCheckNicknameDuplicate: Bool = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        initialize()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        dismissProgressBar()
//    }
//    
//    
//    @IBAction func pressedCheckDuplicateButton(_ sender: UIButton) {
//        
//        checkIfDuplicate()
//    }
//
//    @IBAction func pressedChangeButton(_ sender: UIButton) {
//        
//        self.view.endEditing(true)
//    
//        if !didCheckNicknameDuplicate {
//            showSimpleBottomAlert(with: "๐ค ๋๋ค์ ์ค๋ณต ํ์ธ์ ๋จผ์ ํด์ฃผ์ธ์.")
//            dismissProgressBar()
//            return
//        }
//        
//        guard let nickname = self.nickname else {
//            showSimpleBottomAlert(with: "๐ค ๋น ์นธ์ด ์๋์ง ํ์ธํด์ฃผ์ธ์.")
//            return
//        }
//        
//        showProgressBar()
//        
//        let editUserModel = EditUserInfoRequestDTO(nickname: nickname)
//        
//        UserManager.shared.updateNickname(with: editUserModel) { result in
//            
//            switch result {
//            
//            case .success(_):
//                
//                self.navigationController?.popViewController(animated: true)
//                
//            case .failure(_):
//                DispatchQueue.main.async {
//                    self.showSimpleBottomAlert(with: "๋๋ค์ ๋ณ๊ฒฝ ์คํจ. ์ ์ ํ ๋ค์ ์๋ํด์ฃผ์ธ์ ๐ฅฒ")
//                }
//            }
//            dismissProgressBar()
//        }
//    }
//    
//    func checkIfDuplicate() {
//        
//        self.view.endEditing(true)
//        
//        if !validateUserInput() { return }
//        
//        let requestURL = UserManager.shared.checkDisplayNameDuplicateURL
//        let checkDuplicateModel = CheckDuplicateRequestDTO(displayName: nickname!)
//        
//        UserManager.shared.checkDuplication(requestURL: requestURL, model: checkDuplicateModel) { [weak self] result in
//            
//            guard let self = self else { return }
//            
//            switch result {
//            
//            case .success(let isNotDuplicate):
//                
//                if isNotDuplicate {
//                
//                    DispatchQueue.main.async {
//                        self.checkAlreadyInUseButton.setTitle("์ฌ์ฉํ์๋ ์ข์ต๋๋ค ๐",
//                                                              for: .normal)
//                        self.didCheckNicknameDuplicate = true
//                    }
//                } else {
//                    
//                    DispatchQueue.main.async {
//                        self.checkAlreadyInUseButton.setTitle("์ด๋ฏธ ์ฌ์ฉ ์ค์ธ ๋๋ค์์๋๋ค ๐ข",
//                                                              for: .normal)
//                        self.didCheckNicknameDuplicate = false
//                    }
//                }
//                
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.showSimpleBottomAlert(with: error.errorDescription)
//                }
//            }
//        }
//    }
//    
//    func validateUserInput() -> Bool {
//        
//        guard let nickname = nicknameTextField.text else {
//            return false
//        }
//        guard !nickname.isEmpty else {
//            showSimpleBottomAlert(with: "๋น ์นธ์ด ์๋์ง ํ์ธํด์ฃผ์ธ์ ๐ฅฒ")
//            return false
//        }
//        guard nickname.count >= 2, nickname.count <= 10 else {
//            showSimpleBottomAlert(with: "๋๋ค์์ 2์ ์ด์, 10์ ์ดํ๋ก ์์ฑํด์ฃผ์ธ์โ๏ธ")
//            return false
//        }
//        self.nickname = nickname
//        return true
//    }
//}
//
////MARK: - UITextFieldDelegate
//
//extension ChangeNicknameViewController: UITextFieldDelegate {
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//        if textField == nicknameTextField {
//            didCheckNicknameDuplicate = false
//            checkAlreadyInUseButton.setTitle("์ค๋ณต ํ์ธ", for: .normal)
//            checkAlreadyInUseButton.titleLabel?.tintColor = UIColor(named: Constants.Color.appDefaultColor)
//        }
//    }
//    
//}
//
////MARK: - UI Configuration
//
//extension ChangeNicknameViewController {
//    
//    func initialize() {
//    
//        initializeTextField()
//        initializeButton()
//    }
//    
//    func initializeTextField() {
//        
//        nicknameTextField.placeholder = User.shared.username
//        nicknameTextField.delegate = self
//    }
//    
//    func initializeButton() {
//        
//        changeButton.layer.cornerRadius = 10
//    }
//}
