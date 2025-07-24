//
//  LaunchViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import UIKit

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
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),
            
            loadingIndicator.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
} 