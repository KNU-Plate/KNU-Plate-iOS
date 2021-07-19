import Foundation
import SnackBar_swift

extension UIViewController {
    
    // 확인 버튼을 누를 수 있는 Alert 띄우기
    func presentAlertWithConfirmAction(title: String, message: String, completion: @escaping ((Bool) -> Void)) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default) { pressedOk in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel) { pressedCancel in
            completion(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
    
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 가장 기본적인 Alert 띄우기
    func presentSimpleAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default)
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // 가장 첫 번째 화면으로 돌아가기 - 로그아웃, 회원탈퇴, refreshToken 만료 시에 쓰임
    func popToWelcomeViewController() {
        
        UserManager.shared.resetAllUserInfo()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.welcomeViewController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initialVC)
    }
    
    
    func showToast(message : String, font: UIFont = .systemFont(ofSize: 14.0)) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75,
                                               y: self.view.frame.size.height-150,
                                               width: 150,
                                               height: 35))
        
        toastLabel.backgroundColor = .white
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.layer.borderWidth = 1
        toastLabel.layer.borderColor = UIColor.black.cgColor
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: { toastLabel.alpha = 0.0 },
                       completion: { isCompleted in
                        toastLabel.removeFromSuperview()
                       })
    }
    
    // SnackBar 라이브러리의 message 띄우기
    func showSimpleBottomAlert(with message: String) {
        SnackBar.make(in: self.view,
                      message: message,
                      duration: .lengthLong).show()
    }
    
    // SnackBar 라이브러리의 액션이 추가된 message 띄우기
    func showSimpleBottomAlertWithAction(message: String,
                                         buttonTitle: String,
                                         action: (() -> Void)? = nil) {
        SnackBar.make(in: self.view,
                      message: message,
                      duration: .lengthLong).setAction(
                        with: buttonTitle,
                        action: {
                            action?()
                        }).show()
        
    }
    
    // 테이블뷰 Footer에 Activity Indicator 추가 -> 데이터 추가로 받아올 때 실행
    func createSpinnerFooterView() -> UIView {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
}

