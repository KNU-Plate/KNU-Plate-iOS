import UIKit

//MARK: - 공지사항

class NoticeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var noticeList: [NoticeListModel] = [NoticeListModel]()
    
    private var isFetchingData: Bool = false
    private var indexToFetch: Int = 0
    
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
        fetchNoticeList()
    }
    
    func fetchNoticeList() {
        
        isFetchingData = true
        
        NoticeManager.shared.fetchNoticeList(index: indexToFetch) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                
                if model.isEmpty {
                    DispatchQueue.main.async {
                        self.tableView.tableFooterView = nil
                    }
                    return
                }
                
                self.indexToFetch = model[model.count - 1].noticeID
                self.noticeList.append(contentsOf: model)
                self.isFetchingData = false
                DispatchQueue.main.async {
                    self.tableView.tableFooterView = nil
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
        let date = formatDate(timestamp: noticeList[indexPath.row].dateCreated)
        cell.noticeDateLabel.text = date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK: - UIScrollViewDelegate

extension NoticeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
   
        if position > (tableView.contentSize.height - 80 - scrollView.frame.size.height) {
        
            if !isFetchingData {
                tableView.tableFooterView = createSpinnerFooterView()
                self.fetchNoticeList()
            }
        }
    }
}

//MARK: - Other Methods

extension NoticeViewController {
    
    func formatDate(timestamp: TimeInterval) -> String {
        
        let date = Date(timeIntervalSince1970: timestamp/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        return result
    }
}
