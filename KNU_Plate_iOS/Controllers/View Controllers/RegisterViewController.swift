import UIKit
import SnapKit

class RegisterViewController: UIViewController {
    
    // MARK: - Properties Declaration
    private let picker = UIImagePickerController()
    
    var idChecked: Bool = false
    var nicknameChecked: Bool = false
    
    // MARK: - Views Declaration
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "크슐랭가이드"
        label.font = UIFont.systemFont(ofSize: 45)
        label.textColor = UIColor(named: Constants.Color.appDefaultColor)
        return label
    }()
    
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pick profile pic(black)"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.addBounceReactionWithoutFeedback()
        return button
    }()
    
    let stackView: TextFieldStackView = {
        let stackView = TextFieldStackView()
        stackView.addTextField(placeholder: "아이디 입력", isSecureText: false)
        stackView.addTextField(placeholder: "닉네임 입력", isSecureText: false)
        stackView.addTextField(placeholder: "비밀번호 입력", isSecureText: true)
        stackView.addTextField(placeholder: "비밀번호 확인", isSecureText: true)
        stackView.addTextField(placeholder: "학교 이메일 입력", isSecureText: false)
        return stackView
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 가입하기", for: .normal)
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setupTextFieldDelegate()
        setupView()
        addButtonsTarget()
    }
}

// MARK: - Basic UI Set Up
extension RegisterViewController {
    /// Set up text field delegate
    func setupTextFieldDelegate() {
        for i in 0..<5 {
            let textField = stackView.arrangedSubviews[i] as! UITextField
            textField.delegate = self
        }
    }
    
    /// Set up views
    func setupView() {
        // local constants
        let textFieldHeight: CGFloat = 30
        let textFieldWidth: CGFloat = UIScreen.main.bounds.width - 80
        let registerButtonWidth: CGFloat = 180
        let registerButtonHeight: CGFloat = 40
        
        // add label and stack view
        self.view.addSubview(titleLabel)
        self.view.addSubview(profileImageButton)
        self.view.addSubview(stackView)
        self.view.addSubview(registerButton)
        self.view.addSubview(backButton)
        
        // titleLabel snapkit layout
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.3)
        }
        
        // profileImageView snapkit layout
        profileImageButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
        }
        
        // stackView snapkit layout
        stackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageButton.snp.bottom).offset(25)
        }
        
        for i in 0..<5 {
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
        
        // registerButton layer
        registerButton.layer.cornerRadius = 0.5*registerButtonHeight
        
        // loginButton snapkit layout
        registerButton.snp.makeConstraints { (make) in
            make.width.equalTo(registerButtonWidth)
            make.height.equalTo(registerButtonHeight)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.view.snp.bottom).multipliedBy(0.9)
        }
        
        // backButton layer
        backButton.layer.cornerRadius = 0.5*registerButtonHeight
        
        // backButton snapkit layout
        backButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(registerButtonHeight)
            make.centerX.equalTo(registerButton.snp.left).multipliedBy(0.5)
            make.centerY.equalTo(registerButton)
        }
    }
    
    /// Set target of buttons
    func addButtonsTarget() {
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        profileImageButton.addTarget(self, action: #selector(touchToPickPhoto(_:)), for: .touchUpInside)
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func touchToPickPhoto(_ sender: UIButton) {
        let alert = UIAlertController(title: "선택", message: "프로필 사진을 어디서 가져올지 선택해주세요", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { _ in
            self.openLibrary()
        }
        let camera = UIAlertAction(title: "카메라", style: .default) { _ in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        library.setValue(UIColor(named: Constants.Color.appDefaultColor), forKey: "titleTextColor")
        camera.setValue(UIColor(named: Constants.Color.appDefaultColor), forKey: "titleTextColor")
        cancel.setValue(UIColor(named: Constants.Color.appDefaultColor), forKey: "titleTextColor")
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageButton.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageButton.setImage(image, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === stackView.arrangedSubviews[0] {
            idChecked = false
        } else if textField === stackView.arrangedSubviews[1] {
            nicknameChecked = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === stackView.arrangedSubviews[0] {
            // textField is id text field
            // 아이디 중복 확인 *통신*
            // 통신 결과 중복 아니면 var idChecked: Bool = true
            // -> 회원가입 버튼 누를때 true여야 가입진행
            // -> 에디팅이 시작되면 false로 바꿔줘야함
        } else if textField === stackView.arrangedSubviews[1] {
            // textField is nickname text field
            // 닉네임 중복 확인 *통신*
            // 통신 결과 중복 아니면 var nicknameChecked: Bool = true
            // -> 회원가입 버튼 누를때 true여야 가입진행
            // -> 에디팅이 시작되면 false로 바꿔줘야함
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === stackView.arrangedSubviews[0] {
            // textField is id text field
            stackView.arrangedSubviews[1].becomeFirstResponder()
        } else if textField === stackView.arrangedSubviews[1] {
            // textField is nickname text field
            stackView.arrangedSubviews[2].becomeFirstResponder()
        } else if textField === stackView.arrangedSubviews[2] {
            // textField is password text field
            stackView.arrangedSubviews[3].becomeFirstResponder()
        } else if textField === stackView.arrangedSubviews[3] {
            // textField is confirm text field
            stackView.arrangedSubviews[4].becomeFirstResponder()
        } else if textField === stackView.arrangedSubviews[4] {
            // textField is email text field
            textField.resignFirstResponder()
        }
        return true
    }
}
