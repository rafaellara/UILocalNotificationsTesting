//
//  Copyright © 2016 Rafael Lara. All rights reserved.
//

import XCTest
@testable import LocalNotificationsTesting

class LocalNotificatioSchedulerTestable : LocalNotificationSchedulable {
    
    var registeredUserNotificationSettings : UIUserNotificationSettings?
    var notificationScheduled : UILocalNotification?
    var notificationsCancelled = false
    
    func currentUserNotificationSettings() -> UIUserNotificationSettings? {

        return registeredUserNotificationSettings
    }
    
    func registerUserNotificationSettings(notificationSettings: UIUserNotificationSettings) {
        registeredUserNotificationSettings = notificationSettings
    }
    
    func scheduleLocalNotification(notification: UILocalNotification) {
        notificationScheduled = notification
    }
    
    func cancelAllLocalNotifications() {
        notificationsCancelled = true
    }
}

class LocalNotificationSchedulerTests: XCTestCase {
    
    func testScheduler_UserHasNotOptedInForNotifications_False() {
        let notificationFactory = LocalNotificationsFactory()
        let application = LocalNotificatioSchedulerTestable()
        let scheduler = LocalNotificationScheduler(application: application, notificationsFactory: notificationFactory)
        XCTAssertFalse(scheduler.userOptedInForLocalNotifications())
    }
    
    func testScheduler_UserHasOptedInForNotifications_True() {
        
        let notificationFactory = LocalNotificationsFactory()
        let application = LocalNotificatioSchedulerTestable()
        application.registeredUserNotificationSettings = UIUserNotificationSettings(forTypes: [.Alert], categories: nil)
        
        let scheduler = LocalNotificationScheduler(application: application, notificationsFactory: notificationFactory)
        XCTAssertTrue(scheduler.userOptedInForLocalNotifications())
    }
    
    func testScheduler_UserRegistersForLocalNotificatios_DelegateCallbackExecuted() {
        
        let application = LocalNotificatioSchedulerTestable()
        let userSettings = UIUserNotificationSettings(forTypes: [.Alert], categories: nil)
        application.registerUserNotificationSettings(userSettings)
        
        XCTAssertEqual(application.registeredUserNotificationSettings?.types, UIUserNotificationType.Alert)
    }
    
    func testScheduleNotification_UserHasOptedOutForNotifications_Throws() {
        
        let application = LocalNotificatioSchedulerTestable()
        
        let notificationFactory = LocalNotificationsFactory()
        let validDate = NSDate().dateByAddingTimeInterval(5000.0)
        let scheduler = LocalNotificationScheduler(application: application, notificationsFactory: notificationFactory)
        
        do {
            try scheduler.scheduleNotification(atDate: validDate)
        } catch let e as LocalNotificationSchedulerError  {
            XCTAssertEqual(e, LocalNotificationSchedulerError.UserHasNotOptedIn)
        } catch {
             XCTFail("Wrong error")
        }
    }
    
    func testScheduleNotification_ScheduleDateIsInThePast_Throws() {
        
        let application = LocalNotificatioSchedulerTestable()
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
        
        let notificationFactory = LocalNotificationsFactory()
        let validDate = NSDate().dateByAddingTimeInterval(-5000.0)
        
        let scheduler = LocalNotificationScheduler(application: application, notificationsFactory: notificationFactory)
        
        do {
            try scheduler.scheduleNotification(atDate: validDate)
        } catch let e as LocalNotificationSchedulerError  {
            XCTAssertEqual(e, LocalNotificationSchedulerError.ScheduleDateInThePast)
        } catch {
            XCTFail("Wrong error")
        }
    }
    
    func testScheduleNotification_UserOptedInAndDateIsCorrect_NotificationScheduled() {
        
        let application = LocalNotificatioSchedulerTestable()
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil))
        
        let notificationFactory = LocalNotificationsFactory()
        let expectedDate = NSDate().dateByAddingTimeInterval(5000.0)
        
        let scheduler = LocalNotificationScheduler(application: application, notificationsFactory: notificationFactory)
        
        do {
            try scheduler.scheduleNotification(atDate: expectedDate)
        } catch {
            XCTFail("Should not fail")
        }
        
        XCTAssertEqual(expectedDate, application.notificationScheduled?.fireDate)
    }
    
    func testCancelNotifications_UserCancelNotifications_ActionPerformed() {
        
        let application = LocalNotificatioSchedulerTestable()
        let notificationFactory = LocalNotificationsFactory()
        let scheduler = LocalNotificationScheduler(application: application, notificationsFactory: notificationFactory)
        scheduler.removeAllLocalNotifications()
        
        XCTAssertTrue(application.notificationsCancelled)
    }
}
