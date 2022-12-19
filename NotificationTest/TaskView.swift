//
//  TaskView.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import UIKit
import SnapKit

final class TaskView: UIView {
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Task: "
        label.backgroundColor = .secondarySystemBackground
        
        return label
    }()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.placeholder = "Please write the task name"
        
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getValueFromTextField() -> String? {
        guard let text = taskTextField.text else { return nil }
        return text
    }
}


private extension TaskView {
    func setupViews() {
        [
            taskLabel,
            taskTextField
        ]
            .forEach {
                addSubview($0)
            }
        
        taskLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let offset: CGFloat = 16.0
        taskLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        taskTextField.snp.makeConstraints {
            $0.centerY.equalTo(taskLabel)
            $0.leading.equalTo(taskLabel.snp.trailing).offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
        }
    }
}
