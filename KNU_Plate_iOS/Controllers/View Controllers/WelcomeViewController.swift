import UIKit
import SnapKit

/// Shows welcome screen of the app
class WelcomeViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "크슐랭가이드"
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = UIColor(named: Constants.Color.appDefaultColor)
        label.sizeToFit()
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
        button.addBounceReactionWithoutFeedback()
        return button
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("아직 회원이 아니신가요?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addBounceReactionWithoutFeedback()
        return button
    }()
    

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setButtonTarget()
    }
}

//MARK: - Basic UI Set Up
extension WelcomeViewController {
    /// Set up labels
    func setupView() {
        // local constants
        let loginButtonWidth: CGFloat = 200
        let loginButtonHeight: CGFloat = 50
        
        // add labels and button
        self.view.addSubview(titleLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        
        // titleLabel snapkit layout
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.7)
        }
        
        // loginButton layer
        loginButton.layer.cornerRadius = 0.5 * loginButtonHeight
        
        // loginButton snapkit layout
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(loginButtonWidth)
            make.height.equalTo(loginButtonHeight)
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.bottom).multipliedBy(0.8)
        }
        
        // registerButton snapkit layout
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    /// Set target of the buttons
    func setButtonTarget() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.loginViewController) else {
            fatalError()
        }
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .crossDissolve
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    @objc func registerButtonTapped(_ sender: UIButton) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.registerViewController) else {
            fatalError()
        }
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .crossDissolve
        self.present(nextViewController, animated: true, completion: nil)
    }
}
