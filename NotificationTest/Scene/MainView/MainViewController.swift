//
//  MainViewController.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import UIKit
import SnapKit
import RxSwift

final class MainViewController: UIViewController {
    private let taskView = TaskView()
    
    private lazy var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            TaskCollectionViewCell.self,
            forCellWithReuseIdentifier: TaskCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    private var disposeBag = DisposeBag()
    
    private var tasks: [TaskModel] = [
        TaskModel(title: "Sample", pubDate: Date(), isDone: true),
        TaskModel(title: "Example", pubDate: Date(), isDone: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setupViews()
        bindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return tasks.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskCollectionViewCell.identifier,
            for: indexPath
        ) as? TaskCollectionViewCell else { return UICollectionViewCell() }
        
        let task = tasks[indexPath.item]

        cell.setupCell(task: task)
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: collectionView.frame.width,
            height: 50.0
        )
    }
}



private extension MainViewController {
    func setupViews() {
        [
            taskView,
            taskCollectionView
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
        
        taskCollectionView.snp.makeConstraints {
            $0.top.equalTo(taskView.snp.bottom).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
            $0.bottom.equalToSuperview().offset(-offset)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "Main"
    }
    
    
    func bindUI() {
        taskView.addButtonTap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                guard let task = self.taskView.getValueFromTextField() else { return }
                
                print("Add the task: \(task)")
            })
            .disposed(by: disposeBag)
        
    }
}