//
//  TaskInfoView.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/21.
//

import Foundation
import UIKit

final class TaskInfoView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Samsung"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "2022.11.22 23:58:00"
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.numberOfLines = 2
        
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleText(title: String) {
        titleLabel.text = title
    }
    
    func setDateText(date: String) {
        dateLabel.text = date
    }
}

private extension TaskInfoView {
    func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8.0
        
        [
            titleLabel,
            dateLabel
        ]
            .forEach {
                addSubview($0)
            }
        
        let offset: CGFloat = 16.0
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-offset)
        }
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TaskInfoViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let taskInfoView = TaskInfoView()
            return taskInfoView
        }.previewLayout(.sizeThatFits)
            .frame(minWidth: 100, idealWidth: 200, maxWidth: UIScreen.main.bounds.width - 32, minHeight: 100, idealHeight: 100, maxHeight: 100, alignment: .center)
    }
}

#endif
