import Foundation


import Foundation
import SpriteKit
import UIKit
import GameKit

public class ResultScene: SKScene {
  
  private var cheat: SKSpriteNode!
  private var grudge: SKSpriteNode!
  private var cooperate: SKSpriteNode!
  private var detective: SKSpriteNode!
  private var copycat: SKSpriteNode!
  private var scoreLabel: SKLabelNode!
  var count = 0.0
  var waitTime = 0.1
  var score: Int!
  
  public override func didMove(to view: SKView) {
    run(SKAction.playSoundFileNamed("drumroll.mp3", waitForCompletion: true))
    cheat = childNode(withName: "//cheat") as? SKSpriteNode
    grudge = childNode(withName: "//grudge") as? SKSpriteNode
    cooperate = childNode(withName: "//cooperate") as? SKSpriteNode
    detective = childNode(withName: "//detective") as? SKSpriteNode
    copycat = childNode(withName: "//copycat") as? SKSpriteNode
    
    scoreLabel = childNode(withName: "//scoreLabel") as? SKLabelNode
    scoreLabel.text = "\(score!)"
    setPlayerMode(currentPlayer : cheat, playerMood : .normal, image: "cheat")
    setPlayerMode(currentPlayer : grudge, playerMood : .normal, image: "grudge")
    setPlayerMode(currentPlayer : cooperate, playerMood : .normal, image: "cooperate")
    setPlayerMode(currentPlayer : detective, playerMood : .normal, image: "detective")
    setPlayerMode(currentPlayer : copycat, playerMood : .normal, image: "copycat")
    
  }
  
  func setPlayerMode(currentPlayer : SKSpriteNode, playerMood : PlayerMood, image: String) {
    var texture1 = [SKTexture]()
    var texture2 = [SKTexture]()
    currentPlayer.removeAllActions()
    currentPlayer.texture = SKTexture(imageNamed: image + "0.png")
    texture1 = [SKTexture(imageNamed: image + "0.png"),
                SKTexture(imageNamed: image + "1.png"),
                SKTexture(imageNamed: image + "0.png")]
    
    texture2 = [SKTexture(imageNamed: image + "0.png"),
                SKTexture(imageNamed: image + "1.png"),
                SKTexture(imageNamed: image + "0.png"),
                SKTexture(imageNamed: image + "1.png"),
                SKTexture(imageNamed: image + "0.png")]
    
    animateIdle(currentPlayer: currentPlayer, texture1: texture1, texture2: texture2)
    
  }
  
  func animateIdle(currentPlayer : SKSpriteNode, texture1: [SKTexture] , texture2: [SKTexture]) {
    currentPlayer.removeAllActions()
    run(SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: true))
    currentPlayer.alpha = 1
    let wait = SKAction.wait(forDuration:3, withRange: 2)
    let runAction = SKAction.run {
      
      let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: 2)
      if randomIndex == 0 {
        let texture = SKAction.animate(with: texture1, timePerFrame: 0.2)
        currentPlayer.run(texture)
      } else {
        let texture1 = SKAction.animate(with: texture2, timePerFrame: 0.2)
        currentPlayer.run(texture1)
      }
    }
    currentPlayer.run(SKAction.repeatForever(SKAction.sequence([wait,runAction])))
  }
}


