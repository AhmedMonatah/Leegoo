import UIKit

class NoDataTableViewCell: UITableViewCell {
    
    static let reuseID = "NoDataTableViewCell"
    
    private let noDataView: NoDataView = {
        let view = NoDataView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: contentView.topAnchor),
            noDataView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            noDataView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            noDataView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            noDataView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
