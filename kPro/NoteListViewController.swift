//
//  NoteListViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import UIKit
import SnapKit

class NoteListViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(NoteCell.self, forCellReuseIdentifier: "NoteCell")
        table.separatorStyle = .none
        table.backgroundColor = .systemGroupedBackground
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "搜索备忘录"
        search.searchBar.tintColor = .systemBlue
        return search
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "新建备忘录", image: UIImage(systemName: "note.text")) { [weak self] _ in
                self?.addNoteTapped()
            },
            UIAction(title: "添加股票", image: UIImage(systemName: "chart.line.uptrend.xyaxis")) { [weak self] _ in
                self?.addStockTapped()
            }
        ])
        
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), menu: menu)
        button.tintColor = .systemBlue
        return button
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        button.tintColor = .systemBlue
        return button
    }()
    
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "note.text")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = "暂无备忘录"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .systemGray
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "点击右上角的 + 按钮创建你的第一个备忘录"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .systemGray2
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.height.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(40)
            make.trailing.lessThanOrEqualToSuperview().inset(40)
        }
        
        return view
    }()
    
    // MARK: - Properties
    private var notes: [Note] = []
    private var filteredNotes: [Note] = []
    private var isSearching: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNotes()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "备忘录"
        view.backgroundColor = .systemGroupedBackground
        
        // Navigation
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItems = [addButton, settingsButton]
        definesPresentationContext = true
        
        // 设置导航栏样式
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label
        ]
        
        // TableView
        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Data
    private func loadNotes() {
        notes = NoteManager.shared.getAllNotes()
        updateEmptyState()
        tableView.reloadData()
        
        // 添加刷新动画
        if !notes.isEmpty {
            animateTableAppearance()
        }
    }
    
    private func updateEmptyState() {
        let shouldShowEmpty = notes.isEmpty && !isSearching
        emptyStateView.isHidden = !shouldShowEmpty
        tableView.isHidden = shouldShowEmpty
    }
    
    private func animateTableAppearance() {
        tableView.alpha = 0
        tableView.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.tableView.alpha = 1
            self.tableView.transform = .identity
        })
    }
    
    // MARK: - Actions
    @objc private func addNoteTapped() {
        let editVC = NoteEditViewController()
        editVC.delegate = self
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc private func addStockTapped() {
        let stockSearchVC = StockSearchViewController()
        stockSearchVC.delegate = self
        let nav = UINavigationController(rootViewController: stockSearchVC)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        let nav = UINavigationController(rootViewController: settingsVC)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredNotes.count : notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteCell
        let note = isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
        cell.configure(with: note)
        
        // 添加延迟动画
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 20)
        
        UIView.animate(withDuration: 0.3, delay: Double(indexPath.row) * 0.1, options: [], animations: {
            cell.alpha = 1
            cell.transform = .identity
        })
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let note = isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
        let editVC = NoteEditViewController(note: note)
        editVC.delegate = self
        let nav = UINavigationController(rootViewController: editVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = isSearching ? filteredNotes[indexPath.row] : notes[indexPath.row]
            
            // 添加删除确认
            let alert = UIAlertController(title: "删除备忘录", message: "确定要删除这个备忘录吗？", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "删除", style: .destructive) { _ in
                NoteManager.shared.deleteNote(withId: note.id)
                self.loadNotes()
            })
            
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UISearchResultsUpdating
extension NoteListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredNotes = NoteManager.shared.searchNotes(query: searchText)
        updateEmptyState()
        tableView.reloadData()
    }
}

// MARK: - NoteEditDelegate
extension NoteListViewController: NoteEditDelegate {
    func didSaveNote() {
        loadNotes()
    }
}

// MARK: - StockSearchViewControllerDelegate
extension NoteListViewController: StockSearchViewControllerDelegate {
    func didSelectStock(_ stock: Stock) {
        let detailVC = StockDetailViewController()
        detailVC.stock = stock
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
} 
