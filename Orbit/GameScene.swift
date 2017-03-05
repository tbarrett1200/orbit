//
//  GameScene.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/4/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode!
    private var leaderboard : SKSpriteNode!
    private var pause : SKSpriteNode!
   
    private var orbit1 : SKNode!
    private var orbit2 : SKNode!
    private var orbit3 : SKNode!
    private var satellite : SKShapeNode!
    
    private var linearSpeed : CGFloat = 100
    private var satelliteSpeed : CGFloat = 100
    private var satelliteDirection : CGFloat = 1
    
    private var time : Double = 0
    private var lastTime : Double = 0
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        label = childNode(withName: "Label") as! SKLabelNode?
        leaderboard = childNode(withName: "Leaderbord") as! SKSpriteNode?
        pause = childNode(withName: "Pause") as! SKSpriteNode?

        orbit1 = makeOrbit(radius: 100, vertical: false)
        orbit1.run(SKAction.repeatForever(SKAction.rotate(byAngle: linearSpeed/100, duration: 1)))
        addChild(orbit1)
        
        orbit2 = makeOrbit(radius: 200, vertical: false)
        orbit2.run(SKAction.repeatForever(SKAction.rotate(byAngle: -linearSpeed/200, duration: 1)))
        addChild(orbit2)
        
        orbit3 = makeOrbit(radius: 300, vertical: false)
        orbit3.run(SKAction.repeatForever(SKAction.rotate(byAngle: linearSpeed/300, duration: 1)))
        addChild(orbit3)
        
        
        let star = makeStar(radius: 20)
        star.position = CGPoint(x: 50, y: 0)
        orbit3.children[1].addChild(star)
        star.parent?.run(SKAction.repeatForever(SKAction.rotate(byAngle: satelliteSpeed / 50, duration: 1)))

        
        satellite = makeSatellite(radius: 25)
        satellite.position = CGPoint(x: 50, y: 0)
        orbit1.children[1].addChild(satellite)
        satellite.parent?.run(SKAction.repeatForever(SKAction.rotate(byAngle: satelliteSpeed / 50, duration: 1)))

    }

    func makeOrbit(radius: CGFloat, vertical: Bool) -> SKNode {
        let node = SKNode()
        
        let path = makePath(radius: radius)
        node.addChild(path)
        
        let position1 = vertical ? CGPoint(x: 0, y: radius) : CGPoint(x: radius, y: 0)
        let position2 = vertical ? CGPoint(x: 0, y: -radius) : CGPoint(x: -radius, y: 0)
        
        let ball1 = makeBall(radius: 25)
        ball1.position = position1
        node.addChild(ball1)
        
        let ball2 = makeBall(radius: 25)
        ball2.position = position2
        node.addChild(ball2)
        
        return node
    }
    
    func makeStar(radius: CGFloat) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = ColorTheme.yellow
        ball.strokeColor = ColorTheme.yellow
        ball.zPosition = 1
        return ball
    }
    func makeSatellite(radius: CGFloat) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = ColorTheme.dark
        ball.strokeColor = ColorTheme.dark
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius + 5)
        ball.physicsBody?.categoryBitMask = 0x02
        ball.physicsBody?.collisionBitMask = 0x0
        return ball
    }
    
    func makeBall(radius: CGFloat) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = ColorTheme.blue
        ball.strokeColor = ColorTheme.blue
        ball.zPosition = 1
        ball.name = "Ball"
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius + 5)
        ball.physicsBody?.contactTestBitMask = 0x02
        ball.physicsBody?.collisionBitMask = 0x0
        
        let path = makePath(radius: radius + 25)
        ball.addChild(path)
        
        return ball
    }
    
    func makePath(radius: CGFloat) -> SKShapeNode {
        let path = SKShapeNode(circleOfRadius: radius)
        path.fillColor = .clear
        path.strokeColor = ColorTheme.grey
        path.lineWidth = 2
        path.zPosition = 0
        return path
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        satellite.parent?.removeAllActions()
        satelliteSpeed = 200
        satellite.parent?.run(SKAction.repeatForever(SKAction.rotate(byAngle: satelliteDirection * satelliteSpeed / 50, duration: 1)))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        satellite.parent?.removeAllActions()
        satelliteSpeed = 100
        satellite.parent?.run(SKAction.repeatForever(SKAction.rotate(byAngle: satelliteDirection * satelliteSpeed / 50, duration: 1)))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard time - lastTime > 1 else {
            return
        }
        
        if contact.bodyA.node !== satellite.parent {
        
            lastTime = time
            
            let oldLocation = convert(satellite.position, from: satellite.parent!)
            let newLocation = convert(oldLocation, to: contact.bodyA.node!)
        
            satellite.parent?.removeAllActions()
            satellite.removeFromParent()
            satellite.position = newLocation
            
            var angle = atan(newLocation.y/newLocation.x)
            angle = satellite.position.x < 0 ? CGFloat.pi + angle : angle
            print(angle)

            satellite.position.x = 50 * cos(angle)
            satellite.position.y = 50 * sin(angle)
            
            contact.bodyA.node?.addChild(satellite)
            satelliteDirection *= -1
            satellite.parent?.run(SKAction.repeatForever(SKAction.rotate(byAngle: satelliteDirection * satelliteSpeed / 50, duration: 1)))
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        time = currentTime
    }
}
