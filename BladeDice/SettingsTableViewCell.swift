//
//  SettingsTableViewCell.swift
//  BladeDice
//
//  Created by Juho Pispa on 24.05.20.
//  Copyright © 2020 Juho Pispa. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsTableViewCellDelegate: AnyObject {
    func settingsTableViewCell(_ cell: SettingsTableViewCell, didToggleEnabledState isEnabled: Bool)
}

final class SettingsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "settingsTableViewCell"
    
    // MARK: - Nested Types
    
    struct ViewModel {
        let trickAttribute: Trick.TrickAttribute
        let isOn: Bool
        let isEnabled: Bool
        var title: String {
            trickAttribute.name
        }
    }
    
    // MARK: - Properties
    
    weak var delegate: SettingsTableViewCellDelegate?
    
    var viewModel: ViewModel? {
        didSet {
            updateView()
        }
    }
        
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.onTintColor = #colorLiteral(red: 0.1992070536, green: 0.2589884435, blue: 0.3781713621, alpha: 1)
        toggleSwitch.addTarget(self, action: #selector(didToggleEnabledState), for: .valueChanged)
        return toggleSwitch
    }()
    
    // MARK:  - Init/Deinit
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "settingsCell")
        selectionStyle = .none
        
        UIView.performWithoutAnimation {
            self.contentView.addSubview(label)
            self.contentView.addSubview(toggleSwitch)
            self.addConstraints()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        label.text = nil
    }
    
    // MARK: - Cell Configuration
    
    private func addConstraints() {
        // TODO: - Make into convenience
        [
            NSLayoutConstraint(
                item: label,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1,
                constant: 8
            ),
            NSLayoutConstraint(
                item: label,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .bottom,
                multiplier: 1,
                constant: -8
            ),
            NSLayoutConstraint(
                item: label,
                attribute: .leading,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .leading,
                multiplier: 1,
                constant: 16)
            ,
            NSLayoutConstraint(
                item: label,
                attribute: .trailing,
                relatedBy: .greaterThanOrEqual,
                toItem: toggleSwitch,
                attribute: .leading,
                multiplier: 1,
                constant: 8
            ),
            NSLayoutConstraint(
                item: toggleSwitch,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1,
                constant: 8
            ),
            NSLayoutConstraint(
                item: toggleSwitch,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .bottom,
                multiplier: 1,
                constant: -8
            ),
            NSLayoutConstraint(
                item: toggleSwitch,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .trailing,
                multiplier: 1,
                constant: -16
            ),
        ].forEach {
            contentView.addConstraint($0)
            $0.isActive = true
        }
    }
    
    func updateView() {
        guard let viewModel = viewModel else {
            return
        }

        label.text = viewModel.title
        toggleSwitch.setOn(viewModel.isOn, animated: false)
        toggleSwitch.isEnabled = viewModel.isEnabled
    }
    
    // MARK: - Action
    
    @objc private func didToggleEnabledState() {
        delegate?.settingsTableViewCell(self, didToggleEnabledState: toggleSwitch.isOn)
    }
    
}
