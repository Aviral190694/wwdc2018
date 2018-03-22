import Foundation
import SpriteKit
import UIKit
import GameKit

public class GameScene: SKScene {
  
  private var label: SKLabelNode!
  private var spinnyNode: SKShapeNode!
  private var machineAnim: SKSpriteNode!
  private var player: SKSpriteNode!
  private var player1: SKSpriteNode!
  private var coin: SKSpriteNode!
  private var coin1: SKSpriteNode!
  
  private var allCooperate: Button!
  private var cooperateCheat: Button!
  private var cheatCooperate: Button!
  private var allCheat: Button!
  
  private var youCheatLabel: SKLabelNode!
  private var youCooperateLabel: SKLabelNode!
  private var theyCooperateLabel: SKLabelNode!
  private var theyCheatLabel: SKLabelNode!
  
  private var playerMood: PlayerMood!
  private var player1Mood: PlayerMood!
  
  public override func didMove(to view: SKView) {
    
    
    
    machineAnim = childNode(withName: "//payoffAnim") as? SKSpriteNode
    player = childNode(withName: "//player") as? SKSpriteNode
    player1 = childNode(withName: "//player1") as? SKSpriteNode
    coin = childNode(withName: "//coin") as? SKSpriteNode
    
    youCheatLabel = childNode(withName: "//youCheat") as? SKLabelNode
    youCooperateLabel = childNode(withName: "//youCooperate") as? SKLabelNode
    theyCheatLabel = childNode(withName: "//theyCheat") as? SKLabelNode
    theyCooperateLabel = childNode(withName: "//theyCooperate") as? SKLabelNode
    
    playerMood = .normal
    player1Mood = .sad
    setPlayerMode(currentPlayer : player, playerMood : .normal, image: "player")
    setPlayerMode(currentPlayer : player1, playerMood : .sad, image: "player")
//    changeColorLabel(colorLabel: youCooperateLabel, changeColor: UIColor(red: 255.0/255.0,green: 230.0/255.0, blue: 99.0/255.0,alpha: 1))
//  machineAnim.texture = SKTexture(imageNamed: "payoff7.png")
    
    addButtons()
    startMachine()
    
  }
  
  func setPlayerMode(currentPlayer : SKSpriteNode, playerMood : PlayerMood, image: String) {
    var texture1 = [SKTexture]()
    var texture2 = [SKTexture]()
    switch playerMood {
    case .normal:
      currentPlayer.texture = SKTexture(imageNamed: image + "0.png")
      texture1 = [SKTexture(imageNamed: "player0.png"),
                             SKTexture(imageNamed: image + "1.png"),
                             SKTexture(imageNamed: image + "0.png")]
 
      texture2 = [SKTexture(imageNamed: image + "0.png"),
                             SKTexture(imageNamed: image + "1.png"),
                             SKTexture(imageNamed: image + "0.png"),
                             SKTexture(imageNamed: image + "1.png"),
                             SKTexture(imageNamed: image + "0.png")]
    case .happy:
      currentPlayer.texture = SKTexture(imageNamed: image + "2.png")
      texture1 = [SKTexture(imageNamed: image + "2.png"),
                             SKTexture(imageNamed: image + "3.png"),
                             SKTexture(imageNamed: image + "2.png")]
      
      texture2 = [SKTexture(imageNamed: image + "2.png"),
                             SKTexture(imageNamed: image + "3.png"),
                             SKTexture(imageNamed: image + "2.png"),
                             SKTexture(imageNamed: image + "3.png"),
                             SKTexture(imageNamed: image + "2.png")]
    case .angry:
      currentPlayer.texture = SKTexture(imageNamed: image + "4.png")
      texture1 = [SKTexture(imageNamed: image + "4.png"),
                  SKTexture(imageNamed: image + "5.png"),
                  SKTexture(imageNamed: image + "4.png")]
      
      texture2 = [SKTexture(imageNamed: image + "4.png"),
                  SKTexture(imageNamed: image + "5.png"),
                  SKTexture(imageNamed: image + "4.png"),
                  SKTexture(imageNamed: image + "5.png"),
                  SKTexture(imageNamed: image + "4.png")]
    case .sad:
      currentPlayer.texture = SKTexture(imageNamed: image + "6.png")
      texture1 = [SKTexture(imageNamed: image + "6.png"),
                  SKTexture(imageNamed: image + "7.png"),
                  SKTexture(imageNamed: image + "6.png")]
      
      texture2 = [SKTexture(imageNamed: image + "6.png"),
                  SKTexture(imageNamed: image + "7.png"),
                  SKTexture(imageNamed: image + "6.png"),
                  SKTexture(imageNamed: image + "7.png"),
                  SKTexture(imageNamed: image + "6.png")]
    case .swag:
      currentPlayer.texture = SKTexture(imageNamed: image + "8.png")
      texture1 = [SKTexture(imageNamed: image + "6.png"),
                  SKTexture(imageNamed: image + "7.png"),
                  SKTexture(imageNamed: image + "6.png")]
      
      texture2 = [SKTexture(imageNamed: image + "6.png"),
                  SKTexture(imageNamed: image + "7.png"),
                  SKTexture(imageNamed: image + "6.png"),
                  SKTexture(imageNamed: image + "7.png"),
                  SKTexture(imageNamed: image + "6.png")]
    }
    
    animateIdle(currentPlayer: currentPlayer, texture1: texture1, texture2: texture2)
    
  }
  
