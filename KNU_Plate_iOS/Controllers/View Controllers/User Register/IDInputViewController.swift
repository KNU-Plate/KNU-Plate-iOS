import UIKit
import TextFieldEffects

class IDInputViewController: UIViewController {

    @IBOutlet var firstLineLabel: UILabel!
    @IBOutlet var secondLineLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var idTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
    }
    
    
    func initialize() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    
        initializeLabels()
    }
  
    func initializeLabels() {
        
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
