import UIKit
import ObjectiveC

extension UIViewController {
    
    private struct Keys {
        static var gradientView: UInt8 = 0
    }
    
    var themeGradientView: GradientView? {
        get {
            objc_getAssociatedObject(self, &Keys.gradientView) as? GradientView
        }
        set {
            objc_setAssociatedObject(self, &Keys.gradientView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    func applyTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        
        updateBackground(isDark)
        updateNavigationBar(isDark)
        updateSubviews(view, isDark: isDark)
    }
    
    
    private func updateBackground(_ isDark: Bool) {
        if isDark {
            addGradientIfNeeded()
            view.backgroundColor = .clear
        } else {
            removeGradient()
            view.backgroundColor = .systemBackground
        }
    }
    
    private func addGradientIfNeeded() {
        guard themeGradientView == nil else { return }
        
        let gradient = GradientView(frame: view.bounds)
        gradient.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(gradient, at: 0)
        themeGradientView = gradient
    }
    
    private func removeGradient() {
        themeGradientView?.removeFromSuperview()
        themeGradientView = nil
    }
    
    // MARK: - Navigation
    
    private func updateNavigationBar(_ isDark: Bool) {
        guard let navBar = navigationController?.navigationBar else { return }
        
        let appearance = UINavigationBarAppearance()
        
        if isDark {
            appearance.configureWithTransparentBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            appearance.configureWithDefaultBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        }
        
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.tintColor = ThemeManager.shared.navBarTintColor
    }
    
    
    private func updateSubviews(_ view: UIView, isDark: Bool) {
        for subview in view.subviews {
            
            if subview is GradientView { continue }
            
            applyContainerBackground(subview, isDark: isDark)
            applyTextStyle(subview)
            applySpecialViews(subview, isDark: isDark)
            
            updateSubviews(subview, isDark: isDark)
        }
    }
    
    private func applyContainerBackground(_ view: UIView, isDark: Bool) {
        
        if view is UITableView ||
           view is UICollectionView ||
           view is UIScrollView {
            view.backgroundColor = .clear
        }
    }
    
    private func applyTextStyle(_ view: UIView) {
        if let label = view as? UILabel, label.tag != 1001 {
            label.textColor = ThemeManager.shared.textColor
        }
        
        if let button = view as? UIButton {
            button.tintColor = ThemeManager.shared.textColor
        }
    }
    
    private func applySpecialViews(_ view: UIView, isDark: Bool) {
        if let searchBar = view as? UISearchBar {
            styleSearchBar(searchBar, isDark: isDark)
        }
    }
    
    
    private func styleSearchBar(_ searchBar: UISearchBar, isDark: Bool) {
        ThemeManager.shared.style(searchBar: searchBar)
    }
}
