import Foundation
import Alamofire

//MARK: - 파일 업로드 및 다운 관련 (파일 폴더 조회 시 사용)

class FileManager {
    
    //MARK: - Singleton
    static let shared: FileManager = FileManager()
    
    //MARK: - API Request URLs
    let searchFileFolderRequestURL      = "\(Constants.API_BASE_URL)file/file_folder"
    
    private init() {}
    
    func searchFileFolder(fileFolderID: String,
                          completion: @escaping (([FileInfo]) -> Void)){
        
        let parameters: Parameters = ["file_folder_id": fileFolderID]
        let headers: HTTPHeaders = ["Authorization": User.shared.accessToken]
       
        AF.request(searchFileFolderRequestURL,
                   method: .get,
                   parameters: parameters,
                   headers: headers).responseJSON { response in
                    
                    guard let statusCode = response.response?.statusCode else { return }
                    
                    switch statusCode {
                    
                    case 200:
                        do {
                            let decodedData = try JSONDecoder().decode([FileInfo].self, from: response.data!)
                            
                            print("FILE MANAGER - searchFileFolder() DECODED DATA: \(decodedData)")
                            
                            completion(decodedData)
                            
                        } catch { print("FILE MANAGER - searchFileFolder() Error decoding: \(error)") }
                        
                    default:
                        print("DEFAULT activated in FILE MANAGER - searchFileFolder()")
                    }
                   }
    }
    
}
