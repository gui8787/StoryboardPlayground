//
//  CustomCollectionView.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//

import UIKit

class CustomCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var games: [Game] = StorageManager.shared.loadItems() // Load all games
    
    private let cellIdentifier = "ScrollCell" // Reuse identifiers
    private let headerIdentifier = "SectionHeader"
    
    let sectionHeaderHeight: CGFloat = 40 // Height of the header
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Vertical scrolling
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HorizontalScrollView.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HorizontalScrollView
        cell.cellItems = games
        cell.isFavoritesSection = indexPath.section == 0
        
        cell.onFavoriteButtonTapped = { [weak self] gameTitle, isFavorite in
            guard let self = self else { return }
            
            if let gameIndex = self.games.firstIndex(where: { $0.title == gameTitle }) {
                self.games[gameIndex].isFavorite = isFavorite
                StorageManager.shared.saveMyGames(self.games)
                
                // Reload relevant sections in both HorizontalScrollViews
                let favoriteSectionIndex = 0
                let nonFavoriteSectionIndex = 1
                
                if let favoriteCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: favoriteSectionIndex)) as? HorizontalScrollView,
                   let nonFavoriteCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: nonFavoriteSectionIndex)) as? HorizontalScrollView {
                    nonFavoriteCell.updateCells(with: self.games)
                    favoriteCell.updateCells(with: self.games)
                }
            }
        }
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout methods (for the vertical collection view)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let superview = collectionView.superview else {
            return CGSize(width: collectionView.frame.width, height: 400)
        }
        let safeAreaHeight = superview.safeAreaLayoutGuide.layoutFrame.height
        let availableHeight = safeAreaHeight - sectionHeaderHeight * 2 // Account for two headers

        // Divide available height by the number of sections
        let heightPerSection = max(availableHeight / 2, 400)
        return CGSize(width: collectionView.frame.width, height: heightPerSection)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: sectionHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SectionHeaderView
            headerView.titleLabel.text = indexPath.section == 0 ? "Favorites" : "All Games"
            return headerView
        }
        return UICollectionReusableView() // Return an empty view for other supplementary views
    }
}


class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
