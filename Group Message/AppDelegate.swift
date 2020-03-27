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
        
        if #available(iOS 10.0, *) {
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
        
        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true
        
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
          }
        }
        
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
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print(deviceToken)
//        Messaging.messaging().apnsToken = deviceToken
//        let deviceTokenString = deviceToken.hexString
//        Utility.saveStringToUserDefaults(value: deviceTokenString, key: DEVICE_TOKEN)
//    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      if let messageID = userInfo["gcm.message_id"] {
        print("Message ID: \(messageID)")
      }

      print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        print(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response)
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        if let messageID = userInfo["gcm.message_id"]{
          print("Message ID: \(messageID)")
        }

        guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
        guard let alert = aps["alert"] as? Dictionary<String, Any> else { return }
        guard let body = alert["body"] as? String else { return }
        guard let title = alert["title"] as? String else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let myString = formatter.string(from: Date())
        print(myString)
        
        let groupId = "-M2Sk65bv7PFzlr-YZRK"
        let groupName = getGroupName(groupId: groupId)
        
        var aryMessage = Utility.getDictionaryFromUserDefaults(key: USER_MESSAGE)
        let dicMessage = ["title": title, "body": body,"created": myString, "group": groupName]
        aryMessage.append(dicMessage)
        Utility.saveDictionaryToUserDefaults(value: aryMessage, key: USER_MESSAGE)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Add Message"), object: nil)
        
        completionHandler()
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

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("fcmToken=" + fcmToken)
        Utility.saveStringToUserDefaults(value: fcmToken, key: DEVICE_TOKEN)
    }
}



