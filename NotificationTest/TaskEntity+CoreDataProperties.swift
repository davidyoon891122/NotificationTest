//
//  TaskEntity+CoreDataProperties.swift
//  NotificationTest
//
//  Created by jiwon Yoon on 2022/12/21.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var alertDate: Date
    @NSManaged public var isDone: Bool
    @NSManaged public var title: String
    @NSManaged public var uuid: String

}

extension TaskEntity : Identifiable {

}
