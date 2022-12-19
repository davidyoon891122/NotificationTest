//
//  MainViewController.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import Foundation
import UIKit

final class MainViewController: UIViewController {
    private let taskView = TaskView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

private extension MainViewController {
    func setupViews() {
        [
            taskView
        ]
            .forEach {
                view.addSubview($0)
            }
        
        let offset: CGFloat = 16.0
        taskView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "Main"
    }
}
