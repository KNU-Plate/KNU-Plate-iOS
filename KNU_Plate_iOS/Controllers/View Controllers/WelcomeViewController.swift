import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    let fontSize: CGFloat = 16
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    
    @IBAction func pressedLoginButton(_ sender: UIButton) {
        
        guard let id = idTextField.text, let password = passwordTextField.text else { return }
        guard id.count > 0, password.count > 0 else { return }
        
        showProgressBar()
        
        let loginModel = LoginRequestDTO(username: id, password: password)
        
        UserManager.shared.logIn(with: loginModel) { [weak self] result in
            
            dismissProgressBar()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.goToHomeScreen()
//                UserManager.shared.loadUserProfileInfo
                
            case .failure(let error):
                // 이 부분은 로그인 어떤 에러인지 정확하게 표기하는게 좋을듯
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
        
    }
    
    @IBAction func pressedRegisterLabel(_ sender: UIButton) {
    }
}

//MARK: - UI Configuration & Initialization

extension WelcomeViewController {
    
    func initialize() {
        
        configureTextFields()
        configureLoginButton()
    }
    
    func configureTextFields() {
        

        idTextField.borderStyle = .none
        idTextField.backgroundColor = .systemGray6
        idTextField.layer.cornerRadius = idTextField.frame.height / 2
        idTextField.textAlignment = .center
        idTextField.adjustsFontSizeToFitWidth = true
        idTextField.minimumFontSize = 12
        idTextField.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        
        idTextField.placeholder = "아이디 입력"
        
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.layer.cornerRadius = idTextField.frame.height / 2
        passwordTextField.textAlignment = .center
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.minimumFontSize = 12
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        passwordTextField.placeholder = "비밀번호 입력"
        
    }
    
    func configureLoginButton() {
        
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: fontSize + 2, weight: .semibold)
        loginButton.addBounceReactionWithoutFeedback()
    }
    
}





//import UIKit
//import SnapKit
//
///// Shows welcome screen of the app
//class WelcomeViewController: UIViewController {
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "크슐랭가이드"
//        label.font = UIFont.systemFont(ofSize: 45)
//        label.textColor = UIColor(named: Constants.Color.appDefaultColor)
//        return label
//    }()
//
//    let loginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("로그인", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//        button.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
//        button.addBounceReactionWithoutFeedback()
//        return button
//    }()
//
//    let registerButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("아직 회원이 아니신가요?", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        button.addBounceReactionWithoutFeedback()
//        return button
//    }()
//
//    //MARK: - View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        setButtonTarget()
//    }
//}
//
////MARK: - Basic UI Set Up
//extension WelcomeViewController {
//    /// Set up views
//    func setupView() {
//        // local constants
//        let loginButtonWidth: CGFloat = 200
//        let loginButtonHeight: CGFloat = 50
//
//        // add labels and button
//        self.view.addSubview(titleLabel)
//        self.view.addSubview(loginButton)
//        self.view.addSubview(registerButton)
//
//        // titleLabel snapkit layout
//        titleLabel.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview().multipliedBy(0.7)
//        }
//
//        // loginButton layer
//        loginButton.layer.cornerRadius = 0.5*loginButtonHeight
//
//        // loginButton snapkit layout
//        loginButton.snp.makeConstraints { (make) in
//            make.width.equalTo(loginButtonWidth)
//            make.height.equalTo(loginButtonHeight)
//            make.centerX.equalToSuperview()
//            make.centerY.equalTo(self.view.snp.bottom).multipliedBy(0.8)
//        }
//
//        // registerButton snapkit layout
//        registerButton.snp.makeConstraints { (make) in
//            make.top.equalTo(loginButton.snp.bottom).offset(10)
//            make.centerX.equalToSuperview()
//        }
//    }
//
//    /// Set target of the buttons
//    func setButtonTarget() {
//        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
//        registerButton.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
//    }
//
//    @objc func loginButtonTapped(_ sender: UIButton) {
//        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.loginViewController) else {
//            fatalError()
//        }
//        nextViewController.modalPresentationStyle = .fullScreen
//        nextViewController.modalTransitionStyle = .crossDissolve
//        self.present(nextViewController, animated: true, completion: nil)
//    }
//
//    @objc func registerButtonTapped(_ sender: UIButton) {
//        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.registerViewController) else {
//            fatalError()
//        }
//        nextViewController.modalPresentationStyle = .fullScreen
//        nextViewController.modalTransitionStyle = .crossDissolve
//        self.present(nextViewController, animated: true, completion: nil)
//    }
//}
