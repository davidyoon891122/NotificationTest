//
//  TaskCollectionViewCell.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol TaskCollectionViewCellDelegate: AnyObject {
    func didTapDoneButton(index: Int)
}

final class TaskCollectionViewCell: UICollectionViewCell {
    static let identifier = "TaskCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = ""
        
        return label
    }()
    
    private lazy var pubDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = ""
        label.font = .systemFont(ofSize: 12.0)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var doneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private lazy var doneButton: UIButton = {
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.title = "Complete"
        buttonConfiguration.titlePadding = 3.0
        
        let button = UIButton(configuration: buttonConfiguration)
        
        return button
    }()
    
    private var disposeBag = DisposeBag()
    
    weak var delegate: TaskCollectionViewCellDelegate?
    
    var index: Int?
    
    func setupCell(task: TaskModel, index: Int) {
        titleLabel.text = task.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\nHH:mm:ss "
        pubDateLabel.text = dateFormatter.string(from: task.pubDate)
        
        if task.isDone {
            doneImageView.image = UIImage(systemName: "checkmark")
        } else {
            doneImageView.image = UIImage(systemName: "xmark")
        }
        
        self.index = index
        setupViews()
        bindUI()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}

private extension TaskCollectionViewCell {
    func setupViews() {
        [
            doneImageView,
            titleLabel,
            pubDateLabel,
            doneButton
        ]
            .forEach {
                contentView.addSubview($0)
            }
        
        let offset: CGFloat = 16.0
        doneImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(20.0)
            $0.centerY.equalTo(titleLabel)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(pubDateLabel)
            $0.leading.equalTo(doneImageView.snp.trailing).offset(offset)
        }
        
        pubDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(doneButton)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(offset)
        }
        titleLabel.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(pubDateLabel.snp.trailing).offset(offset)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    
    func bindUI() {
        doneButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self,
                      let index = self.index
                else { return }
                self.delegate?.didTapDoneButton(index: index)
            })
            .disposed(by: disposeBag)
    }
}
