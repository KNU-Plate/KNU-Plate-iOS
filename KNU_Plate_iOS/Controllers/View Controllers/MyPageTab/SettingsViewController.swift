import UIKit
import SnackBar_swift

class SettingsViewController: UIViewController {

    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var unregisterButton: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initialize()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initialize()
    
    }
    
    @IBAction func pressedLogOutButton(_ sender: UIButton) {
     
        self.presentAlertWithConfirmAction(title: "정말 로그아웃 하시겠습니까?",
                                          message: "") { selectedOk in
            
            if selectedOk {
                
                UserManager.shared.logOut { result in
                    
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.popToWelcomeViewController()
                        }
                    case .failure(let error):
                        self.showSimpleBottomAlertWithAction(message: error.errorDescription,
                                                             buttonTitle: "재시도") {
                            self.pressedLogOutButton(self.logOutButton)
                        }
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func pressedUnregisterButton(_ sender: UIButton) {
        
        self.presentAlertWithConfirmAction(title: "정말 회원 탈퇴를 하시겠습니까?",
                                          message: "다시 한 번만 더 생각해주세요 😥") { selectedOk in
            
            if selectedOk {
                
                UserManager.shared.unregisterUser { result in
                    
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.popToWelcomeViewController()
                        }
                    case .failure(let error):
                        self.showSimpleBottomAlertWithAction(message: error.errorDescription,
                                                             buttonTitle: "재시도",
                                                             action: {
                                                                self.pressedUnregisterButton(self.unregisterButton)
                                                             })
                    }
                }
            }
        }
    }
    func initialize() {
        
        userNicknameLabel.text = User.shared.username
    }


}
