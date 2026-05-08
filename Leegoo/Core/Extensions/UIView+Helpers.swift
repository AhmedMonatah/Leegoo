import UIKit

extension UIView {
    func clearBackgroundsRecursively() {
        for sub in self.subviews {
            if !(sub is UILabel) && !(sub is UIImageView) {
                sub.backgroundColor = .clear
            }
            sub.clearBackgroundsRecursively()
        }
    }
}
