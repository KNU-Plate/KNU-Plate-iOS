import UIKit

// 맛집 올리기 View Controller

class NewRestaurantViewController: UIViewController {
    
    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var ratingStackView: RatingController!
    @IBOutlet weak var foodTypeTextField: UITextField!
    @IBOutlet weak var expandTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!

    
    var newRestaurantViewModel = NewRestaurantViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantNameTextField.delegate = self
        reviewTextView.delegate = self
        addDoneButtonOnKeyboard()
    
    }


    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
      
        restaurantNameTextField.resignFirstResponder()
        
        switch sender.selectedSegmentIndex {
        case 0:
            newRestaurantViewModel.gate = "북문"
        case 1:
            newRestaurantViewModel.gate = "정/쪽문"
        case 2:
            newRestaurantViewModel.gate = "동문"
        case 3:
            newRestaurantViewModel.gate = "서문"
        default:
            newRestaurantViewModel.gate = "북문"
        }
    }
}


//MARK: - UITextFieldDelegate

extension NewRestaurantViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let name = textField.text else {
            let alert = AlertManager.createAlertMessage("식당 이름 입력", "식당명을 입력해주세요!")
            self.present(alert, animated: true, completion: nil)
            return
        }

        newRestaurantViewModel.restaurantName = name


        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
}

//MARK: - UITextViewDelegate

extension NewRestaurantViewController: UITextViewDelegate {
    
    
    
}

//MARK: - UI Configuration Methods

extension NewRestaurantViewController {

    func addDoneButtonOnKeyboard() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.doneButtonAction))
        toolBar.items = [doneButton]
        toolBar.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        
        restaurantNameTextField.inputAccessoryView = toolBar
        reviewTextView.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
}


//MARK: - Other Methods
