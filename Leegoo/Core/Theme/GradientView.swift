import UIKit

class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        gradientLayer.colors = [
            UIColor(red: 0.208, green: 0.271, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.039, green: 0.039, blue: 0.039, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.8, y: 0.1)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 0.9)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
