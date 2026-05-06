import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    private let themeKey = "app_theme_is_dark"
    
    private init() {}
    
    var isDarkTheme: Bool {
        get { UserDefaults.standard.bool(forKey: themeKey) }
        set { UserDefaults.standard.set(newValue, forKey: themeKey) }
    }
    
    // MARK: - Colors
    var textColor: UIColor { isDarkTheme ? .white : .black }
    var secondaryTextColor: UIColor { isDarkTheme ? UIColor(white: 1.0, alpha: 0.7) : .darkGray }
    var accentColor: UIColor { isDarkTheme ? .white : .systemBlue }
    var cellBackgroundColor: UIColor { isDarkTheme ? UIColor(white: 1.0, alpha: 0.1) : .white }
    var navBarTintColor: UIColor { isDarkTheme ? .white : .systemBlue }
    var glassBackgroundColor: UIColor { isDarkTheme ? UIColor(white: 1.0, alpha: 0.12) : .white }
    
    func toggleTheme() {
        isDarkTheme.toggle()
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
    
    // MARK: - Global Appearance
    func applyGlobalAppearance(to window: UIWindow?) {
        guard let window = window else { return }
        updateTabBarAppearance(window)
        updateNavBars(in: window.rootViewController)
        if let presented = window.rootViewController?.presentedViewController {
            updateNavBars(in: presented)
        }
    }
    
    private func updateTabBarAppearance(_ window: UIWindow) {
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
            appearance.stackedLayoutAppearance.selected.iconColor = .systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        }
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) { tabBar.scrollEdgeAppearance = appearance }
        tabBar.tintColor = isDarkTheme ? .white : .systemBlue
    }
    
    private func updateNavBars(in vc: UIViewController?) {
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
            nav.navigationBar.tintColor = navBarTintColor
        }
        
        vc.children.forEach { updateNavBars(in: $0) }
        if let presented = vc.presentedViewController { updateNavBars(in: presented) }
    }
    
    private func findTabBarController(in vc: UIViewController?) -> UITabBarController? {
        if let tab = vc as? UITabBarController { return tab }
        for child in vc?.children ?? [] {
            if let found = findTabBarController(in: child) { return found }
        }
        return nil
    }
}

extension NSNotification.Name {
    static let themeDidChange = NSNotification.Name("themeDidChange")
}
