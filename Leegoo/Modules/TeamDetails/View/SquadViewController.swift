//
//  SquadViewController.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//


import UIKit
import SDWebImage
import SkeletonView

final class SquadViewController: UIViewController {

    private var isLoading = false
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var teamLogoImageView: UIImageView!


    @IBOutlet weak var teamLogoView: UIView!
    @IBOutlet weak var teamInitialsLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamIDLabel: UILabel!

    @IBOutlet weak var totalPlayersLabel: UILabel!
    @IBOutlet weak var goalkeepersCountLabel: UILabel!
    @IBOutlet weak var defendersCountLabel: UILabel!

    

    @IBOutlet weak var filterAllButton: UIButton!
    @IBOutlet weak var filterGKButton: UIButton!
    @IBOutlet weak var filterDefButton: UIButton!
    @IBOutlet weak var filterMidButton: UIButton!
    @IBOutlet weak var filterFwdButton: UIButton!



    @IBOutlet weak var tableView: UITableView!

    var presenter: TeamDetailsPresenterProtocol!



    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupThemePickers()
        tableView.isSkeletonable = true
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateSpecificTheme()
        presenter.viewDidLoad()
        
        backButton?.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
    }
    
    @objc private func themeDidChange() {
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateSpecificTheme()
        
        if isLoading {
            tableView.showAnimatedGradientSkeleton()
        }
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateSpecificTheme()
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupThemePickers() {
        teamNameLabel.theme_textColor = AppTheme.textColor
        teamIDLabel.theme_textColor = AppTheme.secondaryTextColor
        backButton.theme_tintColor = AppTheme.accentColor
        tableView.theme_backgroundColor = AppTheme.tableBackgroundColor
    }

    private func updateSpecificTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        
        // Clear any storyboard-baked backgrounds
        view.clearBackgroundsRecursively()
        
        // Apply theme to main containers
        [teamLogoView, teamNameLabel?.superview].forEach {
            $0?.theme_backgroundColor = AppTheme.glassBackgroundColor
            $0?.layer.cornerRadius = 16
            $0?.layer.masksToBounds = true
        }
        
        // Apply theme to stat cards
        [totalPlayersLabel, goalkeepersCountLabel, defendersCountLabel].forEach {
            if let card = $0?.superview {
                card.theme_backgroundColor = AppTheme.glassBackgroundColor
                card.layer.cornerRadius = 16
                card.layer.masksToBounds = true
                card.subviews.compactMap { $0 as? UILabel }.forEach {
                    $0.theme_textColor = AppTheme.textColor
                }
            }
        }
        
        if let logoView = teamLogoView {
            logoView.layer.cornerRadius = logoView.frame.height / 2
        }
        
        applyFilterStyle()
    }







    private func applyFilterStyle() {
        let buttons = [filterAllButton, filterGKButton, filterDefButton,
                       filterMidButton, filterFwdButton]
        
        for btn in buttons {
            guard let btn = btn else { continue }
            let isActive = btn.tag == presenter.activeFilterTag
            btn.theme_backgroundColor = isActive ? AppTheme.filterActiveBackground : AppTheme.filterInactiveBackground
            btn.theme_setTitleColor(isActive ? AppTheme.filterActiveText : AppTheme.filterInactiveText, forState: .normal)
            btn.layer.cornerRadius = 12
        }
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.register(NoDataTableViewCell.self, forCellReuseIdentifier: NoDataTableViewCell.reuseID)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    

    @IBAction func filterTapped(_ sender: UIButton) {
        presenter.filterPlayers(by: sender.tag)
        applyFilterStyle()
        tableView.reloadData()
    }

    @IBAction func refreshTapped(_ sender: UIButton) {
        presenter.viewDidLoad()
    }
}

extension SquadViewController: TeamDetailsViewProtocol {
    func showLoading() {
        isLoading = true
        tableView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }
    
    func hideLoading() {
        isLoading = false
        tableView.hideSkeleton()
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showTeamDetails(_ viewModel: TeamHeaderViewModel) {
        teamNameLabel.text = viewModel.name
        teamInitialsLabel.text = viewModel.initials
        
        if let logoUrlString = viewModel.logoURL, let url = URL(string: logoUrlString) {
            teamLogoImageView.sd_setImage(with: url, placeholderImage: nil, completed: { [weak self] img, _, _, _ in
                self?.teamInitialsLabel.isHidden = (img != nil)
            })
        } else {
            teamInitialsLabel.isHidden = false
        }
        
        teamIDLabel.text = viewModel.idText
        totalPlayersLabel.text = viewModel.totalPlayers
        goalkeepersCountLabel.text = viewModel.gkCount
        defendersCountLabel.text = viewModel.defCount
        
        applyFilterStyle()
        tableView.reloadData()
    }
}


extension SquadViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoading ? 1 : presenter.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading { return 10 }
        let count = presenter.numberOfPlayers(in: section)
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: PlayerCell.reuseID, for: indexPath)
            cell.contentView.theme_backgroundColor = AppTheme.cellBackgroundColor
            return cell
        }
        
        let count = presenter.numberOfPlayers(in: indexPath.section)
        
        if count == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NoDataTableViewCell.reuseID, for: indexPath) as? NoDataTableViewCell else {
                return UITableViewCell()
            }
            cell.contentView.theme_backgroundColor = AppTheme.cellBackgroundColor
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerCell.reuseID, for: indexPath) as? PlayerCell else {
            return UITableViewCell()
        }
        
        let player = presenter.player(at: indexPath)
        let vm = presenter.makePlayerViewModel(from: player)
        cell.configure(with: vm)
        return cell
    }
}


extension SquadViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                    viewForHeaderInSection section: Int) -> UIView? {
        if isLoading { return nil }
        guard let header = tableView.dequeueReusableCell(
            withIdentifier: SectionHeaderView.reuseID) as? SectionHeaderView else { return nil }
        let pos = presenter.section(at: section)
        header.configure(position: pos,
                         count: presenter.numberOfPlayers(in: section))
        return header
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat { 
        return isLoading ? 0.01 : 52 
    }

    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat { 0.01 }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading { return 80 }
        let count = presenter.numberOfPlayers(in: indexPath.section)
        return count == 0 ? 300 : 80
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard !isLoading else { return }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SquadViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PlayerCell.reuseID
    }
}
