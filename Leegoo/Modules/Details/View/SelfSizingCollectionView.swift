import UIKit

class SelfSizingCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = max(contentSize.height, 50) // Minimum height of 50
        return CGSize(width: contentSize.width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != contentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
