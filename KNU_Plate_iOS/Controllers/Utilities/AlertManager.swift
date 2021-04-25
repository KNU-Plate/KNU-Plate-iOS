import UIKit

class AlertManager {
    
    class func createAlertMessage(_ title: String, _ message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    class func createAlertMessage(_ title: String, with errorMessage: String) -> UIAlertController {
        
        let alertMessage = errorMessage
        let alert = UIAlertController(title: title, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
        return alert
    }
    
    
    
}


//func simpleAlert(vc: UIViewController, title: String, message msg: String, handler: ((UIAlertAction) -> Void)? = nil) {
//    let alert = UIAlertController(title : title, message: msg,
//                                  preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "확인", style: .cancel, handler: handler)
//    alert.addAction(okAction)
//    vc.present(alert, animated: false, completion: nil)
//}
