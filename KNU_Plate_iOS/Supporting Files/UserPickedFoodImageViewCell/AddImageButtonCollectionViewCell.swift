import UIKit

// 리뷰 또는 신규 식당 등록 시 사용자가 이미지를 고를 수 있도록 터치하는 "+" 모양의 버튼 Cell

class AddImageButtonCollectionViewCell: UICollectionViewCell {
    
    @IBAction func pressedAddButton(_ sender: UIButton) {
        
        print("pre sed Add button")
        
        let actionSheet = UIAlertController(title: "먹은 음식 사진 고르기",
                                            message: "맛있게 드신 음식 사진을 업로드해 주세요! ",
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "사진 찍기",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentCamera()
                                            }))
        actionSheet.addAction(UIAlertAction(title: "앨범에서 선택",
                                            style: .default,
                                            handler: { [weak self] _ in
                                                self?.presentPhotoPicker()
                                            }))
        
        self.window?.rootViewController?.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
       
    }
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension AddImageButtonCollectionViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
