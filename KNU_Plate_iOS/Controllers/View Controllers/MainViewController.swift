import UIKit
import SnapKit

/// Shows the main screen of the app

class MainViewController: UIViewController {
    
    //MARK: - Tempview declaration
    let tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK: - Gate buttons declaration
    let northGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        button.tag = 0
        return button
    }()
    
    let mainGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        button.tag = 1
        return button
    }()
    
    let eastGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        button.tag = 2
        return button
    }()
    
    let westGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray
        button.tag = 3
        return button
    }()
    
    //MARK: - Gate labels declaration
    let northGateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.gateNames[0]
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let mainGateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.gateNames[1]
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let eastGateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.gateNames[2]
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    let westGateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.gateNames[3]
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title of main view
        self.navigationItem.title = "크누플레이트"
        // set backbutton color
        self.navigationController?.navigationBar.tintColor = UIColor(named: Constants.Color.KNU_Plate_Color)
        setUpView()
        setButtonTarget()
    }
}

//MARK: - Basic UI set up
extension MainViewController {
    /// Set up banner, buttons and labels
    func setUpView() {
        // add tempview
        self.view.addSubview(tempView)
        
        // add gate buttons
        self.view.addSubview(northGateButton)
        self.view.addSubview(mainGateButton)
        self.view.addSubview(eastGateButton)
        self.view.addSubview(westGateButton)
        
        // add gate labels
        self.northGateButton.addSubview(northGateLabel)
        self.mainGateButton.addSubview(mainGateLabel)
        self.eastGateButton.addSubview(eastGateLabel)
        self.westGateButton.addSubview(westGateLabel)
        
        // local constants declaration
        let safeArea = self.view.safeAreaLayoutGuide
        let itemsPerRow: CGFloat = 2
        let inset: CGFloat = 10
        let paddingSpace: CGFloat = inset * (itemsPerRow + 1)
        let availableWidth = safeArea.layoutFrame.width - paddingSpace
        let width: CGFloat = availableWidth / itemsPerRow
        
        // tempview snapkit layout
        tempView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(safeArea)
            make.bottom.equalTo(northGateButton.snp.top).offset(-inset)
        }
        
        // gate buttons snapkit layout
        northGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.left.equalTo(safeArea).inset(inset)
        }
        mainGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.left.equalTo(northGateButton.snp.right).offset(inset)
            make.right.equalTo(safeArea).inset(inset)
        }
        eastGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.top.equalTo(northGateButton.snp.bottom).offset(inset)
            make.left.equalTo(safeArea).inset(inset)
            make.bottom.equalTo(safeArea).offset(-inset)
        }
        westGateButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(width)
            make.top.equalTo(mainGateButton.snp.bottom).offset(inset)
            make.left.equalTo(eastGateButton.snp.right).offset(inset)
            make.right.equalTo(safeArea).inset(inset)
            make.bottom.equalTo(safeArea).offset(-inset)
        }
        
        // gate labels snapkit layout
        northGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
        mainGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
        eastGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
        westGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
    }
    
    /// Set target of the button
    func setButtonTarget() {
        northGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
        mainGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
        eastGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
        westGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Prepare for next view
extension MainViewController {
    /// Execute next view controller
    @objc func gateButtonWasTapped(_ sender: UIButton) {
        guard let nextViewController = self.storyboard?.instantiateViewController(identifier: Constants.StoryboardID.restaurantCollectionViewController) else {
            fatalError()
        }
        nextViewController.navigationItem.title = Constants.gateNames[sender.tag]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
