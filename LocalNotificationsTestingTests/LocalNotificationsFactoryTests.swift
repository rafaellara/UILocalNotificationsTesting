//
//  Copyright © 2016 Rafael Lara. All rights reserved.
//

import XCTest
@testable import LocalNotificationsTesting

class LocalNotificationsFactoryTests: XCTestCase {
    
    func testLocalNotificationFactory_NotificationWithDate_DateIsExpected() {
        let expectedDate = NSDate(timeIntervalSinceNow: 5000.0)
        let factory = LocalNotificationsFactory()
        let notification = factory.timeOverNotification(atDate: expectedDate)
        
        XCTAssertEqual(notification.fireDate, expectedDate)
    }
}
