//
//  GameViewController.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/4/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    static var controller : GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
        GameViewController.controller = self
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { viewController, error in
            if let controller = viewController {
                self.present(controller, animated: true, completion: nil)
            } else if localPlayer.isAuthenticated {
                print("Authentication Succeeded")
            } else {
                print("Authentication Failed")
            }
        }
    }
    

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        if let view = self.view as! SKView? {
            if let scene = GameScene(fileNamed: "GameScene") {
                scene.scaleMode = .resizeFill
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    
    func didClickLeaderboard() {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.leaderboards
        gc.leaderboardIdentifier = "com.tbarrett.stickyOrbit.highScore"
        present(gc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
