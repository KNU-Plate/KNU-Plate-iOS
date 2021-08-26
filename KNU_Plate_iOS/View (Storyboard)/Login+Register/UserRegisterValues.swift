import Foundation

class UserRegisterValues {
    
    static var shared: UserRegisterValues = UserRegisterValues()
    
    private init() {}
    
    var registerID: String = ""
    var registerPassword: String = ""

}
