//
//  GameScene.swift
//  Orbit
//
//  Created by Thomas Barrett on 3/4/17.
//  Copyright © 2017 Thomas Barrett. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit


protocol ButtonDelegate {
    func didClickLeaderboard() -> Void
    func didClickHelp() -> Void
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var scoreLabel : SKLabelNode!
    private var bestLabel : SKLabelNode!
    private var restart : SKLabelNode!
    private var leaderboard : SKSpriteNode!
    private var help : SKSpriteNode!
   
    private var satellite : Satellite!
    private var star : Satellite!
    
    private var orbits = [Orbit]()
    private var planets = [SKShapeNode]()
    private var obstacles = [Satellite]()
    private var game = SKNode()
    
    private var linearSpeed : CGFloat = 100
    
    private var time : Double = 0
    private var lastTime : Double = 0
    
    public static var playerCategory : UInt32 = 1
    public static var starCategory : UInt32 = 2
    public static var obstacleCategory : UInt32 = 4
    public static var planetCategory : UInt32 = 8
    public static var otherCategory : UInt32 = 2 | 4 | 8
    
    public var buttonDelegate : ButtonDelegate?
    
    private var score : Int = 0 {
        didSet {
            scoreLabel?.text = "\(score)"
        }
    }
    
    private var highScore : Int {
        get {
            return UserDefaults.standard.integer(forKey: "highScore")
        }
        set(score) {
            UserDefaults.standard.set(score, forKey: "highScore")
            bestLabel.text = "Best: \(score)"
            let localPlayer = GKLocalPlayer.localPlayer()
            if localPlayer.isAuthenticated {
                let score = GKScore(leaderboardIdentifier: "com.tbarrett.StickyOrbit.highScore", player: localPlayer)
                score.value = Int64(highScore)
                GKScore.report([score], withCompletionHandler: nil)
            }
        }
    }

    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        leaderboard = childNode(withName: "Leaderboard") as! SKSpriteNode?
        leaderboard.position.x = -frame.width/2 + 50
        leaderboard.position.y = frame.height/2 - 50

        help = childNode(withName: "Help") as! SKSpriteNode?
        help.position.x = frame.width/2 - 50
        help.position.y = frame.height/2 - 50
        
        scoreLabel = childNode(withName: "Score") as! SKLabelNode?
        scoreLabel.position.y = help.frame.midY
        
        bestLabel = childNode(withName: "Best") as! SKLabelNode?
        bestLabel.text = "Best: \(highScore)"
        bestLabel.position.y = help.frame.minY

        restart = childNode(withName: "Restart") as! SKLabelNode?
        restart.position.y = -frame.height/2 + 50
        restart.isHidden = true
        
        orbits.append(Orbit(radius: 100, vertical: false, linearSpeed: linearSpeed, &planets))
        orbits.append(Orbit(radius: 200, vertical: false, linearSpeed: -linearSpeed, &planets))
        orbits.append(Orbit(radius: 300, vertical: false, linearSpeed: linearSpeed, &planets))
        
        for orbit in orbits {
            game.addChild(orbit)
        }
        
        satellite = Satellite(radius: 25, orbit: 50, color: ColorTheme.dark)
        satellite.ball.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        satellite.ball.physicsBody?.categoryBitMask = GameScene.playerCategory
        satellite.ball.physicsBody?.contactTestBitMask = GameScene.otherCategory
        satellite.ball.physicsBody?.collisionBitMask = 0
        emptyPlanet().addChild(satellite)
        
        star = Satellite(radius: 20, orbit: 50, color: ColorTheme.yellow)
        star.ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        star.ball.physicsBody?.categoryBitMask = GameScene.starCategory
        star.ball.physicsBody?.collisionBitMask = 0x0
        emptyPlanet().addChild(star)

        obstacles.append(Satellite(radius: 20, orbit: 50, color:  ColorTheme.red))
        obstacles.append(Satellite(radius: 20, orbit: 50, color:  ColorTheme.red))

        for obstacle in obstacles {
            obstacle.ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            obstacle.ball.physicsBody?.categoryBitMask = GameScene.obstacleCategory
            obstacle.ball.physicsBody?.collisionBitMask = 0x0
            emptyPlanet().addChild(obstacle)
        }
        
        let upper = bestLabel.frame.minY
        let lower = restart.frame.maxY

        game.position.y = (upper + lower)/2
        addChild(game)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if help.contains(touches.first!.location(in: self)) {
           didClickHelp()
        } else if leaderboard.contains(touches.first!.location(in: self)) {
            didClickLeaderboard()
        } else if isPaused {
            restartGame()
        } else {
            satellite.speedUp()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        satellite.slowDown()
    }
    
    func emptyPlanet() -> SKShapeNode {
        var planet : SKShapeNode
        
        repeat {
            planet = planets[Int(arc4random_uniform(UInt32(planets.count)))]
        } while planet.children.count != 1

        return planet
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == GameScene.playerCategory ? contact.bodyB : contact.bodyA
        let node = body.node!
        let category = body.categoryBitMask
        
        switch category {
        case GameScene.starCategory: didScore()
        case GameScene.obstacleCategory: didLose()
        case GameScene.planetCategory: didContact(planet: node)
        default: print("Contacted Unknown Physics Body")
        }
    }
    
    func didContact(planet: SKNode) {
        guard time - lastTime > 1 else {
            return
        }
        
        if planet !== satellite.parent {
            lastTime = time
            satellite.removeFromParent()
            satellite.zRotation += CGFloat.pi
            planet.addChild(satellite)
            satellite.changeDirection()
        }
    }
        
    func didScore() {
        for obstacle in self.obstacles {
            obstacle.removeFromParent()
            self.emptyPlanet().addChild(obstacle)

        }
        
        self.star.removeFromParent()
        self.emptyPlanet().addChild(self.star)
        
        score += 1
    }
    
    func didClickHelp() {
        if let scene = SKScene(fileNamed: "TutorialScene") {
            scene.scaleMode = .resizeFill
            view?.presentScene(scene)
        }
        view?.ignoresSiblingOrder = true
    }
    
    func didClickLeaderboard() {
        GameViewController.controller?.didClickLeaderboard()
    }
    
    func didLose() {
        if score > highScore {
            highScore = score
        }
        isPaused = true
        restart.isHidden = false
    }

    func restartGame() {

        for node in [satellite!, star!, obstacles[0], obstacles[1]]{
            node.removeFromParent()
            emptyPlanet().addChild(node)
            restart.isHidden = true
        }
        isPaused = false
        score = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        time = currentTime
        
        for node in [satellite!, star!, obstacles[0], obstacles[1]] {
            if node.parent?.parent === orbits[1] {
                if node.direction == 1 {
                    node.changeDirection()
                }
            } else if node.parent?.parent === orbits[0] {
                if node.direction == -1 {
                    node.changeDirection()
                }
            } else if node.parent?.parent === orbits[2] {
                if node.direction == -1 {
                    node.changeDirection()
                }
            }
        }
    }
}

