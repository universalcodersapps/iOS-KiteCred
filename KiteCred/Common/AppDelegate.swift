//
//  AppDelegate.swift
//  KiteCred
//
//  Created by Dileep Jaiswal on 20/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()
        return true
    }
    
    //https://www.raywenderlich.com/11395893-push-notifications-tutorial-getting-started
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /*
        <scheme>://<host>
         starbucks://home
         starbucks://scan
         */
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let host = components.host else {
            print("Invalid URl")
            return false
        }
        
        guard let deepLink = DeepLink(rawValue: host) else {
            print("Deep Link not found\(host)")
            return false
        }
        
        return true
        
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // 1
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                return false
        }
        
        // 2
        if let computer = ItemHandler.sharedInstance.items.filter({ $0.path == components.path}).first {
            presentDetailViewController(computer)
            return true
        }
        
        // 3
        if let webpageUrl = URL(string: "http://rw-universal-links-final.herokuapp.com") {
            application.open(webpageUrl)
            return false
        }
        
        return false
    }
    
    func presentDetailViewController(_ newsLink: NewsLink) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard
            let detailVC = storyboard
                .instantiateViewController(withIdentifier: "NewsViewController")
                as? NewsViewController,
            let navigationVC = storyboard
                .instantiateViewController(withIdentifier: "NavigationController")
                as? UINavigationController
            else { return }
        
        detailVC.item = newsLink
        navigationVC.modalPresentationStyle = .formSheet
        navigationVC.pushViewController(detailVC, animated: true)
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let statusBar =  UIView()
            
            statusBar.frame = UIApplication.shared.statusBarFrame
            
            UIApplication.shared.keyWindow?.addSubview(statusBar)
            
            return statusBar
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            return statusBar
        }
    }
    
}

extension NewsViewController {
    func handleDeepLink(_ deepLink: DeepLink) {
        switch deepLink {
        case .home:
            print("")
        case .scan:
            print("")
        }
    }
}


