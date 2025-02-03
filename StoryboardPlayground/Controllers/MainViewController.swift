//
//  MainViewController.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 1/30/25.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollableStackView = ScrollableStackView()
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollableStackView)

        NSLayoutConstraint.activate([
            scrollableStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollableStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollableStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Add your views to the stack view
        for i in 1...20 { // Example: Adding 20 labels
            let label = UILabel()
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            label.text = "Label \(i)"
            label.numberOfLines = 0
            scrollableStackView.addArrangedSubview(label)
        }
    }


}

