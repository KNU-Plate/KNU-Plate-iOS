import Foundation

struct RestaurantImageResponseModel: Decodable {
    let fileID: String
    let index: Int
    let path: String
    let originalName: String
    let fileFolderID: String
    let uploader: String
    let size: String
    let fileExtension: String
    let dateCreated: String
    let checksum: String?
    
    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case index, path
        case originalName = "original_name"
        case fileFolderID = "file_folder_id"
        case uploader, size
        case fileExtension = "extension"
        case dateCreated = "date_create"
        case checksum
    }
}
