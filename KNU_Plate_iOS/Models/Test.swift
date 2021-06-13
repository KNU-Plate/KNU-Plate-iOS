import Foundation

struct Test {
    
    static let shared: Test = Test()
    
    
    private init() { }
    
    
    func login() {
        
        let username = "alexding"
        let password = "123456789"
        
        let loginInfoModel = LoginInfoModel(username: username, password: password)
        
        UserManager.shared.logIn(with: loginInfoModel)
        
    }
    
}


extension Test {
    
    
    
    
    
}
