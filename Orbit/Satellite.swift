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
    public var direction : CGFloat = 1
    private var tangentialSpeed : CGFloat = 50
    
   
    init(radius: CGFloat, orbit: CGFloat, color: UIColor) {
        super.init()

        self.radius = radius
        
        ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = color
        ball.strokeColor = color
        ball.zPosition = 1
        ball.position = CGPoint(x: orbit, y: 0)
        addChild(ball)
        
        run(SKAction.repeatForever(SKAction.rotate(byAngle: direction * tangentialSpeed / radius, duration: 1)))
    }
    
    public func speedUp() {
        tangentialSpeed = 200
        updateOrbit()
    }
    
    public func slowDown() {
        tangentialSpeed = 50
        updateOrbit()
    }
    
    public func changeDirection() {
        direction *= -1
        updateOrbit()
    }
    
    private func updateOrbit() {
        removeAllActions()
        run(SKAction.repeatForever(SKAction.rotate(byAngle: direction * tangentialSpeed / radius, duration: 1)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
