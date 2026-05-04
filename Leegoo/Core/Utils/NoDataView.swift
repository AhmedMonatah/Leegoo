import UIKit
import Lottie

class NoDataView: UIView {
    
    private var hasStartedAnimation = false
    
    private let animationView: LottieAnimationView = {
        let lottie = LottieAnimationView(dotLottieName: "NoData")
        lottie.contentMode = .scaleAspectFit
        lottie.loopMode = .loop
        lottie.backgroundBehavior = .pauseAndRestore
        lottie.translatesAutoresizingMaskIntoConstraints = false
        return lottie
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data Found"
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        addSubview(stackView)
        
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            animationView.widthAnchor.constraint(equalToConstant: 220),
            animationView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !hasStartedAnimation else { return }
        hasStartedAnimation = true
        startLoop()
    }
    
    private func startLoop() {
        animationView.play { [weak self] finished in
            guard let self = self, finished else { return }
            self.startLoop()
        }
    }
    
}
