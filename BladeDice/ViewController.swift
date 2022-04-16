//
//  ViewController.swift
//  BladeDice
//
//  Created by Juho Pispa on 24.05.20.
//  Copyright © 2020 Juho Pispa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
        
    private let trickSpinLabel = UILabel()
    private let trickSideLabel = UILabel()
    private let trickBaseLabel = UILabel()
    
    var labels: [UILabel] {
        [trickSpinLabel, trickSideLabel, trickBaseLabel]
    }
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        labels.forEach {
            $0.contentMode = .center
            $0.font = .systemFont(ofSize: 20.0)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
        
        return stackView
    } ()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(contentStackView)
        
        configureConstraints()
        configureNavigationBar()
        configureGestureRecognizers()
        
        refreshTrickLabels()
    }
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        title = "Blade Dice"
        let settingsButtonBarItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(presentSettingsViewController))
        navigationItem.rightBarButtonItem = settingsButtonBarItem
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.07690180093, green: 0.3368766904, blue: 0.8512585759, alpha: 1)
    }
    
    private func configureConstraints() {
        let verticalMargin: CGFloat = 30
        let horizontalMargin: CGFloat = 12
        
        let constraints = [
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalMargin),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalMargin),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalMargin),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: contentStackView.bottomAnchor, constant: -verticalMargin),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureGestureRecognizers() {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(refreshTrickLabels))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(refreshTrickLabels))
        
        view.addGestureRecognizer(swipeGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc private func refreshTrickLabels() {
        self.trickSpinLabel.alpha = 0.5
        self.trickSideLabel.alpha = 0.5
        self.trickBaseLabel.alpha = 0.5
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionCrossDissolve, .curveEaseIn, .autoreverse], animations: {
            let newTrick = TrickGenerator.shared.makeRandomTrick()
            self.trickSpinLabel.text = newTrick?.spin.rawValue
            self.trickSideLabel.text = newTrick?.side.rawValue
            self.trickBaseLabel.text = newTrick?.trickBase.rawValue
            self.trickSpinLabel.alpha = 0.5
            self.trickSideLabel.alpha = 0.5
            self.trickBaseLabel.alpha = 0.5
        }, completion: { success in
            self.labels.forEach { $0.isHidden = $0.text == "" }
            self.trickSpinLabel.alpha = 1.0
            self.trickSideLabel.alpha = 1.0
            self.trickBaseLabel.alpha = 1.0
        })
    }
    
    @objc private func presentSettingsViewController() {
        let settingsViewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        present(navigationController, animated: true)
    }

}

