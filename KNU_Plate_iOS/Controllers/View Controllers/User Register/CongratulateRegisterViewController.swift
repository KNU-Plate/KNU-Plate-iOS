import UIKit
import Lottie

class CongratulateRegisterViewController: UIViewController {
    
    let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        playAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.changeRootViewControllerToMain()
        }
    }
    
    func playAnimation() {
        
        animationView.animation = Animation.named("congratulate")
        
        animationView.backgroundColor = .white
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    func changeRootViewControllerToMain() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: Constants.StoryboardID.mainTabBarController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
