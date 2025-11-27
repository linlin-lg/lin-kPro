//
//  NoteEditViewController.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import UIKit

protocol NoteEditDelegate: AnyObject {
    func didSaveNote()
}

class NoteEditViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "标题"
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.delegate = self
        return textField
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return textView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("选择颜色", for: .normal)
        button.setImage(UIImage(systemName: "paintbrush"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tagsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("添加标签", for: .normal)
        button.setImage(UIImage(systemName: "tag"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(tagsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Properties
    private var note: Note?
    private var isNewNote: Bool {
        return note == nil
    }
    weak var delegate: NoteEditDelegate?
    private var selectedColor: NoteColor = .default
    private var selectedTags: [String] = []
    
    // MARK: - Initialization
    init(note: Note? = nil) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNote()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveNote()
        print("234")
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Navigation
        title = isNewNote ? "新建备忘录" : "编辑备忘录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        // Add subviews
        view.addSubview(titleTextField)
        view.addSubview(separatorView)
        view.addSubview(buttonsStackView)
        view.addSubview(tagsStackView)
        view.addSubview(contentTextView)
        
        buttonsStackView.addArrangedSubview(colorButton)
        buttonsStackView.addArrangedSubview(tagsButton)
        
        // Setup constraints
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        tagsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            separatorView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            buttonsStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 12),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 36),
            
            tagsStackView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 8),
            tagsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagsStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            tagsStackView.heightAnchor.constraint(equalToConstant: 24),
            
            contentTextView.topAnchor.constraint(equalTo: tagsStackView.bottomAnchor, constant: 8),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Data
    private func loadNote() {
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
            selectedColor = note.color
            selectedTags = note.tags
            updateColorButton()
            updateTagsDisplay()
        } else {
            // 新建备忘录时，自动聚焦到标题输入框
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.titleTextField.becomeFirstResponder()
            }
        }
    }
    
    private func saveNote() {
        let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let content = contentTextView.text ?? ""
        
        // 如果标题和内容都为空，不保存
        if title.isEmpty && content.isEmpty {
            return
        }
        
        if var existingNote = note {
            existingNote.update(title: title, content: content, color: selectedColor, tags: selectedTags)
            NoteManager.shared.saveNote(existingNote)
        } else {
            let newNote = Note(title: title, content: content, color: selectedColor, tags: selectedTags)
            NoteManager.shared.saveNote(newNote)
        }
        
        // 通知代理刷新列表
        delegate?.didSaveNote()
    }
    
    // MARK: - Actions
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        saveNote()
        dismiss(animated: true)
    }
    
    @objc private func colorButtonTapped() {
        showColorPicker()
    }
    
    @objc private func tagsButtonTapped() {
        showTagsInput()
    }
    
    // MARK: - Color Picker
    private func showColorPicker() {
        let alert = UIAlertController(title: "选择颜色", message: nil, preferredStyle: .actionSheet)
        
        for color in NoteColor.allCases {
            let action = UIAlertAction(title: color.displayName, style: .default) { _ in
                self.selectedColor = color
                self.updateColorButton()
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func updateColorButton() {
        colorButton.backgroundColor = selectedColor.uiColor
        colorButton.setTitleColor(selectedColor.accentColor, for: .normal)
        colorButton.tintColor = selectedColor.accentColor
    }
    
    // MARK: - Tags Input
    private func showTagsInput() {
        let alert = UIAlertController(title: "添加标签", message: "输入标签，用逗号分隔", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "例如: 工作,重要,待办"
            textField.text = self.selectedTags.joined(separator: ",")
        }
        
        let addAction = UIAlertAction(title: "添加", style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                let tags = text.components(separatedBy: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                self.selectedTags = Array(Set(tags)) // 去重
                self.updateTagsDisplay()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func updateTagsDisplay() {
        // 清除现有标签
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 添加新标签
        for tag in selectedTags {
            let tagView = createTagView(tag)
            tagsStackView.addArrangedSubview(tagView)
        }
    }
    
    private func createTagView(_ tag: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        
        let label = UILabel()
        label.text = "#\(tag)"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        deleteButton.tintColor = .systemRed
        deleteButton.addTarget(self, action: #selector(deleteTag(_:)), for: .touchUpInside)
        
        container.addSubview(label)
        container.addSubview(deleteButton)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            deleteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            deleteButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 16),
            deleteButton.heightAnchor.constraint(equalToConstant: 16),
            
            container.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // 存储标签信息
        container.tag = selectedTags.firstIndex(of: tag) ?? 0
        
        return container
    }
    
    @objc private func deleteTag(_ sender: UIButton) {
        guard let container = sender.superview else { return }
        let index = container.tag
        if index < selectedTags.count {
            selectedTags.remove(at: index)
            updateTagsDisplay()
        }
    }
}

// MARK: - UITextFieldDelegate
extension NoteEditViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.becomeFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension NoteEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 实时保存（可选，这里为了演示）
        // saveNote()
    }
} 
