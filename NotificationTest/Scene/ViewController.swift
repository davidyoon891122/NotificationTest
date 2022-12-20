//
//  ViewController.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private lazy var notiCountDisplayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var prevDay: UIButton = {
        let button = UIButton()
        button.setTitle("prevDay", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }()
    
    private lazy var nextDay: UIButton = {
        let button = UIButton()
        button.setTitle("prevDay", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }()
    
    private lazy var upMinuteButton: UIButton = {
        let button = UIButton()
        button.setTitle("upMin", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }()
    
    private lazy var downMinuteButton: UIButton = {
        let button = UIButton()
        button.setTitle("DownMin", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.label.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


}

private extension ViewController {
    func setupViews() {
        [
            notiCountDisplayLabel
        ]
            .forEach {
                view.addSubview($0)
            }
    }
}

