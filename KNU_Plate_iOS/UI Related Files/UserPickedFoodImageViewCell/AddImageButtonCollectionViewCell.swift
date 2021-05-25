import UIKit
import BSImagePicker
import Photos

protocol AddImageDelegate {
    func didPickImagesToUpload(images: [UIImage])
}

// 리뷰 또는 신규 식당 등록 시 사용자가 이미지를 고를 수 있도록 터치하는 "+" 모양의 버튼 Cell

class AddImageButtonCollectionViewCell: UICollectionViewCell {
    
    var delegate: AddImageDelegate!
    
    var selectedAssets: [PHAsset] = [PHAsset]()
    var userSelectedImages: [UIImage] = [UIImage]()
    
    @IBAction func pressedAddButton(_ sender: UIButton) {
                
        /// 기존 선택된 사진 모두 초기화
        selectedAssets.removeAll()
        userSelectedImages.removeAll()
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        let vc = self.window?.rootViewController
        
        vc?.presentImagePicker(imagePicker, select: { (asset) in
            
            
            
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
   
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
  
        }, cancel: { (assets) in
            // User canceled selection.

        }, finish: { (assets) in
            // User finished selection assets.
            
            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
            self.delegate?.didPickImagesToUpload(images: self.userSelectedImages)
        })
     }
    
    func convertAssetToImages() {
        
        if selectedAssets.count != 0 {
            
            for i in 0..<selectedAssets.count {
                
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.deliveryMode = .highQualityFormat
                option.resizeMode = .exact
                
            
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: selectedAssets[i],
                                          targetSize: CGSize(width: 1000, height: 1000),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 1.0)
                let newImage = UIImage(data: data!)
                
                print(data)
                
                self.userSelectedImages.append(newImage! as UIImage)
            }
        }
    }
}
