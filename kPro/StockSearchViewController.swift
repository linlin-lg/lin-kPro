import UIKit
import SnapKit

protocol StockSearchViewControllerDelegate: AnyObject {
    func didSelectStock(_ stock: Stock)
}

class StockSearchViewController: UIViewController {
    weak var delegate: StockSearchViewControllerDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "输入股票代码或名称"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "StockCell")
        return table
    }()
    
    private var stocks: [Stock] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupUI() {
        title = "搜索股票"
        view.backgroundColor = .systemBackground
        
        // 添加取消按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelTapped))
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        let searchBarHeight: CGFloat = 56
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(searchBarHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension StockSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            stocks = []
            tableView.reloadData()
            return
        }
        
        StockService.shared.searchStocks(keyword: searchText) { [weak self] stocks in
            self?.stocks = stocks
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension StockSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath)
        let stock = stocks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(stock.name) (\(stock.symbol))"
        content.secondaryText = String(format: "¥%.2f %.2f(%.2f%%)", 
                                     stock.price, 
                                     stock.change,
                                     stock.changePercent)
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let stock = stocks[indexPath.row]
        let detailVC = StockDetailViewController()
        detailVC.stock = stock
        navigationController?.pushViewController(detailVC, animated: true)
    }
} 