//
//  Copyright © 2016 Rafael Lara. All rights reserved.
//

import UIKit

class LocalNotificationsFactory: NSObject {

    func timeOverNotification(atDate date: NSDate) -> UILocalNotification {
        
        let notification = UILocalNotification()
        notification.fireDate = date
        notification.alertBody = "Time is over!"
        notification.alertAction = "go to next leg"
        notification.soundName = UILocalNotificationDefaultSoundName
        return notification
    }
}
