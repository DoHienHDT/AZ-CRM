//
//  AppDelegate.swift
//  AZ CRM
//
//  Created by vmio vmio on 10/14/19.
//  Copyright © 2019 AZCRM. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox
import AVFoundation
import Firebase
import Messages
import UserNotifications
import Alamofire
import Siren

let googleApiKey = "AIzaSyA-nJMTmdqy6pUduyXe1sK-bktDRoxVGkc"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let gcmMessageIDKey = "gcm.message_id"
    var window: UIWindow?
    var audioPlayer: AVAudioPlayer?
    let alarmScheduler: AlarmSchedulerDelegate = Scheduler()
    var alarms: [AlarmItem] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        sleep(2)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        
        hyperCriticalRulesExample()
        removeUserDefaults()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        AppDelegate.saveContext()
    }
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AZ_CRM")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    // MARK: - Core Data Saving support

    static func saveContext () {
     
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
   
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
//        let notif = JSON(userInfo)
//
//        if notif["callback"]["type"] != nil {
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "myNotif"), object: nil)
//            // This is where you read your JSON to know what kind of notification you received, for example :
//
//        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
//         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
     
        // With swizzling disabled you must let Messaging know about the message, for Analytics
         Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo.keys)
        
        let state: UIApplication.State = UIApplication.shared.applicationState
        
        if state == .active {
            
                if let alertDICT = userInfo["UUID"] as? String {
                    
                    let dateAlarm = userInfo["date"] as? Date
                    let titleAlarm = userInfo["title"] as? String
                    let dateformat = DateFormatter()
                    dateformat.dateFormat = "HH:mm"
                    let dateConvertString = dateformat.string(from: dateAlarm!)
                    
                    playSound()
                    let storageController = UIAlertController(title: "Lịch hẹn \(titleAlarm ?? "") chuẩn bị diễn ra vào lúc \(dateConvertString)", message: nil, preferredStyle: .alert)
                    let stopOption = UIAlertAction(title: "OK", style: .default) {
                        (action:UIAlertAction)->Void in self.audioPlayer?.stop()
                        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
                        self.alarms = AlarmList.sharedInstance.allItems()
                        for i in 0..<self.alarms.count {
                            if(self.alarms[i].UUID == alertDICT) {
                                self.alarms[i].enabled = false
                                AlarmList.sharedInstance.changeItem(self.alarms[i])
                                self.alarmScheduler.removeNotification(self.alarms[i])
                            }
                        }
                    }
                    
                    storageController.addAction(stopOption)
                    
                    DispatchQueue.main.async {
                        self.window?.rootViewController?.present(storageController, animated: true, completion: nil)
                    }
                }
            
            // create a sound ID, in this case its the SMSReceived sound.
            if let aps = userInfo["aps"] as? NSDictionary {
                
                if let alertDICT = aps["alert"] as? [String: Any] {
                    let body = alertDICT["body"] as? String
                    let title = alertDICT["title"] as? String
                    Alarm.alarm.stopAlarm()
                    playSound()
                    let alert = UIAlertController(title: "\(title ?? "")", message: "\(body ?? "")", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel) { (_) in
                        Alarm.alarm.checkAlarm()
                        self.audioPlayer?.stop()
                        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
                    }
                    alert.addAction(action)
                    DispatchQueue.main.async {
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        print("Firebase registration token: \(fcmToken)")
        
          let entity = FCToken(context: AppDelegate.context)
              entity.fcmToken = fcmToken
          AppDelegate.saveContext()
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        print("Received data message: \(remoteMessage.appData)")
    }
    
}

extension AppDelegate {
    
    func hyperCriticalRulesExample() {
        let siren = Siren.shared
        siren.rulesManager = RulesManager(globalRules: .critical,
                                          showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)
        
        siren.wail { (results, error) in
            if let results = results {
                print("AlertAction ", results.alertAction)
                print("Localization ", results.localization)
                print("LookupModel ", results.lookupModel)
                print("UpdateType ", results.updateType)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func playSound() {
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil, nil,
                                              {
                                                (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }, nil)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "alarm", ofType: "mp3")!)
        
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }

}
