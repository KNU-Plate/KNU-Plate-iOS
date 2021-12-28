import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    let fontSize: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        dismissProgressBar()
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
                self.showSimpleBottomAlert(with: "로그인 성공 🎉")
                self.dismiss(animated: true)
                UserManager.shared.loadUserProfileInfo { _ in }
                
            case .failure(let error):
                // 이 부분은 로그인 어떤 에러인지 정확하게 표기하는게 좋을듯
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    @IBAction func pressedRegisterLabel(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "UserRegister", bundle: nil)
        let navController = storyboard.instantiateViewController(identifier: Constants.StoryboardID.registerNavigationController) as! RegisterNavigationController
        navController.modalPresentationStyle = .overFullScreen
        self.present(navController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func pressedFindIDButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Find_PW+ID", bundle: nil)
        
        guard let findIDVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.findIDViewController) as? FindIDViewController else { return }
        
        presentPanModal(findIDVC)
        
    }
    
    
    @IBAction func pressedFindPWButton(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Find_PW+ID", bundle: nil)
        
        guard let findPWVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.findPWViewController) as? FindPasswordViewController else { return }
        
        presentPanModal(findPWVC)
        
    }
    
    
    
}

//MARK: - UI Configuration & Initialization

extension WelcomeViewController {
    
    func initialize() {
        
        configureTextFields()
        configureLoginButton()
        configureNavigationBar()
    }
    
    func configureTextFields() {
        

        idTextField.borderStyle = .none
        idTextField.backgroundColor = .systemGray6
        idTextField.layer.cornerRadius = idTextField.frame.height / 2
        idTextField.textAlignment = .center
        idTextField.adjustsFontSizeToFitWidth = true
        idTextField.minimumFontSize = 12
        idTextField.layer.masksToBounds = true
        idTextField.font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        
        idTextField.placeholder = "아이디 입력"
        
        passwordTextField.borderStyle = .none
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.layer.cornerRadius = idTextField.frame.height / 2
        passwordTextField.textAlignment = .center
        passwordTextField.adjustsFontSizeToFitWidth = true
        passwordTextField.minimumFontSize = 12
        passwordTextField.layer.masksToBounds = true
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
    
    func configureNavigationBar() {
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 150
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight,
                                                          width: view.bounds.size.width, height: 50))
        navigationBar.tintColor = .lightGray
        navigationBar.setBackgroundImage(UIImage(),
                                         for: .default)
        navigationBar.shadowImage = UIImage()
        self.view.addSubview(navigationBar)
        
        let navItem = UINavigationItem(title: "")
        let navBarButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                           target: self,
                                           action: #selector(dismissVC))
        navItem.rightBarButtonItem = navBarButton
        navigationBar.items = [navItem]
    }
    
}
