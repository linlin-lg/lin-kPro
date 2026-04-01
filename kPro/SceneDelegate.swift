//
//  SceneDelegate.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 纯代码创建 window，不依赖 Storyboard
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        // 应用用户保存的外观设置
        applyUserInterfaceStyle()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // MARK: - Appearance Management
    private func applyUserInterfaceStyle() {
        let savedStyle = UserDefaults.standard.integer(forKey: "UserInterfaceStyle")
        let userInterfaceStyle: UIUserInterfaceStyle
        
        if savedStyle == UIUserInterfaceStyle.dark.rawValue {
            userInterfaceStyle = .dark
        } else if savedStyle == UIUserInterfaceStyle.light.rawValue {
            userInterfaceStyle = .light
        } else {
            // 如果没有保存的设置，使用系统默认
            userInterfaceStyle = .unspecified
        }
        
        // 应用外观设置到所有窗口
        if let windowScene = window?.windowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = userInterfaceStyle
            }
        }
    }
}

