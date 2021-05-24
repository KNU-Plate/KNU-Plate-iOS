import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var userNicknameLabel: UILabel!
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initialize()

    }
    
    @IBAction func pressedChangeNickname(_ sender: UIButton) {
    }
    
    @IBAction func pressedChangePassword(_ sender: UIButton) {
        
        
    }
    
    
    func initialize() {
        
        userNicknameLabel.text = User.shared.displayName
        
    }


}
