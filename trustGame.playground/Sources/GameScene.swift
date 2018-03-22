import Foundation
import SpriteKit

public class GameScene: SKScene {
  
  private var label: SKLabelNode!
  private var spinnyNode: SKShapeNode!
  private var backAnim: SKSpriteNode!
  private var player: SKSpriteNode!
  private var player1: SKSpriteNode!
  private var coin: SKSpriteNode!
  private var coin1: SKSpriteNode!
  private var allCooperate: Button!
  private var cooperateCheat: Button!
  private var cheatCooperate: Button!
  private var allCheat: Button!
  
  
  public override func didMove(to view: SKView) {
    
    backAnim = childNode(withName: "//payoffAnim") as? SKSpriteNode
    player = childNode(withName: "//player") as? SKSpriteNode
    player1 = childNode(withName: "//player1") as? SKSpriteNode
    coin = childNode(withName: "//coin") as? SKSpriteNode
    
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
    
    
    
    startMachine()
  }
  
  func startMachine() {
     backAnim.run(SKAction.repeat(SKAction(named: "machineAnimation")! , count: 1))
    playerAnimation()
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
  
}

extension GameScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonTypes) {
    print("Tapped", type)
  }
}
