import Foundation

//MARK: - 로그인 시도 후 성공 시 반환되는 Model

struct LoginResponseModel: Decodable {
    
    let accessToken: String
    let refreshToken: String
    let expires: String
    let expires_refresh: String
    
    
}



/*
{
  "accessToken": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiM2MzMDMyY2UtMjFiNS00OTA1LTg2MDctNjI1OWQxZjRhNjQyIiwic3ViIjoiYWNjZXNzX3Rva2VuIiwiaWF0IjoxNjE5MDcxNjIyLCJleHAiOjE2MTkwNzM0MjJ9.WzPEvy7Ca-aTJc2SzteFAugaEjJ1Ds03lw44OQ49aDo",
  "refreshToken": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiM2MzMDMyY2UtMjFiNS00OTA1LTg2MDctNjI1OWQxZjRhNjQyIiwidG9rZW5faWQiOiJjNTQ2NzM2NC1kNDdjLTQ1MjktYjJmOC1kYmU2ZDg0Njk4NTIiLCJzdWIiOiJyZWZyZXNoX3Rva2VuIiwiaWF0IjoxNjE5MDcxNjIyLCJleHAiOjE2MTk2NzY0MjJ9.FAe2qZsudQ0He5qvmwnhe32CrCZ6mJAioJMzaejt7_g",
  "expires": 1619073422518,
  "expires_refresh": 1619676422518
}
*/
