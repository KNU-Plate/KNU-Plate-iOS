import UIKit
import SnapKit

/// Shows the main screen of the app
class MainViewController: UIViewController {
    
    //MARK: - Tempview Declaration
    let tempView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = Constants.Layer.borderWidth
        view.layer.borderColor = Constants.Layer.borderColor
        view.layer.cornerRadius = Constants.Layer.cornerRadius
        return view
    }()
    
    //MARK: - Gate Buttons Declaration
    let northGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 0
        return button
    }()
    
    let mainGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
        return button
    }()
    
    let eastGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 2
        return button
    }()
    
    let westGateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 3
        return button
    }()
    
    //MARK: - Gate Labels Declaration
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
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title of main view
        self.navigationItem.title = "크슐랭가이드"
        // set title color
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor(named: Constants.Color.appDefaultColor)
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        // set backbutton color
        self.navigationController?.navigationBar.tintColor = UIColor(named: Constants.Color.appDefaultColor)
        setupAllButtons()
        setupView()
        setButtonTarget()
    }
}

//MARK: - Basic UI Set Up
extension MainViewController {
    /// Set up all main button
    func setupAllButtons() {
        setupButton(northGateButton)
        setupButton(mainGateButton)
        setupButton(eastGateButton)
        setupButton(westGateButton)
    }
    
    /// Set up button layer, background color and touch reaction
    func setupButton(_ button: UIButton) {
        // background color
        button.backgroundColor = .white
        // layer
        button.layer.cornerRadius = Constants.Layer.cornerRadius
        button.layer.borderWidth = Constants.Layer.borderWidth
        button.layer.borderColor = Constants.Layer.borderColor
        button.layer.masksToBounds = true
        // touch reaction
        button.addBounceReaction()
    }
    
    /// Set up banner, buttons and labels
    func setupView() {
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
        let labelInset: CGFloat = 5
        let paddingSpace: CGFloat = inset * (itemsPerRow + 1)
        let availableWidth = safeArea.layoutFrame.width - paddingSpace
        let width: CGFloat = availableWidth / itemsPerRow
        
        // tempview snapkit layout
        tempView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(safeArea).inset(inset)
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
            make.right.bottom.equalToSuperview().inset(labelInset)
        }
        mainGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(labelInset)
        }
        eastGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(labelInset)
        }
        westGateLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview().inset(labelInset)
        }
    }
    
    /// Set target of the buttons
    func setButtonTarget() {
        northGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
        mainGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
        eastGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
        westGateButton.addTarget(self, action: #selector(gateButtonWasTapped), for: .touchUpInside)
    }
}

//MARK: - Prepare For Next View
extension MainViewController {
    /// Execute next view controller
    @objc func gateButtonWasTapped(_ sender: UIButton) {
        guard let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.StoryboardID.restaurantCollectionViewController) else {
            fatalError()
        }
        nextViewController.navigationItem.title = Constants.gateNames[sender.tag]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
