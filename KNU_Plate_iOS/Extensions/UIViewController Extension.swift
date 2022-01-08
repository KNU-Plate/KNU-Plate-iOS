import Foundation
import SnackBar_swift
import SafariServices

//MARK: - Alert Methods

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
    
    func showLoginNeededAlert(message: String) {
        showSimpleBottomAlertWithAction(message: message,
                                        buttonTitle: "로그인") {
            self.presentWelcomeVC()
        }
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

//MARK: - VC Router

extension UIViewController {
    
    
    // 가장 첫 번째 화면으로 돌아가기 - 로그아웃, 회원탈퇴, refreshToken 만료 시에 쓰임
    @objc func popToWelcomeViewController() {
        
        UserManager.shared.resetAllUserInfo()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.welcomeViewController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initialVC, parentVC: self)
    }
    
    @objc func presentWelcomeVC() {
        
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        
        guard let welcomeVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.welcomeViewController) as? WelcomeViewController else { return }
        
        welcomeVC.modalPresentationStyle = .overFullScreen
        self.present(welcomeVC, animated: true)
    }
    
    @objc func logOutUser() {
        UserManager.shared.logOut { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showSimpleBottomAlertWithAction(
                        message: "장시간 사용하지 않아 자동 로그아웃되었습니다. 다시 로그인 하시기 바랍니다.",
                        buttonTitle: "로그인"
                    ) { self.presentWelcomeVC() }
                }
            case .failure(_):
                UserManager.shared.resetAllUserInfo()
            }
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentSafariView(with url: URL) {
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
    
}

//MARK: - Observers

extension UIViewController {
    
    func createWelcomeVCObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentWelcomeVC),
                                               name: .presentWelcomeVC,
                                               object: nil)
    }
    
    func createRefreshTokenExpirationObserver() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(logOutUser),
                                               name: .refreshTokenExpired,
                                               object: nil)
        
    }
}
