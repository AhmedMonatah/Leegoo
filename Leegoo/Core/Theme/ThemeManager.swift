import UIKit
import SwiftTheme

final class ThemeManager {
    

    static let shared = ThemeManager()
    private init() {}
    
    var isDarkTheme: Bool {
        return SwiftTheme.ThemeManager.currentThemeIndex == AppTheme.dark.rawValue
    }
    
    var textColor: UIColor { isDarkTheme ? .white : .black }
    var secondaryTextColor: UIColor {
        isDarkTheme ? UIColor(white: 1.0, alpha: 0.7) : .darkGray
    }
    var accentColor: UIColor {
        isDarkTheme ? .white : UIColor(red: 53/255, green: 69/255, blue: 1, alpha: 1)
    }
    var cellBackgroundColor: UIColor {
        isDarkTheme ? UIColor(white: 1.0, alpha: 0.1) : .white
    }
    var navBarTintColor: UIColor {
        isDarkTheme ? .white : accentColor
    }
    
    func toggleTheme() {
        AppTheme.toggle()
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
    
    func applyGlobalAppearance(to window: UIWindow?) {
        guard let window = window else { return }
        
        updateTabBarAppearance(window)
        updateNavBars(in: window.rootViewController)
        updateSearchBarTextAppearance()
    }
}


private extension ThemeManager {
    
    func updateTabBarAppearance(_ window: UIWindow) {
        guard let tabBarController = findTabBarController(in: window.rootViewController) else { return }
        
        let tabBar = tabBarController.tabBar
        let appearance = UITabBarAppearance()
        
        if isDarkTheme {
            appearance.configureWithTransparentBackground()
            
            let unselected = UIColor(white: 1.0, alpha: 0.5)
            appearance.stackedLayoutAppearance.normal.iconColor = unselected
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselected]
            
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
            
        } else {
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemBackground
            
            let unselected = UIColor.systemGray
            appearance.stackedLayoutAppearance.normal.iconColor = unselected
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselected]
            
            appearance.stackedLayoutAppearance.selected.iconColor = accentColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: accentColor]
        }
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = isDarkTheme ? .white : accentColor
    }
    
    func updateNavBars(in vc: UIViewController?) {
        guard let vc = vc else { return }
        
        if let nav = vc as? UINavigationController {
            let appearance = UINavigationBarAppearance()
            
            if isDarkTheme {
                appearance.configureWithTransparentBackground()
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            } else {
                appearance.configureWithDefaultBackground()
                appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
            }
            
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
            nav.navigationBar.tintColor = isDarkTheme ? .white : accentColor
        }
        
        vc.children.forEach { updateNavBars(in: $0) }
        if let presented = vc.presentedViewController {
            updateNavBars(in: presented)
        }
    }
    
    func updateSearchBarTextAppearance() {
        let textFieldAppearance = UITextField.appearance(
            whenContainedInInstancesOf: [UISearchBar.self]
        )
        
        textFieldAppearance.defaultTextAttributes = [
            .foregroundColor: isDarkTheme ? UIColor.white : UIColor.black
        ]
    }
    
    func findTabBarController(in vc: UIViewController?) -> UITabBarController? {
        if let tab = vc as? UITabBarController { return tab }
        
        for child in vc?.children ?? [] {
            if let found = findTabBarController(in: child) {
                return found
            }
        }
        return nil
    }
}


extension ThemeManager {
    func style(searchBar: UISearchBar) {
        let tf = searchBar.searchTextField
        let isDark = isDarkTheme
        
        tf.textColor = isDark ? .white : .black
        tf.tintColor = isDark ? .white : .black
        
        let placeholderColor = isDark ? UIColor(white: 1.0, alpha: 0.6) : UIColor.darkGray
        tf.attributedPlaceholder = NSAttributedString(
            string: searchBar.placeholder ?? "Search",
            attributes: [.foregroundColor: placeholderColor]
        )
        
        if let glassIconView = tf.leftView as? UIImageView {
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = isDark ? .white : .darkGray
        }
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = isDark ? UIColor(white: 1.0, alpha: 0.2).cgColor : UIColor(white: 0.0, alpha: 0.1).cgColor
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
 
        if isDark {
            searchBar.barTintColor = .clear
            searchBar.backgroundColor = .clear
            searchBar.backgroundImage = UIImage()
            tf.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        } else {
            tf.backgroundColor = .secondarySystemBackground
        }
    }}
extension NSNotification.Name {
    static let themeDidChange = NSNotification.Name("themeDidChange")
}
