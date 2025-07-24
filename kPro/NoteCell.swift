//
//  NoteCell.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import UIKit

class NoteCell: UITableViewCell {
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
        view.clipsToBounds = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let tagsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let colorIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Add subviews
        contentView.addSubview(containerView)
        containerView.addSubview(colorIndicatorView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(tagsStackView)
        
        // Setup constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        colorIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            colorIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            colorIndicatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            colorIndicatorView.widthAnchor.constraint(equalToConstant: 8),
            colorIndicatorView.heightAnchor.constraint(equalToConstant: 8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: colorIndicatorView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            dateLabel.widthAnchor.constraint(equalToConstant: 80),
            
            tagsStackView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            tagsStackView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            tagsStackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12),
            tagsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            tagsStackView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Configuration
    func configure(with note: Note) {
        titleLabel.text = note.title.isEmpty ? "无标题" : note.title
        
        // 显示内容预览
        let content = note.content.trimmingCharacters(in: .whitespacesAndNewlines)
        if content.isEmpty {
            contentLabel.text = "无内容"
        } else {
            contentLabel.text = content
        }
        
        // 格式化日期
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: note.modifiedAt)
        
        // 设置颜色
        containerView.backgroundColor = note.color.uiColor
        colorIndicatorView.backgroundColor = note.color.accentColor
        
        // 设置标签
        setupTags(note.tags)
        
        // 添加动画效果
        animateCellAppearance()
    }
    
    private func setupTags(_ tags: [String]) {
        // 清除现有标签
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 添加新标签
        for tag in tags.prefix(3) { // 最多显示3个标签
            let tagLabel = createTagLabel(tag)
            tagsStackView.addArrangedSubview(tagLabel)
        }
    }
    
    private func createTagLabel(_ tag: String) -> UILabel {
        let label = UILabel()
        label.text = "#\(tag)"
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .systemBlue
        label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.padding = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        return label
    }
    
    private func animateCellAppearance() {
        containerView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        containerView.alpha = 0.8
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
            self.containerView.transform = .identity
            self.containerView.alpha = 1.0
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentLabel.text = nil
        dateLabel.text = nil
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        containerView.backgroundColor = .systemBackground
        colorIndicatorView.backgroundColor = .systemBlue
    }
}

// MARK: - UILabel Extension for Padding
extension UILabel {
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets.zero
        }
        set {
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(paddingView)
            
            NSLayoutConstraint.activate([
                paddingView.topAnchor.constraint(equalTo: self.topAnchor, constant: -newValue.top),
                paddingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: newValue.bottom),
                paddingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -newValue.left),
                paddingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: newValue.right)
            ])
        }
    }
} 