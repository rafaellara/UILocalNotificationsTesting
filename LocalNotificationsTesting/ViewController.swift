//
//  Copyright © 2016 Rafael Lara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var scheduleButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var clearAllRegisteredButton: UIButton!
    
    @IBOutlet var logLabel: UILabel!
    
    var localNotificationScheduler : LocalNotificationScheduler?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearNotifications(sender: AnyObject) {
        
        localNotificationScheduler?.removeAllLocalNotifications()
        logLabel.text = "All Notifications have been removed"
    }
    
    @IBAction func scheduleNotification(sender: AnyObject) {
        
        let scheduleDate = NSDate(timeIntervalSinceNow: 60.0)
        
        do {
            try localNotificationScheduler?.scheduleNotification(atDate: scheduleDate)
        } catch  {
            logLabel.text = "Error scheduling Notification"
            return
        }
        
        logLabel.text = "Notification scheduled at \(scheduleDate.description)"
    }
    
    @IBAction func registerForNotifications(sender: AnyObject) {
        
        if localNotificationScheduler!.userOptedInForLocalNotifications() {
            logLabel.text = "User has already registered for notifications"
        } else {
            logLabel.text = "User has been prompted for permission"
            let notificationsSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            localNotificationScheduler?.configureWithNotificationSettings(notificationsSettings)
        }
    }
}

