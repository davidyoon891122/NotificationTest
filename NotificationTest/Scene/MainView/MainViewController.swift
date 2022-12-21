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
        
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let displayView = NotificationDisplayView()
    
    private let viewModel: MainViewModelType = MainViewModel()
    
    private var disposeBag = DisposeBag()
    
    private var tasks: [TaskModel] = [] {
        didSet {
            self.taskCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        setupViews()
        bindUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationManager.shared.requestAuthNoti()
        viewModel.inputs.getNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MainViewController: TaskCollectionViewCellDelegate {
    func didTapDoneButton(index: Int) {
        var task = tasks[index]
        task.isDone = !task.isDone
        tasks[index] = task

        if task.isDone {
            NotificationManager.shared.removePendingNotificationByUUID(uuid: task.uuid) { [weak self] in
                guard let self = self else { return }
                self.viewModel.inputs.getNotifications()
            }
        } else {
            NotificationManager.shared.requestSendNoti(task: task) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                }
                self.viewModel.inputs.getNotifications()
            }
        }
    }
    
    func didTapRemoveButton(index: Int) {
        let removedTask = tasks[index]
        NotificationManager.shared.removePendingNotificationByUUID(uuid: removedTask.uuid) { [weak self] in
            guard let self = self else { return }
            self.viewModel.inputs.getNotifications()
        }
        self.tasks.remove(at: index)
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
        cell.delegate = self

        cell.setupCell(task: task, index: indexPath.item)
        
        
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
            displayView,
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
        
        displayView.snp.makeConstraints {
            $0.top.equalTo(taskView.snp.bottom).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
            $0.height.equalTo(30.0)
        }
        
        taskCollectionView.snp.makeConstraints {
            $0.top.equalTo(displayView.snp.bottom).offset(offset)
            $0.leading.equalToSuperview().offset(offset)
            $0.trailing.equalToSuperview().offset(-offset)
            $0.bottom.equalToSuperview().offset(-offset)
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "Main"
        
        let removeButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(didTapTrashButton)
        )
        
        let printNotiButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapRefreshButton)
        )
        
        navigationItem.rightBarButtonItem = removeButton
        navigationItem.leftBarButtonItem = printNotiButton
    }
    
    
    func bindUI() {
        taskView.addButtonTap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                guard let taskTitle = self.taskView.getValueFromTextField() else { return }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                print(dateFormatter.string(from: self.taskView.getDateFromPicker()))
                let task = TaskModel(
                    uuid: UUID().uuidString,
                    title: taskTitle,
                    pubDate: self.taskView.getDateFromPicker(),
                    isDone: false
                )
                self.tasks.append(task)
                NotificationManager.shared.requestSendNoti(task: task) { _ in
                    self.viewModel.inputs.getNotifications()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func bindViewModel() {
        viewModel.outputs.notificationPublishSubject
            .subscribe(onNext: { [weak self] notifications in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.displayView.setNotiCountToLabel(count: notifications.count)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func didTapTrashButton() {
        print("removeAllNotification")
        NotificationManager.shared.removeAllNotification()
        viewModel.inputs.getNotifications()
    }
    
    @objc
    func didTapRefreshButton() {
        print("Display Noti")
        NotificationManager.shared.getAllNotifications(completion: { notifications in
            print(notifications)
        })
        viewModel.inputs.getNotifications()
    }
}
