//
//  SettingsTableViewSectionHeaderView.swift
//  BladeDice
//
//  Created by Juho Pispa on 11.04.22.
//  Copyright © 2022 Juho Pispa. All rights reserved.
//

import Foundation
import UIKit

final class SettingsTableViewSectionHeaderView: UIView {
    
    // MARK: - Nested Types
    
    struct ViewModel {
        let trickAttributeType: Trick.TrickAttribute.TrickAttributeType
        var title: String {
            trickAttributeType.name
        }
    }
    
    // MARK: - Properties
        
    var viewModel: ViewModel? {
        didSet {
            updateView()
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
        
    // MARK:  - Init/Deinit
    
    init() {
        super.init(frame: .zero)
        addSubview(label)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Configuration
    
    private func addConstraints() {
        // TODO: - Make into convenience
        [
            NSLayoutConstraint(
                item: label,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 8
            ),
            NSLayoutConstraint(
                item: label,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant: -8
            ),
            NSLayoutConstraint(
                item: label,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1,
                constant: 16)
            ,
            NSLayoutConstraint(
                item: label,
                attribute: .trailing,
                relatedBy: .greaterThanOrEqual,
                toItem: self,
                attribute: .leading,
                multiplier: 1,
                constant: 16
            )
        ].forEach {
            self.addConstraint($0)
            $0.isActive = true
        }
    }
    
    func updateView() {
        guard let viewModel = viewModel else {
            return
        }

        label.text = viewModel.title
        label.sizeToFit()
    }
        
}

