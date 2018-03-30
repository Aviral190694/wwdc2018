
import Foundation
import SpriteKit
import UIKit
import GameKit

public class OpponentScene: SKScene {
  
  private var player: SKSpriteNode!
  private var cheat: SKSpriteNode!
  private var grudge: SKSpriteNode!
  private var cooperate: SKSpriteNode!
  private var detective: SKSpriteNode!
  private var copycat: SKSpriteNode!
  private var allCooperate: Button!
  private var introText: SKLabelNode!
  private var dummyText: SKLabelNode!
  var count = 0.0
  var waitTime = 0.1
  
  public override func didMove(to view: SKView) {
    player = childNode(withName: "//playerN") as? SKSpriteNode
    cheat = childNode(withName: "//cheat") as? SKSpriteNode
    grudge = childNode(withName: "//grudge") as? SKSpriteNode
    cooperate = childNode(withName: "//cooperate") as? SKSpriteNode
    detective = childNode(withName: "//detective") as? SKSpriteNode
    copycat = childNode(withName: "//copycat") as? SKSpriteNode
    
    introText = childNode(withName: "//introText") as? SKLabelNode
    dummyText = childNode(withName: "//dummyText") as? SKLabelNode
    setPlayerMode(currentPlayer : player, playerMood : .normal, image: "player")
    setPlayerMode(currentPlayer : cheat, playerMood : .normal, image: "cheat")
    setPlayerMode(currentPlayer : grudge, playerMood : .normal, image: "grudge")
    setPlayerMode(currentPlayer : cooperate, playerMood : .normal, image: "cooperate")
    setPlayerMode(currentPlayer : detective, playerMood : .normal, image: "detective")
    setPlayerMode(currentPlayer : copycat, playerMood : .normal, image: "copycat")
    addButtons()
    
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
  
  func addButtons() {
    
    
    let button = PlayerButton()
    button.position = CGPoint(x: 623.903 , y: 548.026)
    button.delegate = self
    addChild(button)
    button.addTextNode(text: "   opponent 1")
    button.setButtonType(buttonType: .allDefect)
    
    let button1 = PlayerButton()
    button1.position = CGPoint(x: 841.017 , y: 548.026)
    button1.delegate = self
    addChild(button1)
    button1.addTextNode(text: "  opponent 2")
    button1.setButtonType(buttonType: .copycat)
    
    let button2 = PlayerButton()
    button2.position = CGPoint(x: 623.903 , y: 472.26)
    button2.delegate = self
    addChild(button2)
    button2.addTextNode(text: "   opponent 3")
    button2.setButtonType(buttonType: .prober)
    
    let button3 = PlayerButton()
    button3.position = CGPoint(x: 841.017 , y: 472.26)
    button3.delegate = self
    addChild(button3)
    button3.addTextNode(text: "  opponent 4")
    button3.setButtonType(buttonType: .allCooperate)
    
    let button4 = PlayerButton()
    button4.position = CGPoint(x: 736.018 , y: 411.184)
    button4.delegate = self
    addChild(button4)
    button4.addTextNode(text: "  opponent 5")
    button4.setButtonType(buttonType: .grudges)
    
    
    
    allCooperate = Button()
    allCooperate.position = CGPoint(x: 736.018 , y: 95.362)
    allCooperate.delegate = self
    addChild(allCooperate)
    allCooperate.addTextNode(text: "Rules?")
    allCooperate.setButtonType(buttonType: .allCooperate)
    
  }
  
  
}

extension OpponentScene: PlayerButtonDelegate {
  func didTap(sender: PlayerButton, type: PlayerType) {
    let jump = SKAction(named: "jump")!
    switch type {
    case .allCooperate :
      print("All Cooperate")
      cooperate.run(SKAction.sequence([jump,jump]))
    case .allDefect :
      print("defecct")
      cheat.run(SKAction.sequence([jump,jump]))
    case .copycat :
      print("copycat")
      copycat.run(SKAction.sequence([jump,jump]))
    case .grudges:
      print("Grudge")
      grudge.run(SKAction.sequence([jump,jump]))
    case .prober:
      print("prober")
      detective.run(SKAction.sequence([jump,jump]))
    }
  }
}


extension OpponentScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonType) {
    sender.setButtonDeactive()
    let gameScene = GameScene(fileNamed: "GameScene")!
    let transition = SKTransition.flipVertical(withDuration: 1.0)
    gameScene.scaleMode = .aspectFill
    view?.presentScene(gameScene, transition: transition)
  }
}
