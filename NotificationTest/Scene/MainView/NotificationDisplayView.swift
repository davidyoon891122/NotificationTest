//
//  NotificationDisplayView.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import UIKit
import SnapKit

final class NotificationDisplayView: UIView {
    private lazy var notificationCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPurple
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        return label
    }()
    
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNotiCountToLabel(count: Int) {
        notificationCountLabel.text = "Notification Count: \(count)"
    }
}

private extension NotificationDisplayView {
    func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        [
            notificationCountLabel
        ]
            .forEach {
                addSubview($0)
            }
        
        notificationCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
