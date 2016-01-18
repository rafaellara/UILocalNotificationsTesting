//
//  Copyright © 2016 Rafael Lara. All rights reserved.
//

import UIKit

enum LocalNotificationSchedulerError : ErrorType {
    case ScheduleDateInThePast
    case UserHasNotOptedIn
}

protocol LocalNotificationSchedulable : class {

    func scheduleLocalNotification(notification: UILocalNotification)
    func registerUserNotificationSettings(_notificationSettings: UIUserNotificationSettings)
    func currentUserNotificationSettings() -> UIUserNotificationSettings?
    func cancelAllLocalNotifications()
}

class LocalNotificationScheduler: NSObject {

    let application : LocalNotificationSchedulable
    let notificationsFactory : LocalNotificationsFactory
    
    init(application: LocalNotificationSchedulable, notificationsFactory : LocalNotificationsFactory) {
        self.application = application
        self.notificationsFactory = notificationsFactory
    }
    
    func userOptedInForLocalNotifications() -> Bool {
        
        if let settings = application.currentUserNotificationSettings() {
            return settings.types != .None
        }
        return false
    }
    
    func configureWithNotificationSettings(notificationSettings : UIUserNotificationSettings) {
        
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func scheduleNotification(atDate date: NSDate) throws {
        
        guard userOptedInForLocalNotifications() else {
            throw LocalNotificationSchedulerError.UserHasNotOptedIn
        }
        
        let compareResult = NSDate().compare(date)
        guard compareResult == NSComparisonResult.OrderedAscending else {
            
            throw LocalNotificationSchedulerError.ScheduleDateInThePast
        }

        let notification = notificationsFactory.timeOverNotification(atDate:date)
        application.scheduleLocalNotification(notification)
    }
    
    func removeAllLocalNotifications() {
        
        application.cancelAllLocalNotifications()
    }
}

