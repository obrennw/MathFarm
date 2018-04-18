//
//  AppDelegate.swift
//  MathFarm
//
//  Created by oqbrennw on 2/23/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import UIKit

/// A component that complements the storyboard by defining application logic for different states of the application with respect to how it is used on the device (open, closed, paused, etc.)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// UI Window that 
    var window: UIWindow?

    /// Override point for customization after application launch.
    ///
    /// - Parameters:
    ///   - application: app to be launched
    ///   - launchOptions: options for launching
    /// - Returns: Boolean of whether app is lauched successfully
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state. Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    ///
    /// - Parameter application: app for reference
    func applicationWillResignActive(_ application: UIApplication) {
    }

    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    ///
    /// - Parameter application: app for reference
    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    /// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    ///
    /// - Parameter application: app for reference
    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    ///
    /// - Parameter application: app for reference
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground
    ///
    /// - Parameter application: app for reference
    func applicationWillTerminate(_ application: UIApplication) {
    }


}

