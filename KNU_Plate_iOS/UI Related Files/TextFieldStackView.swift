import UIKit

class TextFieldStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 10
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTextField(placeholder: String, isSecureText: Bool) {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.isSecureTextEntry = isSecureText
        self.addArrangedSubview(textField)
    }
}
