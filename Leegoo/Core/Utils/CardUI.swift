import UIKit
import SwiftTheme

struct CardUI {
    static func apply(to view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        
        view.theme_backgroundColor = AppTheme.glassBackgroundColor
        
        view.layer.theme_borderColor = ThemeCGColorPicker(
            colors: "#E0E0E0", "#00000000"
        )
    }
}
