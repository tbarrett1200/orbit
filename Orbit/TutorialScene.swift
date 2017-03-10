//
//  TutorialScene.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/5/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene {
    
    var tutorial : Int = 1
    var texture : SKSpriteNode?
    var label : SKLabelNode?
    
    override func didMove(to view: SKView) {
        texture = SKSpriteNode(imageNamed: "Tutorial1")
        addChild(texture!)
        
        label = childNode(withName: "Label") as! SKLabelNode?
        label?.position.y = frame.height/2 - 50
        label?.text = "Tap and hold to spin faster"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tutorial += 1
        switch tutorial {
        case 2:
            texture?.removeFromParent()
            texture = SKSpriteNode(imageNamed: "Tutorial2")
            addChild(texture!)
            label?.text = "When the paths align..."
        case 3:
            texture?.removeFromParent()
            texture = SKSpriteNode(imageNamed: "Tutorial3")
            addChild(texture!)
            label?.text = "... the ball can jump from path to path"
        case 4:
            texture?.removeFromParent()
            texture = SKSpriteNode(imageNamed: "Tutorial4")
            addChild(texture!)
            label?.text = "Avoid the red balls"
        case 5:
            texture?.removeFromParent()
            texture = SKSpriteNode(imageNamed: "Tutorial5")
            addChild(texture!)
            label?.text = "Try to collect the yellow balls"
        default:
            if let view = self.view {
                if let scene = SKScene(fileNamed: "GameScene") {
                    scene.scaleMode = .resizeFill
                    view.presentScene(scene)
                }
                view.ignoresSiblingOrder = true
            }
        }
    }
}
