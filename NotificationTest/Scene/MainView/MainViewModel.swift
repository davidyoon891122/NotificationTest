//
//  MainViewModel.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import Foundation
import RxSwift

protocol MainViewModelInput {
    func getNotifications()
}

protocol MainViewModelOutput {
    var notificationPublishSubject: PublishSubject<[String]> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}


final class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    var inputs: MainViewModelInput { self }
    
    var outputs: MainViewModelOutput { self }
    
    var notificationPublishSubject: PublishSubject<[String]> = .init()
    
    func getNotifications() {
        NotificationManager.shared.getAllNotifications { [weak self] notifications in
            guard let self = self else { return }
            self.outputs.notificationPublishSubject.onNext(notifications)
        }
    }
    
}
