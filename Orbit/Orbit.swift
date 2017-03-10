//
//  Orbit.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/6/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import SpriteKit

class Orbit: SKNode {
    
    init(radius: CGFloat, vertical: Bool, linearSpeed: CGFloat, _ planets : inout [SKShapeNode]) {
        super.init()
        
        let angularSpeed = linearSpeed / radius
        
        let path = makePath(radius: radius)
        addChild(path)
        
        let position1 = CGPoint(x: radius, y: 0)
        let position2 = CGPoint(x: -radius, y: 0)
        
        let ball1 = makeBall(radius: 25)
        ball1.position = position1
        ball1.zRotation = 0
        addChild(ball1)
        
        let ball2 = makeBall(radius: 25)
        ball2.position = position2
        ball2.zRotation = CGFloat.pi
        addChild(ball2)
        
        planets.append(ball1)
        planets.append(ball2)
        
        if vertical {
            zRotation = CGFloat.pi
        }
        
        run(SKAction.repeatForever(SKAction.rotate(byAngle: angularSpeed, duration: 1)))
    }

    func makeBall(radius: CGFloat) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = ColorTheme.blue
        ball.strokeColor = ColorTheme.blue
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius + 5)
        ball.physicsBody?.categoryBitMask = GameScene.planetCategory
        ball.physicsBody?.collisionBitMask = 0
        
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
