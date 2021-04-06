import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "크슐랭가이드"
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = UIColor(named: Constants.Color.appDefaultColor)
        return label
    }()
    
    let stackView: TextFieldStackView = {
        let stackView = TextFieldStackView()
        stackView.addTextField(placeholder: "아이디 입력", isSecureText: false)
        stackView.addTextField(placeholder: "비밀번호 입력", isSecureText: true)
        return stackView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
        button.addBounceReactionWithoutFeedback()
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .highlighted)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: Constants.Color.appDefaultColor)
        button.addBounceReactionWithoutFeedback()
        return button
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupView()
        setButtonTarget()
    }
}

//MARK: - Basic UI Set Up
extension LoginViewController {
    /// Set up text field delegate
    func setupTextFields() {
        let textField1 = stackView.arrangedSubviews[0] as! UITextField
        let textField2 = stackView.arrangedSubviews[1] as! UITextField
        textField1.delegate = self
        textField2.delegate = self
    }
    
    /// Set up views
    func setupView() {
        // local constants
        let textFieldHeight: CGFloat = 30
        let textFieldWidth: CGFloat = UIScreen.main.bounds.width - 80
        let loginButtonWidth: CGFloat = 180
        let loginButtonHeight: CGFloat = 40
        
        // add label and stack view
        self.view.addSubview(titleLabel)
        self.view.addSubview(stackView)
        self.view.addSubview(loginButton)
        self.view.addSubview(backButton)
        
        // titleLabel snapkit layout
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.3)
        }
        
        // stackView snapkit layout
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
        }
        
        for i in 0..<2 {
            let textField = stackView.arrangedSubviews[i] as! UITextField
            // stackView's subview(textfield) layer
            textField.layer.cornerRadius = 0.5*textFieldHeight
            // stackView's subview(textfield) snapkit layout
            textField.snp.makeConstraints { (make) in
                make.height.equalTo(textFieldHeight)
                make.width.equalTo(textFieldWidth)
            }
            // stackView's subview(textfield) padding
            textField.setPaddingPoints(left: 10, right: 10)
        }
        
        // loginButton layer
        loginButton.layer.cornerRadius = 0.5*loginButtonHeight
        
        // loginButton snapkit layout
        loginButton.snp.makeConstraints { (make) in
            make.width.equalTo(loginButtonWidth)
            make.height.equalTo(loginButtonHeight)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.view.snp.bottom).multipliedBy(0.9)
        }
        
        // backButton layer
        backButton.layer.cornerRadius = 0.5*loginButtonHeight
        
        // backButton snapkit layout
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(loginButtonHeight)
            make.centerX.equalTo(loginButton.snp.left).multipliedBy(0.5)
            make.centerY.equalTo(loginButton)
        }
    }
    
    /// Set target of the buttons
    func setButtonTarget() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing: \(textField.text ?? "empty")")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("textFieldDidEndEditing: \(textField.text ?? "empty")")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn \(textField.text ?? "empty")")
        textField.resignFirstResponder()
        return true
    }
}
