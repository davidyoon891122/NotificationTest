//
//  MainViewModel.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import Foundation
import RxSwift
import UIKit
import CoreData


protocol MainViewModelInput {
    func getNotifications()
    func loadSavedTask()
    func saveTask(task: TaskModel)
    func requestUpdateIsDone(task: TaskEntity)
    func requestRemoveTask(task: TaskEntity)
}

protocol MainViewModelOutput {
    var notificationPublishSubject: PublishSubject<[String]> { get }
    var tasksPublishSubject: PublishSubject<[TaskEntity]> { get }
    var loadErrorPublushSubject: PublishSubject<String> { get }
    var saveErrorPublishSubject: PublishSubject<String> { get }
}

protocol MainViewModelType {
    var inputs: MainViewModelInput { get }
    var outputs: MainViewModelOutput { get }
}


final class MainViewModel: MainViewModelType, MainViewModelInput, MainViewModelOutput {
    var inputs: MainViewModelInput { self }
    
    var outputs: MainViewModelOutput { self }
    
    var notificationPublishSubject: PublishSubject<[String]> = .init()
    var tasksPublishSubject: PublishSubject<[TaskEntity]> = .init()
    var loadErrorPublushSubject: PublishSubject<String> = .init()
    var saveErrorPublishSubject: PublishSubject<String> = .init()
    
    var tasks: [TaskEntity] = []
    
    func getNotifications() {
        NotificationManager.shared.getAllNotifications { [weak self] notifications in
            guard let self = self else { return }
            self.outputs.notificationPublishSubject.onNext(notifications)
        }
    }
    
    func loadSavedTask() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            tasks = try context.fetch(TaskEntity.fetchRequest())
            outputs.tasksPublishSubject.onNext(tasks)
        } catch let error {
            print(error.localizedDescription)
            outputs.loadErrorPublushSubject.onNext("일정 데이터 로드에 실패했어요 ☹️")
        }
    }
    
    func saveTask(task: TaskModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TaskEntity", in: context)
        
        if let entity = entity {
            let taskEntity = NSManagedObject(entity: entity, insertInto: context)
            taskEntity.setValue(task.uuid, forKey: "uuid")
            taskEntity.setValue(task.title, forKey: "title")
            taskEntity.setValue(task.alertDate, forKey: "alertDate")
            taskEntity.setValue(task.isDone, forKey: "isDone")
            
            do {
                try context.save()
                self.loadSavedTask()
                NotificationManager.shared.requestSendNoti(task: task, completion: { [weak self] error in
                    guard let self = self else { return }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    self.inputs.getNotifications()
                })
            } catch let error {
                print(error.localizedDescription)
                outputs.saveErrorPublishSubject.onNext("Task 저장에 실패했어요 ☹️")
            }
            
        }
    }
    
    func requestUpdateIsDone(task: TaskEntity) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", task.uuid)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            guard let objectUpdate = fetchedData[0] as? NSManagedObject else { return }
            objectUpdate.setValue(!task.isDone, forKey: "isDone")
            
            do {
                try context.save()
                loadSavedTask()
                
                if !task.isDone {
                    // request regi
                    let task = TaskModel(uuid: task.uuid, title: task.title, alertDate: task.alertDate, isDone: !task.isDone)
                    NotificationManager.shared.requestSendNoti(task: task, completion: { [weak self] error in
                        guard let self = self else { return }
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        self.inputs.getNotifications()
                    })
                } else {
                    // remove regi
                    NotificationManager.shared.removePendingNotificationByUUID(uuid: task.uuid, completion: { [weak self] in
                        guard let self = self else { return }
                        self.inputs.getNotifications()
                    })
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func requestRemoveTask(task: TaskEntity) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "TaskEntity")
        let removeUUID = task.uuid
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", task.uuid)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            guard let objectDelete = fetchedData[0] as? NSManagedObject else { return }
            context.delete(objectDelete)
            
            do {
                try context.save()
                loadSavedTask()
                NotificationManager.shared.removePendingNotificationByUUID(uuid: removeUUID, completion: { [weak self] in
                    guard let self = self else { return }
                    self.inputs.getNotifications()
                })
            } catch {
                print(error.localizedDescription)
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
