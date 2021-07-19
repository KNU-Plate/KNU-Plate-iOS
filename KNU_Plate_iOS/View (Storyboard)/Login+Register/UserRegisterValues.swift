import Foundation

class UserRegisterValues {
    
    static var shared: UserRegisterValues = UserRegisterValues()
    
    private init() {}
    
    var registerID: String = ""
    var registerNickname: String = ""
    var registerPassword: String = ""
    var registerEmail: String = ""
    
}
