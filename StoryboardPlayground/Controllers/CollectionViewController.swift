//
//  CollectionViewController.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//

import UIKit

class CollectionViewController: UIViewController {
    
    private let customCollectionView = CustomCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customCollectionView)
        
        NSLayoutConstraint.activate([
            customCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
