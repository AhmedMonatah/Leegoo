//
//  SquadViewController.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//


import UIKit
import SDWebImage

final class SquadViewController: UIViewController {

    private var isLoading = false
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
        presenter.viewDidLoad()
    }





    private func applyFilterStyle() {
        let buttons = [filterAllButton, filterGKButton, filterDefButton,
                       filterMidButton, filterFwdButton]
        let accent  = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)

        for btn in buttons {
            guard let btn = btn else { continue }
            let isActive = btn.tag == presenter.activeFilterTag
            btn.backgroundColor = isActive ? accent : .white
            btn.setTitleColor(isActive ? .white : UIColor.darkGray, for: .normal)
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
        tableView.reloadData()
    }
    
    func hideLoading() {
        isLoading = false
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showTeamDetails(_ team: Team) {
        teamNameLabel.text = team.teamName
        let parts = (team.teamName ?? "").split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        teamInitialsLabel.text = initials.isEmpty ? "?" : initials.uppercased()
        if let logoUrlString = team.teamLogo, let url = URL(string: logoUrlString) {
            teamLogoImageView.sd_setImage(with: url, placeholderImage: nil, completed: { [weak self] img, _, _, _ in
                self?.teamInitialsLabel.isHidden = (img != nil)
            })
        }
        
        teamIDLabel.text = "\(team.teamKey ?? 0)"
        
        let players = team.players ?? []
        totalPlayersLabel.text = "\(players.count)"
        goalkeepersCountLabel.text = "\(players.filter { $0.position == .goalkeeper }.count)"
        defendersCountLabel.text = "\(players.filter { $0.position == .defender }.count)"
        
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
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PlayerCell.reuseID, for: indexPath) as? PlayerCell else {
                return UITableViewCell()
            }
            cell.contentView.showSkeleton()
            return cell
        }
        
        let count = presenter.numberOfPlayers(in: indexPath.section)
        
        if count == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NoDataTableViewCell.reuseID, for: indexPath) as? NoDataTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PlayerCell.reuseID, for: indexPath) as? PlayerCell else {
            return UITableViewCell()
        }
        
        cell.contentView.hideSkeleton()
        let player = presenter.player(at: indexPath)
        cell.configure(with: player)
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
