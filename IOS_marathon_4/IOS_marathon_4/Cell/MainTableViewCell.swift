//
//  MainTableViewCell.swift
//  IOS_marathon_4
//
//  Created by Наталья Коновалова on 10.02.2024.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var isSelect = false {
        didSet {
            accessoryType = isSelect ? .checkmark : .none
        }
    }
    
    private var itemsData: ItemsData?
    private var delegate: ToggleCheckmarkProtocol?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupInitialState()
    }
    
    func configure(itemsData: ItemsData, delegate: ToggleCheckmarkProtocol) {
        numberLabel.text = "\(itemsData.number)"
        isSelect = itemsData.isSelected
        self.itemsData = itemsData
        self.delegate = delegate
    }
    
    private func setupInitialState() {
        addSubviews()
        addGestureRecognizer()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(numberLabel)
    }
    
    private func addGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCellAction))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapCellAction() {
        guard let itemsData = itemsData else { return }
        delegate?.setupCellState(model: itemsData, isSelected: !isSelect)
        isSelect.toggle()
    }
}

extension MainTableViewCell {
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        ])
    }
}
