import UIKit

extension UIView {
    private struct AssociatedKeys {
        static var skeletonLayer: UInt8 = 0
    }
    
    private var skeletonLayer: CALayer? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.skeletonLayer) as? CALayer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.skeletonLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showSkeleton() {
        self.layoutIfNeeded()
        
        var viewsToSkeletonize = [UIView]()
        
        func findViews(in v: UIView) {
            // If the user wants entire stack views to shimmer as a block:
            // "if you have a stack containing things like images and so on, then the whole stack should have a shimmer on it"
            if v is UIStackView {
                viewsToSkeletonize.append(v)
            } else if v is UILabel || v is UIImageView || v is UIButton {
                viewsToSkeletonize.append(v)
            } else {
                for sub in v.subviews {
                    if !sub.isHidden {
                        findViews(in: sub)
                    }
                }
            }
        }
        
        findViews(in: self)
        
        // If empty, skeletonize self
        if viewsToSkeletonize.isEmpty {
            viewsToSkeletonize.append(self)
        }
        
        for v in viewsToSkeletonize {
            if v.skeletonLayer != nil { continue } // already has skeleton
            
            // Set dummy text on labels if empty so they have height
            if let label = v as? UILabel, (label.text?.isEmpty ?? true) {
                label.text = "                "
                label.layoutIfNeeded()
            }
            
            let light = UIColor.white.withAlphaComponent(0.7).cgColor
            let dark = UIColor.black.withAlphaComponent(0.2).cgColor
            
            let gradient = CAGradientLayer()
            gradient.colors = [dark, light, dark]
            // We want it to be wide enough to sweep across
            gradient.frame = CGRect(x: -v.bounds.width, y: 0, width: 3 * max(v.bounds.width, 50), height: max(v.bounds.height, 20))
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            gradient.locations = [0.4, 0.5, 0.6]
            
            let animation = CABasicAnimation(keyPath: "locations")
            animation.fromValue = [0.0, 0.1, 0.2]
            animation.toValue = [0.8, 0.9, 1.0]
            animation.duration = 1.2
            animation.repeatCount = .infinity
            gradient.add(animation, forKey: "shimmer")
            
            let skeletonMask = UIView(frame: v.bounds)
            skeletonMask.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            skeletonMask.layer.mask = gradient
            
            if v.layer.cornerRadius > 0 {
                skeletonMask.layer.cornerRadius = v.layer.cornerRadius
            } else if v is UIImageView && v.bounds.width == v.bounds.height {
                skeletonMask.layer.cornerRadius = v.bounds.width / 2
            } else {
                skeletonMask.layer.cornerRadius = 4
            }
            skeletonMask.clipsToBounds = true
            
            // Use associated object to keep reference
            v.skeletonLayer = skeletonMask.layer
            
            // For labels and buttons, we just add it to layer. For others too.
            v.layer.addSublayer(skeletonMask.layer)
        }
    }
    
    func hideSkeleton() {
        var viewsWithSkeleton = [UIView]()
        
        func findViews(in v: UIView) {
            if v.skeletonLayer != nil {
                viewsWithSkeleton.append(v)
            }
            for sub in v.subviews {
                findViews(in: sub)
            }
        }
        
        findViews(in: self)
        
        if self.skeletonLayer != nil {
            viewsWithSkeleton.append(self)
        }
        
        for v in viewsWithSkeleton {
            v.skeletonLayer?.removeFromSuperlayer()
            v.skeletonLayer = nil
            
            // Optionally clear dummy text if you set it
            if let label = v as? UILabel, label.text == "                " {
                label.text = nil
            }
        }
    }
}
