import UIKit
import SwiftTheme
import SkeletonView

enum AppTheme: Int {
    case light = 0
    case dark = 1
    
    static let textColor = ThemeColorPicker(colors: "#000000", "#FFFFFF")
    static let secondaryTextColor = ThemeColorPicker(colors: "#555555", "#B3FFFFFF")
    static let accentColor = ThemeColorPicker(colors: "#3545FF", "#FFFFFF")
    static let cellBackgroundColor = ThemeColorPicker(colors: "#00000000", "#00000000")
    static let glassBackgroundColor = ThemeColorPicker(colors: "#00000000", "#00000000")
    static let tableBackgroundColor = ThemeColorPicker(colors: "#00000000", "#00000000")
    
    static let filterActiveBackground = ThemeColorPicker(colors: "#FFFFFF", "#FFFFFF")
    static let filterActiveText = ThemeColorPicker(colors: "#000000", "#000000")
    static let filterInactiveBackground = ThemeColorPicker(colors: "#FFFFFF", "#FFFFFF")
    static let filterInactiveText = ThemeColorPicker(colors: "#555555", "#555555")
    static let navBarTintColor = ThemeColorPicker(colors: "#3545FF", "#FFFFFF")
        static let moonIcon = ThemeImagePicker(images:
        UIImage(systemName: "moon")!.withRenderingMode(.alwaysTemplate),
        UIImage(systemName: "moon.fill")!.withRenderingMode(.alwaysTemplate)
    )
    
    static let statusBarStyle = ThemeStatusBarStylePicker(styles: .default, .lightContent)
    
    static func setup() {
        let isDark = UserDefaults.standard.bool(forKey: "app_theme_is_dark")
        
        SwiftTheme.ThemeManager.setTheme(
            index: isDark ? AppTheme.dark.rawValue : AppTheme.light.rawValue
        )

        let baseColor: UIColor
        let secondaryColor: UIColor

        if isDark {
               baseColor = UIColor(white: 1.0, alpha: 0.2)
               secondaryColor = UIColor(white: 1.0, alpha: 0.35)
           } else {

               baseColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
               secondaryColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
        }

        SkeletonAppearance.default.gradient = SkeletonGradient(
            baseColor: baseColor,
            secondaryColor: secondaryColor
        )

        SkeletonAppearance.default.tintColor = baseColor

        
        SkeletonAppearance.default.multilineHeight = 12
        SkeletonAppearance.default.multilineSpacing = 6
        SkeletonAppearance.default.multilineLastLineFillPercent = 60
    }
    static func toggle() {
        let nextIndex = SwiftTheme.ThemeManager.currentThemeIndex == 0 ? 1 : 0
        SwiftTheme.ThemeManager.setTheme(index: nextIndex)
        UserDefaults.standard.set(nextIndex == 1, forKey: "app_theme_is_dark")
    }
}
