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
                          completion: @escaping ((String) -> Void)){
        // String -> path 를 반환하는 것
        
        
    }
}
