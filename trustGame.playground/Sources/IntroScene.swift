import Foundation

import Foundation
import SpriteKit
import UIKit
import GameKit

public class IntroScene: SKScene {
  
  private var player: SKSpriteNode!
  private var allCooperate: Button!
  private var introText: SKLabelNode!
  private var dummyText: SKLabelNode!
  var count = 0.0
  var waitTime = 0.13
  var textCount = 0
  var textArray = ["Every person is different.", "They all lead life differently.", "They all take decision differrently","and then there's me!"]
  
  public override func didMove(to view: SKView) {
    run(SKAction.repeatForever(SKAction.playSoundFileNamed("bg_music.mp3", waitForCompletion: true)))
    player = childNode(withName: "//player") as? SKSpriteNode
    introText = childNode(withName: "//introText") as? SKLabelNode
    dummyText = childNode(withName: "//dummyText") as? SKLabelNode
//    setPlayerMode(currentPlayer : player, playerMood : .normal, image: "player")
//    addButtons()
    
    
    let wait = SKAction.wait(forDuration: 0.3)
    
    let action2 = SKAction.run {
      if self.textCount == 4 {
        self.removeAllActions()
        self.dummyText.isHidden = true
        self.removePeople()
        self.setPlayerMode(currentPlayer : self.player, playerMood : .normal, image: "player")
        self.introText.alpha = 1
        self.addButtons()
      } else {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center
      
      let newString = NSMutableAttributedString(string: self.textArray[self.textCount], attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
      newString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: NSMakeRange(0,self.textArray[self.textCount].count))
      newString.addAttribute( NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 24.0)!, range: NSMakeRange(0,self.textArray[self.textCount].count))
      self.dummyText.attributedText = newString
//      self.dummyText.text = self.textArray[self.textCount]
      self.textCount += 1
      }
    }
    
    let action = SKAction.run {
      self.addPeople()
     self.dummyText.run(SKAction.fadeIn(withDuration : 0.5))
      self.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 1.2),action2]), count: 5))
    }
    
    run(SKAction.sequence([wait, action]))
    
  }
  
  func addPeople() {
    enumerateChildNodes(withName: "dummyPlayer") { (node, stop) in
      let wait = SKAction.wait(forDuration: 0.3 + self.waitTime * self.count)
      self.count += 1
      let action = SKAction.run {
        node.run(SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: true))
        node.alpha = 1
      }
      node.run(SKAction.sequence([wait, action]))
    }
  }
  
  func removePeople() {
    self.count = 0
    enumerateChildNodes(withName: "dummyPlayer") { (node, stop) in
      node.run(SKAction.fadeOut(withDuration: 0.3))
    }
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
    allCooperate.setButtonType(buttonType: .allCooperate)
    
  }
  
  func gamePlay(sender: Button, type: ButtonType) {
  }
  
}

extension IntroScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonType) {
    sender.setButtonDeactive()
    gamePlay(sender: sender, type: type)
  }
}
