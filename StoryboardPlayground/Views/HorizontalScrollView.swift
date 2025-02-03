//
//  HorizontalScrollView.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//

import UIKit

class HorizontalScrollView: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var cellItems: [Game] = []
    
    var isFavoritesSection: Bool = false
    
    private lazy var cellsInSection = cellItems.filter { $0.isFavorite == isFavoritesSection }
    
    var horizontalCollectionView: UICollectionView!
    
    var onFavoriteButtonTapped: ((String, Bool) -> Void)? // Closure now takes game title
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Create compositional layout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(1.0), heightDimension:.fractionalHeight(0.5)) // 2 items vertically
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.4), heightDimension:.fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) // Vertical group for each column
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous // Enable horizontal scrolling for the section
            return section
        }
        
        horizontalCollectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.alwaysBounceVertical = false
        horizontalCollectionView.backgroundColor = .darkGray
        contentView.addSubview(horizontalCollectionView)
        
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            horizontalCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.register(HorizontalItemCell.self, forCellWithReuseIdentifier: "HorizontalItemCell") // Register inner cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCells(with games: [Game]) {
        let oldItems = cellsInSection
        
        var itemsToInsert: [IndexPath] = []
        var itemsToDelete: [IndexPath] = []
        
        // Identify items to insert
        for game in games {
            if game.isFavorite == isFavoritesSection && !oldItems.contains(game) {
                // Calculate the index in cellsInSection
                let insertIndex = cellsInSection.firstIndex(where: { $0.title >= game.title }) ?? cellsInSection.count
                itemsToInsert.append(IndexPath(item: insertIndex, section: 0))
            }
        }
        
        // Identify items to delete
        for (index, game) in oldItems.enumerated() {
            if game.isFavorite != isFavoritesSection || !games.contains(game) {
                itemsToDelete.append(IndexPath(item: index, section: 0))
            }
        }
        
        // Update the data source
        cellsInSection = games.filter { $0.isFavorite == isFavoritesSection }
        cellItems = games
        
        // Perform batch updates with animations
        horizontalCollectionView.performBatchUpdates {
            horizontalCollectionView.insertItems(at: itemsToInsert)
            horizontalCollectionView.deleteItems(at: itemsToDelete)
        }
    }
    
    // UICollectionViewDataSource methods (for the horizontal collection view)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellsInSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalItemCell", for: indexPath) as! HorizontalItemCell
        let game = cellsInSection[indexPath.row]
        cell.label.text = game.title
        cell.imageView.image = UIImage(named: game.imageName) ?? UIImage(systemName: "photo")
        cell.favoriteButton.isSelected = game.isFavorite
        
        cell.onFavoriteButtonTapped = { [weak self] isFavorite in
            self?.onFavoriteButtonTapped?(game.title, isFavorite) // Pass game title to the closure
        }
        return cell
    }
}

// Inner Cell for Horizontal Items
class HorizontalItemCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type:.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for:.normal)
        button.setImage(UIImage(systemName: "heart.fill"), for:.selected)
        button.tintColor = .red
        button.imageView?.contentMode = .scaleAspectFit
        let largerConfig = UIImage.SymbolConfiguration(scale: .large)
        button.setPreferredSymbolConfiguration(largerConfig, forImageIn:.normal)
        button.setPreferredSymbolConfiguration(largerConfig, forImageIn:.selected)
        
        return button
    }()
    
    var onFavoriteButtonTapped: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.addSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for:.touchUpInside)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            // Label Constraints (overlay on the image view or below it)
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButton.isSelected.toggle()
        onFavoriteButtonTapped?(favoriteButton.isSelected)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
