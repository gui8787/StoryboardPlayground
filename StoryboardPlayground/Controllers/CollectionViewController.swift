//
//  CollectionViewController.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//

import UIKit

class ScrollableCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let cellIdentifier = "ScrollCell" // Reuse identifier
    private let headerIdentifier = "SectionHeader"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout() // Or a custom layout
        layout.scrollDirection = .vertical // Vertical scrolling
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground // Or your preferred background color
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
        collectionView.register(HorizontalScrollCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HorizontalScrollCell
        return cell // The HorizontalScrollCell handles its own data and layout
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! SectionHeaderView
            headerView.titleLabel.text = "Section \(indexPath.section + 1)" // Set header title
            return headerView
        }
        return UICollectionReusableView() // Return an empty view for other supplementary views
    }
    
    // UICollectionViewDelegateFlowLayout methods (for the vertical collection view)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250) // Height of the horizontal cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
}

class HorizontalScrollCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    var horizontalCollectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Create compositional layout
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(1.0), heightDimension:.fractionalHeight(0.5)) // 4 items per row
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension:.fractionalWidth(0.2), heightDimension:.fractionalHeight(1.0)) // 3 rows per cell
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item]) // Vertical group for each column

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous // Enable horizontal scrolling for the section
            return section
        }
        
        horizontalCollectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        horizontalCollectionView.backgroundColor = .lightGray
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
    
    // UICollectionViewDataSource methods (for the horizontal collection view)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12 // Example: 5 items in each horizontal cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalItemCell", for: indexPath) as! HorizontalItemCell
        cell.label.text = "Item \(indexPath.row + 1)"
        cell.imageView.image = UIImage(systemName: "photo")
        return cell
    }
}

// Inner Cell for Horizontal Items
class HorizontalItemCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        contentView.addSubview(label) // Add both views

        NSLayoutConstraint.activate([
            // Image View Constraints (adjust as needed)
            //imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -25),

            // Label Constraints (overlay on the image view or below it)
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16), // Adjust padding
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Example Usage (in your view controller)
class CollectionViewController: UIViewController {
    
    private let scrollableCollectionView = ScrollableCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollableCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollableCollectionView)
        
        NSLayoutConstraint.activate([
            scrollableCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollableCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollableCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
