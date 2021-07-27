import UIKit
import Then
import SnapKit

class ImageZoomViewController: UIViewController {

    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.navigationItem.title = "사진 상세보기"
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(imageView)
        self.scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0.0
        let imageViewHeight = self.view.frame.height - navigationBarHeight - statusBarHeight - tabBarHeight
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(imageViewHeight)
            make.centerY.equalToSuperview()
        }
//        print("viewDidLoad: \(imageView.bounds.height) \(imageView.bounds.width)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
//        imageView.setNeedsLayout()
//        imageView.layoutIfNeeded()
//        updateMinZoomScaleForSize(view.bounds.size)
    }
}

extension ImageZoomViewController: UIScrollViewDelegate {
    func updateMinZoomScaleForSize(_ size: CGSize) {
        print("updateMinZoomScaleForSize")
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
//        print("size: \(size.height) \(size.width)")
//        print("image: \(imageView.bounds.height) \(imageView.bounds.width)")
//        print("scale: \(heightScale) \(widthScale)")
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        updateConstraintsForSize(view.bounds.size)
    }

    func updateConstraintsForSize(_ size: CGSize) {
        print("updateConstraintsForSize")
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)

        print("yOffset: \(yOffset), xOffset: \(xOffset)")
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0.0
        print("top: \(navigationBarHeight + statusBarHeight)")
        print("bottom: \(tabBarHeight)")
        
        
        print("image frame y: \(imageView.frame.origin.y)")
        print("image bounds y: \(imageView.bounds.origin.y)")
        print("⚠️")
//        imageView.snp.remakeConstraints { make in
//            make.top.equalTo(yOffset)
//            make.bottom.equalTo(-yOffset)
//            make.leading.equalTo(xOffset)
//            make.trailing.equalTo(-xOffset)
//        }
        
        print("image frame y: \(imageView.frame.origin.y)")
        print("image bounds y: \(imageView.bounds.origin.y)")
        
        view.layoutIfNeeded()
    }
}
