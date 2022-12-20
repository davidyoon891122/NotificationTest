//
//  TaskView.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import UIKit
import SnapKit
import RxCocoa

final class TaskView: UIView {
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.text = "Task: "
        
        return label
    }()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.placeholder = "Please write the task name"
        
        return textField
    }()
    
    private lazy var addButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = "Add"
        buttonConfiguration.titlePadding = 3.0
        
        let button = UIButton(configuration: buttonConfiguration)
        
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        return datePicker
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
    
    var addButtonTap: ControlEvent<Void> {
        addButton.rx.tap
    }
}


private extension TaskView {
    func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8.0
        [
            taskLabel,
            taskTextField,
            addButton,
            datePicker
        ]
            .forEach {
                addSubview($0)
            }
        
        taskLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let offset: CGFloat = 16.0
        taskLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(offset)
            $0.centerY.equalTo(taskTextField)
        }
        
        taskTextField.snp.makeConstraints {
            $0.centerY.equalTo(addButton)
            $0.leading.equalTo(taskLabel.snp.trailing).offset(offset)
            $0.trailing.equalTo(addButton.snp.leading).offset(-offset)
        }
        
        addButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(50.0)
            $0.width.equalTo(65.0)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(taskTextField.snp.bottom).offset(offset)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-offset)
        }
    }
}
