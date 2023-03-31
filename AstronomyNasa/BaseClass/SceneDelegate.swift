//
//  SceneDelegate.swift
//  AstronomyNasa
//
//  Created by Shashank Mishra on 23/03/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        if let rootVC = scene.windows.first?.rootViewController as? PODViewController {
            rootVC.viewModel = PODViewModel()
        }
    }
    
}

