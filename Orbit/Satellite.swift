//
//  Satellite.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/5/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import Foundation
import SpriteKit

class Satellite: SKNode {
    
    private var radius : CGFloat!
    public var ball : SKShapeNode!
    private var direction : CGFloat = 1
    private var tangentialSpeed : CGFloat = 50
    
    init(radius: CGFloat, orbit: CGFloat, color: UIColor) {
        super.init()

        self.radius = radius
        
        ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = color
        ball.strokeColor = color
        ball.zPosition = 1
        ball.physicsBody = SKPhysicsBody(circleOfRadius: radius + 5)
        ball.physicsBody?.categoryBitMask = 0x02
        ball.physicsBody?.collisionBitMask = 0x0
        ball.position = CGPoint(x: orbit, y: 0)
        addChild(ball)
        
        run(SKAction.repeatForever(SKAction.rotate(byAngle: direction * tangentialSpeed / radius, duration: 1)))
    }
    
    public func updateOrbit() {
        removeAllActions()
        run(SKAction.repeatForever(SKAction.rotate(byAngle: direction * tangentialSpeed / radius, duration: 1)))
    }
    
    public func fast() {
        tangentialSpeed = 100
    }
    
    public func slow() {
        tangentialSpeed = 50
    }
    
    public func changeDirection() {
        direction *= -1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
