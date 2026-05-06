import UIKit

extension UIView {
    private struct AssociatedKeys {
        static var skeletonLayer = "skeletonLayer"
    }
    
    private var skeletonLayer: CALayer? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.skeletonLayer) as? CALayer }
        set { objc_setAssociatedObject(self, &AssociatedKeys.skeletonLayer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func showSkeleton() {
        let isDark = ThemeManager.shared.isDarkTheme
        let views = findSkeletonableViews(in: self)
        
        for view in views {
            view.applySkeleton(isDark: isDark)
        }
    }
    
    func hideSkeleton() {
        removeSkeleton(from: self)
    }
    
    // MARK: - Helpers
    private func findSkeletonableViews(in root: UIView) -> [UIView] {
        var results = [UIView]()
        if root.tag == 999 { return results }
        
        if root is UILabel || root is UIImageView || root is UIButton || root is UIStackView {
            results.append(root)
        } else {
            for subview in root.subviews where !subview.isHidden {
                results.append(contentsOf: findSkeletonableViews(in: subview))
            }
        }
        
        return results.isEmpty ? [root] : results
    }
    
    private func applySkeleton(isDark: Bool) {
        skeletonLayer?.removeFromSuperlayer()
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: bounds.width * 3, height: bounds.height)
        
        let base = isDark ? UIColor(white: 1.0, alpha: 0.08).cgColor : UIColor(white: 0.85, alpha: 1.0).cgColor
        let shine = isDark ? UIColor(white: 1.0, alpha: 0.15).cgColor : UIColor.white.cgColor
        
        gradient.colors = [base, shine, base]
        gradient.locations = [0.35, 0.5, 0.65]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let anim = CABasicAnimation(keyPath: "position.x")
        anim.fromValue = -bounds.width
        anim.toValue = bounds.width * 2
        anim.duration = 1.5
        anim.repeatCount = .infinity
        gradient.add(anim, forKey: "shimmer")
        
        let container = CALayer()
        container.frame = bounds
        container.backgroundColor = base
        container.cornerRadius = layer.cornerRadius > 0 ? layer.cornerRadius : 4
        container.masksToBounds = true
        container.addSublayer(gradient)
        
        layer.addSublayer(container)
        skeletonLayer = container
    }
    
    private func removeSkeleton(from root: UIView) {
        root.skeletonLayer?.removeFromSuperlayer()
        root.skeletonLayer = nil
        for subview in root.subviews {
            removeSkeleton(from: subview)
        }
    }
}
