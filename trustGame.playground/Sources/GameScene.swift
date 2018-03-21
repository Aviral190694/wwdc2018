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
  private var allCooperate: PlayButton!
  
  public override func didMove(to view: SKView) {
    
    backAnim = childNode(withName: "//payoffAnim") as? SKSpriteNode
    player = childNode(withName: "//player") as? SKSpriteNode
    player1 = childNode(withName: "//player1") as? SKSpriteNode
    coin = childNode(withName: "//coin") as? SKSpriteNode
    
    allCooperate = PlayButton()
    allCooperate.position = CGPoint(x: -120 , y: -200)
    allCooperate.delegate = self
    addChild(allCooperate)
    
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

extension GameScene: PlayButtonDelegate {
  func didTapPlay(sender: PlayButton) {
    print("Tapped")
  }
}
