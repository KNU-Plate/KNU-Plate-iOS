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
        
        let imagePicker = ImagePickerController()
 
 
        
        
        imagePicker.presentImagePicker(imagePicker, select: { (asset) in
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
        })
        
        
    }
    
    func convertAssetToImages() {
        
        if selectedAssets.count != 0 {
            
            for i in 0..<selectedAssets.count {
                
                let imageManager = PHImageManager.default()
                let option = PHImageR
            }
            
        }
        
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension AddImageButtonCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImages = info[UIImagePickerController.InfoKey.editedImage] as? [UIImage] else {
            return
        }
        
        self.userSelectedImages = selectedImages
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