  func animateIdle(currentPlayer : SKSpriteNode, texture1: [SKTexture] , texture2: [SKTexture]) {
    currentPlayer.removeAllActions()
    let wait = SKAction.wait(forDuration:3, withRange: 2)
    let runAction = SKAction.run {
      let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
      if randomIndex == 0 {
        let texture = SKAction.animate(with: texture1, timePerFrame: 0.2)
        currentPlayer.run(texture)
      } else if randomIndex == 1 {
        let texture1 = SKAction.animate(with: texture2, timePerFrame: 0.2)
        currentPlayer.run(texture1)
      } else {
        let texture = SKAction.animate(with: texture1, timePerFrame: 0.2)
        let jump = SKAction(named: "jump")!
        currentPlayer.run(SKAction.group([texture,jump]))
      }
    }
    currentPlayer.run(SKAction.repeatForever(SKAction.sequence([wait,runAction])))
  }
  
  func addButtons() {
    
    allCooperate = Button()
    allCooperate.position = CGPoint(x: 349.01 , y: 208.675)
    allCooperate.delegate = self
    addChild(allCooperate)
    allCooperate.addTextNode(text: "All Cooperate")
    allCooperate.setButtonType(buttonType: ButtonTypes.allCooperate)
    
    cooperateCheat = Button()
    cooperateCheat.position = CGPoint(x: 661.484 , y: 208.675)
    cooperateCheat.delegate = self
    addChild(cooperateCheat)
    cooperateCheat.addTextNode(text: "Cooperate - Cheat")
    cooperateCheat.setButtonType(buttonType: ButtonTypes.cooperateCheat)
    
    cheatCooperate = Button()
    cheatCooperate.position = CGPoint(x: 349.01 , y: 97.728)
    cheatCooperate.delegate = self
    addChild(cheatCooperate)
    cheatCooperate.addTextNode(text: "Cheat - Cooperate")
    cheatCooperate.setButtonType(buttonType: ButtonTypes.cheatCooperate)
    
    allCheat = Button()
    allCheat.position = CGPoint(x: 661.484 , y: 97.728)
    allCheat.delegate = self
    addChild(allCheat)
    allCheat.addTextNode(text: "All Cheat")
    allCheat.setButtonType(buttonType: ButtonTypes.allCheat)
    
  }
  
  func changeColorLabel(colorLabel: SKLabelNode, changeColor : UIColor) {
    print(colorLabel)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let newString = NSMutableAttributedString(string: colorLabel.attributedText!.string, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
    newString.addAttribute(NSAttributedStringKey.foregroundColor, value: changeColor , range: NSMakeRange(0,colorLabel.attributedText!.length))
    
      newString.addAttribute( NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!, range: NSMakeRange(0,colorLabel.attributedText!.length))
    
    colorLabel.attributedText = newString
  }
  
  func startMachine() {
    machineAnim.run(SKAction.repeat(SKAction(named: "machineAnimation")! , count: 1))
  }
  
  func playerAnimation() {
    let actionPlayer =  SKAction(named : "playerMoveJump")!
    let actionCoin = SKAction(named : "coinCooperate")!
    let wait = SKAction.wait(forDuration:3.2)
    
    let action = SKAction.run {
      self.coin.run(actionCoin)
      self.player.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer]))
    }
    
    run(SKAction.repeat(SKAction.sequence([wait, action]) , count: 1))
  }
  
  func deactiveAllButton() {
    allCheat.isUserInteractionEnabled = false
    allCooperate.isUserInteractionEnabled = false
    cheatCooperate.isUserInteractionEnabled = false
    cooperateCheat.isUserInteractionEnabled = false
  }
  
  func activateAllButton() {
    allCheat.isUserInteractionEnabled = true
    allCooperate.isUserInteractionEnabled = true
    cheatCooperate.isUserInteractionEnabled = true
    cooperateCheat.isUserInteractionEnabled = true
  }
  
}

extension GameScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonTypes) {
    print("Tapped", type)
    sender.texture = SKTexture(imageNamed: "buttonDeactivated.png")
    sender.textNode.fontColor = SKColor.gray
  }
}
