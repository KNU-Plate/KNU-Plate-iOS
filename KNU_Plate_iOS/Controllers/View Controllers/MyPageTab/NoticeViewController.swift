import UIKit

//MARK: - 공지사항

class NoticeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var noticeList: [NoticeListModel] = [NoticeListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        fetchNoticeList()
    }
    
    
    func initialize() {
        
        initializeTableView()
    }
    
    func initializeTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(refreshTable),
                                 for: .valueChanged)
    }

    @objc func refreshTable() {
        
        noticeList.removeAll()
        refreshControl.endRefreshing()
    }
    
    func fetchNoticeList() {
        
        NoticeManager.shared.fetchNoticeList(index: 0) { result in
            
            switch result {
            
            case .success(let model):
                
                self.noticeList = model
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
            
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("✏️ noticeList count: \(noticeList.count)")
        return noticeList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.noticeCell) as? NoticeTableViewCell else { fatalError() }
        
        cell.noticeTitleLabel.text = noticeList[indexPath.row].title
        cell.noticeDateLabel.text = String(noticeList[indexPath.row].dateCreated)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
