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
        
        presentActionSheet()
        
        present(self.imagePicker, animated: true, completion: nil)
        
    }
    
    

    @IBAction func pressedLogOutButton(_ sender: UIButton) {
        
        UserManager.shared.logOut { result in
            
            switch result {
            
            case true:
                
                self.presentAlertWithCancelAction(title: "로그아웃 하시겠습니까?", message: "") { selectedOk in
                    
                    if selectedOk {
                        
                        DispatchQueue.main.async {
                            
                            //TODO: - 최초 화면으로 돌아가는거 있어야함
                            //self.popToInitialViewController()
                        }
                        
                    } else { return }
                }
                
            case false:
                self.showToast(message: "일시적 네트워크 오류")
            
            }
        }
        
        
    }
    
    func removeProfileImage() {
        
        profileImageButton.setImage(UIImage(named: "pick profile pic(black)")!, for: .normal)
        initializeProfileImageButton()

        // API 통신
    }
    
    func presentActionSheet() {
        
        let alert = UIAlertController(title: "프로필 사진 변경", message: "", preferredStyle: .actionSheet)
        
        let library = UIAlertAction(title: "앨범에서 선택", style: .default) { _ in
            
            self.initializeImagePicker()
            self.present(self.imagePicker, animated: true)
        }
        
        let remove = UIAlertAction(title: "프로필 사진 제거", style: .default) { _ in
            self.removeProfileImage()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(remove)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func popToInitialViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.welcomeViewController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initialVC)
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
    
    func initializeMedalImage() {
        
        userMedal.image = setUserMedalImage(medalRank: User.shared.medal)
    }
    

    
    func updateProfileImageButton(with image: UIImage) {
        
        profileImageButton.setImage(image, for: .normal)
        profileImageButton.contentMode = .scaleAspectFit
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func initializeImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    
    
}
