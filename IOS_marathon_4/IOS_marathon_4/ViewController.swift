//
//  ViewController.swift
//  IOS_marathon_4
//
//  Created by Наталья Коновалова on 10.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private enum Constants {
        static let viewTitle = "Task 4"
        static let buttonTitle = "Shuffle"
        static let mainTableViewCell = "MainTableViewCell"
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Int, ItemsData>?
    private var itemsData = (0...30).map { ItemsData(number: $0, isSelected: false) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
    
    private func setupInitialState() {
        setupViewSettings()
        setupTableViewSettings()
        setupDataSource()
        reloadData()
        setupConstraints()
    }
    
    private func setupViewSettings() {
        view.backgroundColor = .systemGray6
        title = Constants.viewTitle
        view.addSubview(tableView)
    }
    
    private func setupTableViewSettings() {
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: Constants.mainTableViewCell)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Constants.buttonTitle,
            style: .plain,
            target: self,
            action: #selector(shuffleButtonAction))
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, ItemsData>(tableView: tableView)
        { (tableView, indexPath, model) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.mainTableViewCell,
                for: indexPath
            ) as? MainTableViewCell else
            { return UITableViewCell() }
            cell.configure(itemsData: model, delegate: self)
            return cell
        }
    }
    
    private func reloadData(isAnimated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ItemsData>()
        snapshot.appendSections([0])
        snapshot.appendItems(itemsData)
        dataSource?.defaultRowAnimation = .left
        dataSource?.apply(snapshot, animatingDifferences: isAnimated)
    }
    
    @objc private func shuffleButtonAction() {
        itemsData.shuffle()
        reloadData()
    }
}

extension ViewController {
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: ToggleCheckmarkProtocol {
    
    func setupCellState(model: ItemsData, isSelected: Bool) {
        guard let index = itemsData.firstIndex(of: model) else { return }
        itemsData.remove(at: index)
        itemsData.insert(.init(number: model.number, isSelected: isSelected),
                         at: isSelected ? 0 : index)
        reloadData(isAnimated: isSelected)
    }
}

protocol ToggleCheckmarkProtocol {
    
    func setupCellState(model: ItemsData, isSelected: Bool)
}
