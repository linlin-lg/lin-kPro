//
//  SettingsViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import UIKit
import SwiftUI
import Foundation

class SettingsViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .systemGroupedBackground
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SwitchCell")
        return table
    }()
    
    // MARK: - Properties
    private var settingsData: [[SettingItem]] = []
    private var isShowSetting: Bool = false
    private var isShowSpecialButton: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 异步获取配置
        ConfigManager.shared.fetchConfig { [weak self] config in
            self?.isShowSetting = ConfigManager.shared.isShowSetting
            self?.isShowSpecialButton = ConfigManager.shared.isShowSpecialButton
            self?.setupSettingsData()
            self?.tableView.reloadData()
        }
        setupSettingsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "设置"
        view.backgroundColor = .systemGroupedBackground
        
        // Navigation
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSettingsData() {
        var section1: [SettingItem] = [
            SettingItem(title: "外观", subtitle: "选择应用的外观模式", type: .appearance, icon: "moon.fill")
        ]
        
        if isShowSetting {
            section1.append(SettingItem(title: "设置", subtitle: "特殊功能开关", type: .setting, icon: "gearshape.fill"))
        }
        
        if isShowSpecialButton {
            section1.append(SettingItem(title: "特殊功能", subtitle: "高级设置选项", type: .special, icon: "star.fill"))
        }
        
        settingsData = [
            section1,
            [
                SettingItem(title: "SwiftUI Demo", subtitle: "学习 SwiftUI 核心概念", type: .swiftUIDemo, icon: "swift")
            ],
            [
                SettingItem(title: "关于", subtitle: "版本信息和开发者", type: .about, icon: "info.circle.fill"),
                SettingItem(title: "反馈", subtitle: "发送反馈和建议", type: .feedback, icon: "envelope.fill")
            ],
            [
                SettingItem(title: "缓存管理", subtitle: "查看和清除配置缓存", type: .cache, icon: "internaldrive.fill")
            ]
        ]
    }
    
    // MARK: - Actions
    @objc private func toggleDarkMode(_ sender: UISwitch) {
        let userInterfaceStyle: UIUserInterfaceStyle = sender.isOn ? .dark : .light
        
        // 保存用户偏好
        UserDefaults.standard.set(userInterfaceStyle.rawValue, forKey: "UserInterfaceStyle")
        
        // 应用外观变化
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
        
        // 添加切换动画
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .systemGroupedBackground
        }
    }
    
    private func showAbout() {
        let alert = UIAlertController(title: "关于 kPro", message: "版本 1.0.0\n\n一个简洁优雅的备忘录应用\n\n开发者: KPLiOS", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showFeedback() {
        let alert = UIAlertController(title: "反馈", message: "感谢您的使用！\n\n如有问题或建议，请通过以下方式联系我们：\n\n邮箱: feedback@kpro.app", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showSpecialFeature() {
        let alert = UIAlertController(title: "特殊功能", message: "这是一个受版本控制的功能！\n当前App版本: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showSwiftUIDemo() {
        let swiftUIView = SwiftUIDemoView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    private func showCacheManagement() {
        let cacheInfo = ConfigManager.shared.getCacheInfo()
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        
        var message = "当前App版本: \(currentVersion)\n\n"
        message += "缓存状态:\n"
        message += "• 是否有缓存: \(cacheInfo.hasCache ? "是" : "否")\n"
        message += "• 缓存是否过期: \(cacheInfo.isExpired ? "是" : "否")\n"
        
        if let lastFetchTime = cacheInfo.lastFetchTime {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            message += "• 最后更新时间: \(formatter.string(from: lastFetchTime))\n"
        }
        
        let alert = UIAlertController(title: "缓存管理", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "清除缓存", style: .destructive) { _ in
            ConfigManager.shared.clearCache()
            let successAlert = UIAlertController(title: "成功", message: "缓存已清除，下次启动将重新获取配置", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "确定", style: .default))
            self.present(successAlert, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "刷新配置", style: .default) { _ in
            ConfigManager.shared.clearCache()
            ConfigManager.shared.fetchConfig { [weak self] _ in
                self?.isShowSetting = ConfigManager.shared.isShowSetting
                self?.isShowSpecialButton = ConfigManager.shared.isShowSpecialButton
                self?.setupSettingsData()
                self?.tableView.reloadData()
                
                let refreshAlert = UIAlertController(title: "成功", message: "配置已刷新", preferredStyle: .alert)
                refreshAlert.addAction(UIAlertAction(title: "确定", style: .default))
                self?.present(refreshAlert, animated: true)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingsData[indexPath.section][indexPath.row]
        
        switch item.type {
        case .appearance:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = UIImage(systemName: item.icon)
            cell.imageView?.tintColor = .systemBlue
            
            // 创建开关
            let switchControl = UISwitch()
            switchControl.isOn = UserDefaults.standard.integer(forKey: "UserInterfaceStyle") == UIUserInterfaceStyle.dark.rawValue
            switchControl.addTarget(self, action: #selector(toggleDarkMode(_:)), for: .valueChanged)
            cell.accessoryView = switchControl
            
            return cell
            
        case .setting:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = UIImage(systemName: item.icon)
            cell.imageView?.tintColor = .systemGreen
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .special:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = UIImage(systemName: item.icon)
            cell.imageView?.tintColor = .systemOrange
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .swiftUIDemo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = UIImage(systemName: item.icon)
            cell.imageView?.tintColor = .systemOrange
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case .cache:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = UIImage(systemName: item.icon)
            cell.imageView?.tintColor = .systemPurple
            cell.accessoryType = .disclosureIndicator
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.imageView?.image = UIImage(systemName: item.icon)
            cell.imageView?.tintColor = .systemBlue
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = settingsData[indexPath.section][indexPath.row]
        
        switch item.type {
        case .about:
            showAbout()
        case .feedback:
            showFeedback()
        case .setting:
            let alert = UIAlertController(title: "设置", message: "你点击了设置按钮！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default))
            present(alert, animated: true)
        case .special:
            showSpecialFeature()
        case .swiftUIDemo:
            showSwiftUIDemo()
        case .cache:
            showCacheManagement()
        default:
            break
        }
    }
}

// MARK: - SettingItem
struct SettingItem {
    let title: String
    let subtitle: String
    let type: SettingType
    let icon: String
}

enum SettingType {
    case appearance
    case about
    case feedback
    case setting
    case special
    case cache
    case swiftUIDemo
} 