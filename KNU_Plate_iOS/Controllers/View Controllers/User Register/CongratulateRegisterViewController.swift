import UIKit
import Lottie

class CongratulateRegisterViewController: UIViewController {
    
    @IBOutlet var congratulateLabel: UILabel!
    @IBOutlet var animationView: AnimationView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeLabel()
        playAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.changeRootViewControllerToMain()
        }
    }
    
    func initializeLabel() {
        
        congratulateLabel.text = "크슐랭가이드 회원가입을 축하합니다!"
        congratulateLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        congratulateLabel.textColor = .darkGray
        congratulateLabel.changeTextAttributeColor(fullText: congratulateLabel.text!, changeText: "크슐랭가이드")
    }
    
    func playAnimation() {
        
        animationView.animation = Animation.named("congratulate")
        
        animationView.backgroundColor = .white
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func changeRootViewControllerToMain() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: Constants.StoryboardID.mainTabBarController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
