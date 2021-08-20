import UIKit
import Alamofire
import SnackBar_swift
import EasyTipView

class MyPageViewController: UIViewController {
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var userNickname: UILabel!
    @IBOutlet var userMedal: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoButton: UIButton!
    
    lazy var imagePicker = UIImagePickerController()
    
    lazy var preferences = EasyTipView.Preferences()
    var tipView: EasyTipView?
    var tipViewIsVisible: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        tipView = EasyTipView(text: "금메달: 리뷰 50개 이상 작성\n은메달: 리뷰 10개 이상 작성\n동메달: 리뷰 0회 이상",
                                  preferences: preferences,
                                  delegate: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
    
    @IBAction func pressedProfileImageButton(_ sender: UIButton) {
        
        presentActionSheet()
    }
    
    @IBAction func pressedInfoButton(sender: UIButton) {
        
        if tipViewIsVisible {
            tipView?.dismiss()
            tipViewIsVisible = false
        } else {
            tipView?.show(forView: self.infoButton,
                          withinSuperview: self.view)
            tipViewIsVisible = true
            
        }
    }
    
    func presentActionSheet() {
        
        let alert = UIAlertController(title: "프로필 사진 변경",
                                      message: "",
                                      preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "앨범에서 선택",
                                    style: .default) { _ in
            
            self.initializeImagePicker()
            self.present(self.imagePicker, animated: true)
        }
        let remove = UIAlertAction(title: "프로필 사진 제거",
                                   style: .default) { _ in
            
            self.presentAlertWithConfirmAction(title: "프로필 사진 제거",
                                              message: "정말로 제거하시겠습니까?") { selectedOk in
                
                if selectedOk { self.removeProfileImage() }
                else { return }
            }
        }
        let cancel = UIAlertAction(title: "취소",
                                   style: .cancel,
                                   handler: nil)
        
        alert.addAction(library)
        alert.addAction(remove)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - API Networking

extension MyPageViewController {
    
    func removeProfileImage() {
        
        UserManager.shared.removeProfileImage { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(_):
                self.showSimpleBottomAlert(with: "프로필 사진 제거 성공 🎉")
                DispatchQueue.main.async {
                    self.profileImageButton.setImage(UIImage(named: Constants.Images.pickProfileImage)!, for: .normal)
                    self.initializeProfileImageButton()
                    User.shared.profileImage = nil
                }
            case .failure(_):
                self.showSimpleBottomAlert(with: "프로필 이미지 제거에 실패하였습니다. 다시 시도해주세요 🥲")

            }
        }
    }

    func updateProfileImage(with image: UIImage) {
        
        let imageData = image.jpegData(compressionQuality: 1.0)!
        let model = EditUserInfoRequestDTO(userProfileImage: imageData)
        
        UserManager.shared.updateProfileImage(with: model) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.showSimpleBottomAlert(with: "프로필 사진 변경 성공 🎉")
                DispatchQueue.main.async {
                    self.updateProfileImageButton(with: image)
                    User.shared.profileImage = image
                }
            case .failure(_):
                self.showSimpleBottomAlert(with: "프로필 사진 변경에 실패하였습니다. 다시 시도해주세요 🥲")
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            dismiss(animated: true) {
                self.presentAlertWithConfirmAction(title: "프로필 사진 변경", message: "선택하신 이미지로 프로필 사진을 변경하시겠습니까?") { selectedOk in
                
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
        return Constants.StoryboardID.myPageVCOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.myPageCell, for: indexPath) as? MyPageTableViewCell else {
            fatalError()
        }
        
        cell.settingsTitleLabel.text = Constants.StoryboardID.myPageVCOptions[indexPath.row]
        cell.leftImageView.image = UIImage(systemName: Constants.Images.myPageVCImageOptions[indexPath.row])
        cell.leftImageView.tintColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.myPageVCStoryBoardID[indexPath.row]) else { return }
        pushViewController(with: vc)
    }
    
    func pushViewController(with vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - EasyTipViewDelegate

extension MyPageViewController: EasyTipViewDelegate {
    
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        infoButton.isUserInteractionEnabled = true
    }
}

//MARK: - UI Configuration

extension MyPageViewController {
    
    func initialize() {
        
        initializeTableView()
        initializeProfileImageButton()
        initializeUserInfoRelatedUIComponents()
        initializeImagePicker()
        initializeTipViewPreferences()
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
    
    func initializeUserInfoRelatedUIComponents() {
        
        userMedal.image = setUserMedalImage(medalRank: User.shared.medal)
        self.userNickname.text = User.shared.username
        self.userMedal.image = setUserMedalImage(medalRank: User.shared.medal)

        if let profileImage = User.shared.profileImage {
            self.profileImageButton.setImage(profileImage, for: .normal)
        }
        

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
    
    func initializeTipViewPreferences() {
        
        preferences.drawing.font = UIFont.boldSystemFont(ofSize: 15)
        preferences.drawing.foregroundColor = .white
        preferences.drawing.backgroundColor = .lightGray
        preferences.drawing.arrowPosition = .top
    }
}
