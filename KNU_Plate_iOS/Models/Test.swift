import Foundation

struct Test {
    
    static let shared: Test = Test()
    
    
    private init() { }
    
    
    func login() {
        
        let username = "alexding"
        let password = "123456789"
        
        let loginInfoModel = LoginInfoModel(username: username, password: password)
        
        UserManager.shared.logIn(with: loginInfoModel) { result in
            
            switch result {
            
            case .success(_):
                
                UserManager.shared.loadUserProfileInfo() { result in }
                
            case .failure(let error):
                print("Test - Error in logging user in with error: \(error.errorDescription)")
                
            }
            
            
        }
        
    }
    
}


extension Test {
    
    
    
    
    
}
