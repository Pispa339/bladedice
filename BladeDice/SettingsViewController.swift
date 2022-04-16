//
//  SettingsViewController.swift
//  BladeDice
//
//  Created by Juho Pispa on 24.05.20.
//  Copyright © 2020 Juho Pispa. All rights reserved.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {
    
    typealias TrickAttribute = Trick.TrickAttribute
    typealias TrickAttributeType = Trick.TrickAttribute.TrickAttributeType
    
    typealias DataSource = UITableViewDiffableDataSource<TrickAttributeType, TrickAttribute>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TrickAttributeType, TrickAttribute>
    
    // MARK: - UIViews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Properties
    
    private let trickContext = TrickContext.shared
    
    lazy var datasource: DataSource = {
            let datasource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, trickAttribute) -> SettingsTableViewCell? in
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as? SettingsTableViewCell
                else {
                    return SettingsTableViewCell()
                }
                
                let isOn = (self.trickContext.trickAttributesByEnabledState[trickAttribute] ?? true)
                let isEnabled = self.trickContext.canDisableTrickAttribute(trickAttribute) || !isOn
                let cellViewModel = SettingsTableViewCell.ViewModel(trickAttribute: trickAttribute, isOn: isOn, isEnabled: isEnabled)
                cell.viewModel = cellViewModel
                cell.delegate = self

                return cell
            })
            datasource.defaultRowAnimation = .fade
            return datasource
        }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.dataSource = datasource
        addConstraints()
        setupNavigatioBar()
        
        reloadTableView(animated: false)
    }
        
    // MARK: - Methods
    
    private func reloadTableView(animated: Bool) {
        var dataSourceSnapshot = makeDataSourceSnapshot()
        if #available(iOS 15.0, *) {
            dataSourceSnapshot.reconfigureItems(dataSourceSnapshot.itemIdentifiers)
        }
        datasource.apply(dataSourceSnapshot, animatingDifferences: true)
    }
    
    private func makeDataSourceSnapshot() -> DataSourceSnapshot {
        var snapshot = DataSourceSnapshot()
        for trickAttributeType in trickContext.trickCatalog.trickAttributeTypes {
            snapshot.appendSections([trickAttributeType])
            snapshot.appendItems(trickContext.trickCatalog.trickAttributesByType[trickAttributeType] ?? [], toSection: trickAttributeType)
        }
        return snapshot
    }
    
    // MARK: - Actions
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let trickAttributeType = trickContext.trickCatalog.trickAttributeTypes[section]
        
        let headerViewModel = SettingsTableViewSectionHeaderView.ViewModel(trickAttributeType: trickAttributeType)
        let headerView = SettingsTableViewSectionHeaderView()
        
        headerView.viewModel = headerViewModel
        
        return headerView
    }
    
}

extension SettingsViewController: SettingsTableViewCellDelegate {
        
    func settingsTableViewCell(_ cell: SettingsTableViewCell, didToggleEnabledState isEnabled: Bool) {
        guard let trickAttribute = cell.viewModel?.trickAttribute else {
            return
        }
        
        trickContext.updateEnabledState(forTrickAttribute: trickAttribute, isEnabled: isEnabled)
        reloadTableView(animated: true)
    }
    
}

// MARK: - UI Updating

private extension SettingsViewController {
    
    func setupNavigatioBar() {
        let closeBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapCloseButton)
        )
        
        closeBarButtonItem.tintColor = #colorLiteral(red: 0.07690180093, green: 0.3368766904, blue: 0.8512585759, alpha: 1)
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }

    func addConstraints() {
        [
            NSLayoutConstraint(
                item: tableView,
                attribute: .top,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide,
                attribute: .top,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide,
                attribute: .leading,
                multiplier: 1,
                constant: 0)
            ,
            NSLayoutConstraint(
                item: tableView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide,
                attribute: .trailing,
                multiplier: 1,
                constant: 0
            ),
            NSLayoutConstraint(
                item: tableView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0
            )
        ].forEach {
            view.addConstraint($0)
            $0.isActive = true
        }
    }
    
}
