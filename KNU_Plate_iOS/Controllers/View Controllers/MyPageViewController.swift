import UIKit
import Alamofire
import SnackBar_swift

class MyPageViewController: UIViewController {
    

    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var userNickname: UILabel!
    @IBOutlet var userMedal: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var logOutButton: UIButton!
    
    lazy var imagePicker = UIImagePickerController()
    
    var tableViewOptions: [String] = ["개발자에게 건의사항 보내기","설정","서비스 이용약관"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initialize()
        loadUserProfileInfo()
    }
    
    @IBAction func pressedProfileImageButton(_ sender: UIButton) {
        
        presentActionSheet()
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
    
    
    func popToWelcomeViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialVC = storyboard.instantiateViewController(identifier: Constants.StoryboardID.welcomeViewController)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(initialVC)
    }
}

//MARK: - API Networking

extension MyPageViewController {
    
    func loadUserProfileInfo() {
        
        UserManager.shared.loadUserProfileInfo { result in
            
            switch result {
            case true:
        
                DispatchQueue.main.async {
                    
                    self.userNickname.text = User.shared.displayName
                    self.userMedal.image = setUserMedalImage(medalRank: User.shared.medal)
                    
                    if let profileImage = User.shared.profileImage {
                        
                        self.profileImageButton.setImage(profileImage, for: .normal)
                    }
                }
            case false:
                SnackBar.make(in: self.view, message: "프로필 정보 불러오기 실패", duration: .lengthLong).show()
            }
        }
    }
    
    func removeProfileImage() {
        
        UserManager.shared.removeProfileImage { result in
            
            switch result {
            
            case true:
                SnackBar.make(in: self.view, message: "프로필 사진 제거 성공 🎉", duration: .lengthLong).show()
                DispatchQueue.main.async {
                    self.profileImageButton.setImage(UIImage(named: "pick profile pic(black)")!, for: .normal)
                    self.initializeProfileImageButton()
                    User.shared.profileImage = nil
                }
            case false:
                SnackBar.make(in: self.view, message: "프로필 이미지 변경에 실패하였습니다.", duration: .lengthLong).show()
            }
        }
    }
    
    @IBAction func pressedLogOutButton(_ sender: UIButton) {
        
        UserManager.shared.logOut { result in
            
            switch result {
            case true:
                self.presentAlertWithCancelAction(title: "로그아웃 하시겠습니까?", message: "") { selectedOk in
                    
                    if selectedOk {
    
                        DispatchQueue.main.async {
                            self.popToWelcomeViewController()
                        }
                    } else { return }
                }
            case false:
                SnackBar.make(in: self.view, message: "일시적 네트워크 오류", duration: .lengthLong).show()
            }
        }
    }
    
    func updateProfileImage(with image: UIImage) {
        
        let imageData = image.jpegData(compressionQuality: 1.0)!
        let model = EditUserInfoModel(userProfileImage: imageData)
        
        UserManager.shared.updateProfileImage(with: model) { result in
            
            switch result {
            
            case true:
                SnackBar.make(in: self.view, message: "프로필 사진 변경 성공 🎉", duration: .lengthLong).show()
                DispatchQueue.main.async {
                    self.updateProfileImageButton(with: image)
                    User.shared.profileImage = image
                }
            case false:
                SnackBar.make(in: self.view, message: "프로필 사진 변경에 실패하였습니다.", duration: .lengthLong).show()
            }
        }
        
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            dismiss(animated: true) {
                self.presentAlertWithCancelAction(title: "프로필 사진 변경", message: "선택하신 이미지로 프로필 사진을 변경하시겠습니까?") { selectedOk in
                
                    if selectedOk {
                        
                        showProgressBar()
                        self.updateProfileImage(with: originalImage)
                        dismissProgressBar()

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

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.myPageCell, for: indexPath)
        
        cell.textLabel?.font = .systemFont(ofSize: 17)
        
        switch indexPath.row {
        
        case 0:
            cell.textLabel?.text = tableViewOptions[indexPath.row]
        case 1:
            cell.textLabel?.text = tableViewOptions[indexPath.row]
        case 2:
            cell.textLabel?.text = tableViewOptions[indexPath.row]
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            guard let vc = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.sendDeveloperMessageViewController) else { return }
            pushViewController(with: vc)
        case 1:
            guard let vc = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.settingsViewController) else { return }
            pushViewController(with: vc)
        case 2:
            guard let vc = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.termsAndConditionsViewController) else { return }
            pushViewController(with: vc)
        default: return
        }
    }
    
    func pushViewController(with vc: UIViewController) {
        
        navigationController?.pushViewController(vc, animated: true)
    }
   
}

//MARK: - UI Configuration

extension MyPageViewController {
    
    func initialize() {
        
        initializeTableView()
        initializeProfileImageButton()
        initializeMedalImage()
        initializeImagePicker()
    }
    
    func initializeTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
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
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func initializeImagePicker() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
    }
    
    
    
}
