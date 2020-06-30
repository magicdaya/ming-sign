//
//  AppDelegate.swift
//  ming sign
//
//  Created by magicday.a on 03.12.19.
//  Copyright © 2019 magicdaya. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // create default image when first time launched
        if ImageStorage.getFileSystemImagesCount() <= 0 && UserDefaults.standard.bool(forKey: "defaultImage") == false {
            if let image = UIImage(named: "magicCopy") {
                ImageStorage.storeImage(image: image, forKey: "magicImage")
             //   print("default image saved to ming sign folder")
                UserDefaults.standard.set(true, forKey: "defaultImage")
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

