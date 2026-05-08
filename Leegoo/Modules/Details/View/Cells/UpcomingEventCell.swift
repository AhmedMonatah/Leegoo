import UIKit
import SDWebImage
import SwiftTheme

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
        isSkeletonable = true
        contentView.isSkeletonable = true
        SkeletonHelper.enable([homeTeamImageView, awayTeamImageView])
        SkeletonHelper.styleLabels([homeTeamLabel, awayTeamLabel, vsLabel], height: 15)
        SkeletonHelper.styleLabels([dateLabel], height: 12)
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clearBackgroundsRecursively()
        setupThemePickers()
        
        CardUI.apply(to: contentView)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.08
        layer.masksToBounds = false
    }
    

    
    private func setupThemePickers() {
        homeTeamLabel.theme_textColor = AppTheme.textColor
        awayTeamLabel.theme_textColor = AppTheme.textColor
        dateLabel.theme_textColor = AppTheme.secondaryTextColor
        vsLabel.theme_textColor = AppTheme.accentColor
    }
    
    func configure(with event: Event) {
        
        homeTeamLabel.text = event.eventHomeTeam ?? "Home"
        awayTeamLabel.text = event.eventAwayTeam ?? "Away"
        
        dateLabel.text = ""
        timeLabel.text = ""
        setupInfoLabel(event: event)
        
        homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo")
        )

        awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(systemName: "photo")
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
        
        if let calImg = UIImage(systemName: "calendar")?.withTintColor(ThemeManager.shared.secondaryTextColor, renderingMode: .alwaysOriginal) {
            let a = NSTextAttachment(); a.image = calImg
            a.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            info.append(NSAttributedString(attachment: a))
            info.append(NSAttributedString(string: " \(dateText)  ", attributes: attrs))
        }
        info.append(NSAttributedString(string: "|   ", attributes: attrs))
        
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
