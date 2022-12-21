//
//  SeparatorView.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/21.
//

import UIKit
import SnapKit
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif


enum SeparatorDirection {
    case horizontal
    case vertical
}

final class SeparatorView: UIView {
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        
        return view
    }()
    
    private var size: CGFloat
    private var direction: SeparatorDirection
    private var color: UIColor
    
    init(
        size: CGFloat = 1.0,
        direction: SeparatorDirection = .horizontal,
        color: UIColor = .gray
    ) {
        self.size = size
        self.direction = direction
        self.color = color
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SeparatorView {
    func setupViews() {
        [
            separatorView
        ]
            .forEach {
                addSubview($0)
            }
        
        switch direction {
        case .vertical:
            separatorView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.width.equalTo(size)
            }
        
        case .horizontal:
            separatorView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(size)
            }
        }
        
        separatorView.backgroundColor = color
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct SeparatorViewPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let separatorView = SeparatorView()
            return separatorView
        }.previewLayout(.sizeThatFits)
    }
}

#endif
