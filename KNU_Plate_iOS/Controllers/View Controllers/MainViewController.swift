
import UIKit
import SnapKit

// Shows the main screen of the app

class MainViewController: UIViewController {
    
    let tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let northGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        return button
    }()
    
    let mainGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        return button
    }()
    
    let eastGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        return button
    }()
    
    let westGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "크누플레이트"
        setUpView()
    }
    
    func setUpView() {
        // set up banner and buttons
        self.view.addSubview(tempView)
        self.view.addSubview(northGateButton)
        self.view.addSubview(mainGateButton)
        self.view.addSubview(eastGateButton)
        self.view.addSubview(westGateButton)
        
        let safeArea = self.view.safeAreaLayoutGuide
        let itemsPerRow: CGFloat = 2
        let inset: CGFloat = 10
        let paddingSpace: CGFloat = inset * (itemsPerRow + 1)
        let availableWidth = safeArea.layoutFrame.width - paddingSpace
        let width: CGFloat = availableWidth / itemsPerRow
        
        
        tempView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.top.left.right.equalTo(safeArea)
        }
        northGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.top.equalTo(tempView.snp.bottom).offset(inset)
            make.left.equalTo(safeArea).inset(inset)
        }
        mainGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.top.equalTo(tempView.snp.bottom).offset(inset)
            make.left.equalTo(northGateButton.snp.right).offset(inset)
            make.right.equalTo(safeArea).inset(inset)
        }
        eastGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.top.equalTo(northGateButton.snp.bottom).offset(inset)
            make.left.equalTo(safeArea).inset(inset)
        }
        westGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.top.equalTo(mainGateButton.snp.bottom).offset(inset)
            make.left.equalTo(eastGateButton.snp.right).offset(inset)
            make.right.equalTo(safeArea).inset(inset)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
