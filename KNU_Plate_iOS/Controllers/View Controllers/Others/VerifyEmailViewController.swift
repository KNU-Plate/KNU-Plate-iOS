import UIKit

class VerifyEmailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var resendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissProgressBar()
    }
    

    @IBAction func pressedResendEmailButton(_ sender: UIButton) {
        
        //API 구현 예정
        
    }
}

//MARK: - Initialization & UI Configuration

extension VerifyEmailViewController {
    
    func initialize() {
        
        initializeDetailLabel()
        initializeResendEmailButton()
        initializeNavigationBar()
    }
    
    func initializeDetailLabel() {
        
        detailLabel.adjustsFontSizeToFitWidth = true
    }
    
    func initializeResendEmailButton() {
        
        resendEmailButton.layer.cornerRadius = resendEmailButton.frame.height / 2
    }
    
    func initializeNavigationBar() {
        
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
        navItem.leftBarButtonItem = navBarButton
        navigationBar.items = [navItem]
        
    }
}
