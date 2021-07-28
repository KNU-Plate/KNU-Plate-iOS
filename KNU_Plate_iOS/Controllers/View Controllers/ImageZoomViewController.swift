import UIKit
import Then
import SnapKit

class ImageZoomViewController: UIViewController {

    let scrollView = UIScrollView()
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.navigationItem.title = "사진 상세보기"
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        self.scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(safeArea)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
