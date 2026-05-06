import UIKit
import SDWebImage

class UpcomingEventCell: UICollectionViewCell {
    
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        applyTheme()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.08
        layer.masksToBounds = false
    }
    
    func applyTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        contentView.backgroundColor = ThemeManager.shared.cellBackgroundColor
        contentView.layer.borderColor = isDark ? UIColor.white.withAlphaComponent(0.2).cgColor : UIColor.systemGray5.cgColor
        
        // Clear all inner container views
        for sub in contentView.subviews {
            if !(sub is UILabel) && !(sub is UIImageView) {
                sub.backgroundColor = .clear
            }
        }
        
        homeTeamLabel?.textColor = ThemeManager.shared.textColor
        awayTeamLabel?.textColor = ThemeManager.shared.textColor
        dateLabel?.textColor = ThemeManager.shared.secondaryTextColor
        
        
        // Plain style for VS
        vsLabel?.textColor = ThemeManager.shared.accentColor
        vsLabel?.backgroundColor = .clear
        vsLabel?.layer.borderWidth = 0
        
        // Adjust shadow for dark mode
        layer.shadowOpacity = isDark ? 0 : 0.08
    }
    
    func configure(with event: Event) {
        applyTheme()
        
        homeTeamLabel.text = event.eventHomeTeam ?? "Home"
        awayTeamLabel.text = event.eventAwayTeam ?? "Away"
        
        dateLabel.text = ""
        timeLabel.text = ""
        setupInfoLabel(event: event)
        
        homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )

        awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo"),
        )
        
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
        
        dateLabel.attributedText = info
        timeLabel.isHidden = true
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
