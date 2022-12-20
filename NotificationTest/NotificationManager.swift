//
//  NotificationManager.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/20.
//

import Foundation
import NotificationCenter

final class NotificationManager {
    static let shared = NotificationManager()
    let userNotiCenter = UNUserNotificationCenter.current()
    
    func requestAuthNoti() {
        let notificationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        userNotiCenter.requestAuthorization(options: notificationOptions, completionHandler: { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func requestSendNoti(task: TaskModel) {
        let notiContent = UNMutableNotificationContent()
        notiContent.title = task.title
        notiContent.body = task.title
        notiContent.userInfo = ["targetScene": "MainViewController"]
        
        let dateCompoenets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: task.pubDate)
        
        if task.pubDate > Date() {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompoenets, repeats: false)
            let request = UNNotificationRequest(identifier: task.uuid, content: notiContent, trigger: trigger)
            
            userNotiCenter.add(request) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func removePendingNotificationByUUID(uuid: String) {
        userNotiCenter.getPendingNotificationRequests(completionHandler: { [weak self] requests in
            guard let self = self else { return }
            for notification in requests where notification.identifier == uuid {
                self.userNotiCenter.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
            }
            
        })
    }
    
    func getAllNotifications(completion: @escaping ([String]) -> Void) {
        userNotiCenter.getPendingNotificationRequests(completionHandler: { requests in
            let notificationIdentifiers = requests.map { $0.identifier }
            completion(notificationIdentifiers)
        })
    }
    
    func removeAllNotification() {
        userNotiCenter.removeAllPendingNotificationRequests()
    }
}