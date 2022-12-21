//
//  ModifyViewController.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/21.
//

import UIKit
import RxCocoa
import RxSwift

final class ModifyViewController: UIViewController {
    private lazy var presentTopView = PresentTopView()
    
    private lazy var taskInfoView = TaskInfoView()
    
    private var disposeBag = DisposeBag()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .automatic
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindUI()
    }
    
    init(task: TaskEntity) {
        super.init(nibName: nil, bundle: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\nHH:mm:ss"
        taskInfoView.setTitleText(title: task.title)
        taskInfoView.setDateText(date: dateFormatter.string(from: task.alertDate))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ModifyViewController {
    func setupViews() {
        view.backgroundColor = .systemBackground
        [
            presentTopView,
            taskInfoView,
            datePicker
        ]
            .forEach {
                view.addSubview($0)
            }
        
        let offset: CGFloat = 16.0
        presentTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        taskInfoView.snp.makeConstraints {
            $0.top.equalTo(presentTopView.snp.bottom).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(taskInfoView.snp.bottom).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
        }
    }
    
    func bindUI() {
        presentTopView.closeButtonTap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        presentTopView.modifyButtonTap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let date = self.datePicker.date
                print(date)
                
            })
            .disposed(by: disposeBag)
    }
}



