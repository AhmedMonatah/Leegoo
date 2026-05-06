import UIKit

extension UIViewController {
    private struct AssociatedKeys {
        static var gradientView = "gradientView"
    }
    
    var themeGradientView: GradientView? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.gradientView) as? GradientView }
        set { objc_setAssociatedObject(self, &AssociatedKeys.gradientView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func applyTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        updateBackground(isDark)
        updateSubviews(view, isDark: isDark)
        updateNavigationBar(isDark)
    }
    
    private func updateBackground(_ isDark: Bool) {
        if isDark {
            if themeGradientView == nil {
                let gv = GradientView(frame: view.bounds)
                gv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.insertSubview(gv, at: 0)
                themeGradientView = gv
            }
            view.backgroundColor = .clear
        } else {
            themeGradientView?.removeFromSuperview()
            themeGradientView = nil
            view.backgroundColor = .systemBackground
        }
    }
    
    private func updateNavigationBar(_ isDark: Bool) {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = ThemeManager.shared.navBarTintColor
        
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
    }
    
    private func updateSubviews(_ parent: UIView, isDark: Bool) {
        for subview in parent.subviews {
            if subview is GradientView { continue }
            
            // Clear backgrounds for containers in dark mode
            if isDark {
                if subview is UITableView || subview is UICollectionView || subview is UIScrollView {
                    subview.backgroundColor = .clear
                } else if !(subview is UILabel) && !(subview is UIImageView) && !(subview is UIButton) {
                    subview.backgroundColor = .clear
                }
            } else {
                if subview is UITableView || subview is UICollectionView || subview is UIScrollView {
                    subview.backgroundColor = .systemBackground
                }
            }
            
            // Apply text and tint colors
            if let label = subview as? UILabel, label.tag != 1001 {
                label.textColor = ThemeManager.shared.textColor
            } else if let button = subview as? UIButton {
                button.tintColor = ThemeManager.shared.textColor
            } else if let searchBar = subview as? UISearchBar {
                styleSearchBar(searchBar, isDark: isDark)
            }
            
            updateSubviews(subview, isDark: isDark)
        }
    }
    
    private func styleSearchBar(_ searchBar: UISearchBar, isDark: Bool) {
        if isDark {
            searchBar.barTintColor = .clear
            searchBar.backgroundColor = .clear
            searchBar.backgroundImage = UIImage()
            searchBar.searchTextField.textColor = .white
            searchBar.searchTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
            searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
                string: searchBar.placeholder ?? "Search",
                attributes: [.foregroundColor: UIColor(white: 1.0, alpha: 0.5)]
            )
        } else {
            searchBar.searchTextField.textColor = .label
            searchBar.searchTextField.backgroundColor = .secondarySystemBackground
            searchBar.searchTextField.attributedPlaceholder = nil
        }
    }
}
