import UIKit
import SDWebImage

class LatestEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        applyTheme()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        
        homeTeamLabel.adjustsFontSizeToFitWidth = true
        homeTeamLabel.minimumScaleFactor = 0.5
        homeTeamLabel.numberOfLines = 1
        
        awayTeamLabel.adjustsFontSizeToFitWidth = true
        awayTeamLabel.minimumScaleFactor = 0.5
        awayTeamLabel.numberOfLines = 1
    }
    
    func applyTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        contentView.backgroundColor = ThemeManager.shared.cellBackgroundColor
        contentView.layer.borderColor = isDark ? UIColor.white.withAlphaComponent(0.2).cgColor : UIColor.systemGray5.cgColor
        contentView.clipsToBounds = true
        
        // Clear all inner container views
        for sub in contentView.subviews {
            if !(sub is UILabel) && !(sub is UIImageView) {
                sub.backgroundColor = .clear
            }
        }
        
        homeTeamLabel?.textColor = ThemeManager.shared.textColor
        awayTeamLabel?.textColor = ThemeManager.shared.textColor
        
        // Plain style for score
        scoreLabel?.textColor = ThemeManager.shared.accentColor
        scoreLabel?.backgroundColor = .clear
        scoreLabel?.layer.borderWidth = 0
        
        arrowImageView?.tintColor = ThemeManager.shared.accentColor
    }
    
    func configure(with event: Event) {
        applyTheme()
        
        homeTeamLabel.text = event.eventHomeTeam ?? "Home"
        awayTeamLabel.text = event.eventAwayTeam  ?? "Away"
        
        var result = (event.eventFinalResult ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if result.isEmpty || result == "-" || result == " - " {
            result = "VS"
        } else {
            result = result.replacingOccurrences(of: "...", with: "N/A")
            if result.hasSuffix("-") {
                result += "N/A"
            } else if result.hasPrefix("-") {
                result = "N/A" + result
            }
        }
        scoreLabel.text = result
        homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )

        awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )
        setupInfoLabel(event: event)
    }

    
    private func setupInfoLabel(event: Event) {
        let dateText = formatDate(event.eventDate)
        let timeText = formatTime(event.eventTime)
        let info = NSMutableAttributedString()
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: ThemeManager.shared.secondaryTextColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        
        // Calendar
        if let calImg = UIImage(systemName: "calendar")?.withTintColor(ThemeManager.shared.secondaryTextColor, renderingMode: .alwaysOriginal) {
            let a = NSTextAttachment(); a.image = calImg
            a.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            info.append(NSAttributedString(attachment: a))
            info.append(NSAttributedString(string: " \(dateText)  ", attributes: attrs))
        }
        
        // Separator
        info.append(NSAttributedString(string: "|   ", attributes: attrs))
        
        // Clock
        if let clkImg = UIImage(systemName: "clock")?.withTintColor(ThemeManager.shared.secondaryTextColor, renderingMode: .alwaysOriginal) {
            let a = NSTextAttachment(); a.image = clkImg
            a.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            info.append(NSAttributedString(attachment: a))
            info.append(NSAttributedString(string: " \(timeText)", attributes: attrs))
        }
        
        infoLabel.attributedText = info
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "--" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: dateString) else { return dateString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        return outputFormatter.string(from: date)
    }
    
    private func formatTime(_ timeString: String?) -> String {
        guard let timeString = timeString else { return "--" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        var date = inputFormatter.date(from: timeString)
        if date == nil {
            inputFormatter.dateFormat = "HH:mm"
            date = inputFormatter.date(from: timeString)
        }
        
        guard let parsedDate = date else { return timeString }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US")
        return outputFormatter.string(from: parsedDate)
    }
}
