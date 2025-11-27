//
//  LaunchViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import UIKit
import SnapKit
import MyLocalLibrary

class LaunchViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "note.text")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "备忘录"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "记录生活中的每一个重要时刻"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemBlue
        indicator.alpha = 0
        return indicator
    }()
    
    private let backgroundGradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemBackground.cgColor,
            UIColor.systemBlue.withAlphaComponent(0.1).cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAnimations()
        
        // 使用本地库的示例
        demonstrateLocalLibrary()
        
        // 延迟3秒后跳转到主页面
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.showMainInterface()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundGradientLayer.frame = view.bounds
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 添加背景渐变
        view.layer.insertSublayer(backgroundGradientLayer, at: 0)
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(loadingIndicator)

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.width.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(40)
            make.trailing.lessThanOrEqualToSuperview().inset(40)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    private func startAnimations() {
        // 初始状态
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        logoImageView.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        titleLabel.alpha = 0
        
        // Logo动画
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [], animations: {
            self.logoImageView.transform = .identity
            self.logoImageView.alpha = 1
        })
        
        // 标题动画
        UIView.animate(withDuration: 0.6, delay: 0.6, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.titleLabel.transform = .identity
            self.titleLabel.alpha = 1
        })
        
        // 副标题动画
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
            self.subtitleLabel.alpha = 1
        })
        
        // 加载指示器动画
        UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
            self.loadingIndicator.alpha = 1
        }) { _ in
            self.loadingIndicator.startAnimating()
        }
        
        // 背景动画
        animateBackground()
    }
    
    private func animateBackground() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.5, 1.0]
        animation.toValue = [0.0, 0.8, 1.0]
        animation.duration = 2.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        backgroundGradientLayer.add(animation, forKey: "gradientAnimation")
    }
    
    private func showMainInterface() {
        // 停止加载动画
        loadingIndicator.stopAnimating()
        
        // 退出动画
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.logoImageView.alpha = 0
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: -30)
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
            self.loadingIndicator.alpha = 0
        }) { _ in
            let noteListVC = NoteListViewController()
            let navigationController = UINavigationController(rootViewController: noteListVC)
            
            // 使用全屏转场
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            
            self.present(navigationController, animated: true)
        }
    }
    
    // MARK: - 本地库使用示例
    private func demonstrateLocalLibrary() {
        // 获取库信息
        let libraryInfo = MyLocalLibrary.getInfo()
        print("📚 本地库信息: \(libraryInfo)")
        
        // 数学计算示例
        let sum = MyLocalLibrary.add(10, 20)
        print("🧮 数学计算: 10 + 20 = \(sum)")
        
        // 获取当前时间
        let currentTime = MyLocalLibrary.getCurrentTimeString()
        print("⏰ 当前时间: \(currentTime)")
        
        // 生成随机字符串
        let randomString = MyLocalLibrary.generateRandomString(length: 6)
        print("🎲 随机字符串: \(randomString)")
    }
} 