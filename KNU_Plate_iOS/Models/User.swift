import Foundation

class User {
    
    //MARK: - Singleton
    static var shared: User = User()
    
    /// user unique ID
    var id: String
    
    ///
    var username: String
    
    /// user password
    var password: String
    
    /// nickname
    var displayName: String
    
    /// user email address (...@knu.ac.kr)
    var email: String
    
    /// registered date
    var dateCreated: String
    
    /// 활성화 상태 여부 (Y/N)
    var isActive: String
     
    /// variable for medal image
    var ranking: Int
    
    var accessToken: String
    
    var refreshToken: String
    
    
    
    private init() {
        self.id = ""
        self.username = ""
        self.password = ""
        self.displayName = ""
        self.email = ""
        self.dateCreated = ""
        self.isActive = ""
        self.ranking = 3
        self.accessToken = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiM2MzMDMyY2UtMjFiNS00OTA1LTg2MDctNjI1OWQxZjRhNjQyIiwic3ViIjoiYWNjZXNzX3Rva2VuIiwiaWF0IjoxNjE5NzczNDU2LCJleHAiOjE2MTk3NzUyNTZ9.HwFBJXZmvubH6I3RfsTEA05p8mxUYOSXZyR7x0ES0Iw"
        self.refreshToken = ""
    }

    enum Codingkeys: String, CodingKey {

        case password
        case username = "user_name"
        case displayName = "display_name"
        case email = "mail_address"
        case dateCreated = "date_create"
        case isActive = "is_active"
    }
    
    
}
