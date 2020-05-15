//
//  AppDelegate.swift
//  Group Message
//
//  Created by Liu Jie on 3/26/20.
//  Copyright © 2020 smarteye. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Remote notifications
        registerForRemoteNotifications(application)
        handleRemoteNotificationAppLaunch(launchOptions)
                
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
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print(userInfo)
        guard let groupId = userInfo["group"] as? String else {return}
        saveMessage(userInfo: userInfo, groupid: groupId)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print(userInfo)
        guard let groupId = userInfo["group"] as? String else {return}
        saveMessage(userInfo: userInfo, groupid: groupId)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
}


// MARK: - AppDelegate helper methods
extension AppDelegate {
    func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    // [START handle_remote_notification_app_launch]
    func handleRemoteNotificationAppLaunch(_ launchOptions: [AnyHashable: Any]?) {
        guard let launchOptions = launchOptions else { return }
        guard let notificationInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] else { return }

        print(notificationInfo)
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.0) {
            DispatchQueue.main.async {
                guard let groupId = notificationInfo["group"] as? String else {return}
                self.saveMessage(userInfo: notificationInfo, groupid: groupId)
            }
        }
    }
    // [END handle_remote_notification_app_launch]
    
    
    func saveMessage(userInfo: [AnyHashable : Any], groupid: String) {
        
        if let messageID = userInfo["gcm.message_id"] as? String {
            print("Message ID: \(messageID)")
            
            var aryMessage = Utility.getDictionaryFromUserDefaults(key: USER_MESSAGE)
            var bFalg : Bool = false
            for message  in aryMessage {
                let messageid = message["id"] as? String
                if messageID == messageid! {
                    bFalg = true
                }
            }
            
            if !bFalg {
                guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
                guard let alert = aps["alert"] as? Dictionary<String, Any> else { return }
                guard let body = alert["body"] as? String else { return }
                guard let title = alert["title"] as? String else { return }
                
                let groupName = getGroupName(groupId: groupid)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let myString = formatter.string(from: Date())
                print(myString)
                
                let dicMessage = ["id":  messageID, "title": title, "body": body,"created": myString, "group": groupName] as [String : Any]
                aryMessage.insert(dicMessage, at: 0)
                Utility.saveDictionaryToUserDefaults(value: aryMessage, key: USER_MESSAGE)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Add Message"), object: nil)
            }
        }
    }
    
    func getGroupName(groupId: String) -> String {
        let groupData = Utility.getDictionaryFromUserDefaults(key: GROUP_DATA)
        for group in groupData {
            let groupid = group["id"] as! String
            let groupname = group["name"] as! String
            if groupId == groupid {
                return groupname
            }
        }
        return ""
    }
    
}

// MARK: - UNUserNotificationDelegate

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        guard let groupId = userInfo["group"] as? String else {return}
        saveMessage(userInfo: userInfo, groupid: groupId)
//        NotificationManager.shared.handleRemoteNotification(userInfo)
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        guard let groupId = userInfo["group"] as? String else { return }
        saveMessage(userInfo: userInfo, groupid: groupId)
//        NotificationManager.shared.handleRemoteNotification(userInfo)
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken=" + fcmToken)
        Utility.saveStringToUserDefaults(value: fcmToken, key: DEVICE_TOKEN)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message")
    }
}



