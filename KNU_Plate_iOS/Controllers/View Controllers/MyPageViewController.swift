import UIKit
import Alamofire

class MyPageViewController: UIViewController {
    
    
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var userNickname: UILabel!
    @IBOutlet var userMedal: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var logOutButton: UIButton!
    
    lazy var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    
    @IBAction func pressedProfileImageButton(_ sender: UIButton) {
        
        
    }
    
    

    @IBAction func pressedLogOutButton(_ sender: UIButton) {
        
        
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            dismiss(animated: true) {
                
                self.presentAlertWithCancelAction(title: "프로필 사진 변경", message: "선택하신 이미지로 프로필 사진을 변경하시겠습니까?") { selectedOk in
                    
                    if selectedOk {
            
                        self.updateProfileImageButton(with: originalImage)
                        
                        showProgressBar()
                        
                        OperationQueue().addOperation {
                            
                            // API - update user profile
                            
    
                            dismissProgressBar()
                            
                            
                        }
              
                    } else {
                        self.imagePickerControllerDidCancel(self.imagePicker)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

//MARK: - UI Configuration

extension MyPageViewController {
    
    func initialize() {
        

        
        initializeProfileImageButton()
        initializeImagePicker()
    }
    
    func initializeProfileImageButton() {
        
        profileImageButton.isUserInteractionEnabled = true
        profileImageButton.contentMode = .scaleAspectFit
        profileImageButton.layer.masksToBounds = true
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2
    }
    
    func initializeImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    func updateProfileImageButton(with image: UIImage) {
        
        profileImageButton.setImage(image, for: .normal)
        profileImageButton.contentMode = .scaleAspectFit
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    
}
