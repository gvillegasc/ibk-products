//
//  SceneDelegate.swift
//  ibk-products
//
//  Created by Gerardo Villegas on 17/10/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Scene Connection

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
        self.window = window
    }

    // MARK: - Scene Disconnection

    func sceneDidDisconnect(_ scene: UIScene) {}

    // MARK: - Scene Did Become Active

    func sceneDidBecomeActive(_ scene: UIScene) {}

    // MARK: - Scene Will Resign Active

    func sceneWillResignActive(_ scene: UIScene) {}

    // MARK: - Scene Will Enter Foreground

    func sceneWillEnterForeground(_ scene: UIScene) {}

    // MARK: - Scene Did Enter Background

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
