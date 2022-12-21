//
//  PresentTopView.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/21.
//

import UIKit
import SnapKit
import RxCocoa

final class PresentTopView: UIView {
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.red.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }()
    
    private lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Modify", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.setTitleColor(.green.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }()
    
    private lazy var separatorView = SeparatorView()
    
    var closeButtonTap: ControlEvent<Void> {
        closeButton.rx.tap
    }
    
    var modifyButtonTap: ControlEvent<Void> {
        modifyButton.rx.tap
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
private extension PresentTopView {
    func setupViews() {
        [
            closeButton,
            modifyButton,
            separatorView
        ]
            .forEach {
                addSubview($0)
            }
        let offset: CGFloat = 16.0
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(offset)
        }
        
        modifyButton.snp.makeConstraints {
            $0.top.equalTo(closeButton)
            $0.trailing.equalToSuperview().offset(-offset)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(offset)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PresentTopViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let presentTopView = PresentTopView()
            return presentTopView
        }.previewLayout(.sizeThatFits)
    }
}

#endif
