//
//  ScrollableStackView.swift
//  StoryboardPlayground
//
//  Created by Guilherme Pereira on 2/3/25.
//

import UIKit

class ScrollableStackView: UIView {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16 // Adjust spacing as needed
        stackView.alignment = .fill // Or .leading, .center, .trailing as needed
        stackView.distribution = .fill // Or .equalSpacing, .equalCentering, .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        // Scroll View Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Stack View Constraints (Important for scrolling!)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Critical: Widths must match for horizontal scrolling to be disabled, and for vertical scrolling to work properly.
        ])
    }

    func addArrangedSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
}
