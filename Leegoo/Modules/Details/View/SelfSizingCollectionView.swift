import UIKit

class SelfSizingCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        let height = contentSize.height > 0 ? contentSize.height : 120
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
}
