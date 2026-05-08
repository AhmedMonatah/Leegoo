import UIKit
import SkeletonView

struct SkeletonHelper {
    static func enable(_ views: [UIView]) {
        for view in views {
            view.isSkeletonable = true
        }
    }
    
    static func styleLabels(_ labels: [UILabel], height: CGFloat = 15) {
        for label in labels {
            label.isSkeletonable = true
            label.skeletonTextNumberOfLines = 1
            label.skeletonTextLineHeight = .fixed(height)
        }
    }
}
