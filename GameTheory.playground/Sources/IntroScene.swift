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
  var textArray = ["Every person is different.",
                   "Even though they look similar \nThey all lead life differently.",
                   "They all take decisions differrently",
                   "and then there's me!"]
  
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
      } else {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let newString = NSMutableAttributedString(string: self.textArray[self.textCount], attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        newString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black , range: NSMakeRange(0,self.textArray[self.textCount].count))
        newString.addAttribute( NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 36)!, range: NSMakeRange(0,self.textArray[self.textCount].count))
        self.dummyText.attributedText = newString
        //      self.dummyText.text = self.textArray[self.textCount]
        self.textCount += 1
      }
    }
    
    let action = SKAction.run {
      self.addPeople()
      self.dummyText.run(SKAction.fadeIn(withDuration : 0.5))
      self.run(SKAction.repeat(SKAction.sequence([SKAction.wait(forDuration: 2),action2]), count: 5))
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
    self.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.3),SKAction.fadeIn(withDuration: 0.4)]), completion: {
      self.introText.alpha = 1
      self.addButtons()
      currentPlayer.texture = SKTexture(imageNamed: image + "0.png")
      texture1 = [SKTexture(imageNamed: image + "0.png"),
                  SKTexture(imageNamed: image + "1.png"),
                  SKTexture(imageNamed: image + "0.png")]
      
      texture2 = [SKTexture(imageNamed: image + "0.png"),
                  SKTexture(imageNamed: image + "1.png"),
                  SKTexture(imageNamed: image + "0.png"),
                  SKTexture(imageNamed: image + "1.png"),
                  SKTexture(imageNamed: image + "0.png")]
      
      self.animateIdle(currentPlayer: currentPlayer, texture1: texture1, texture2: texture2)
      
    })
    
  }
  
  func animateIdle(currentPlayer : SKSpriteNode, texture1: [SKTexture] , texture2: [SKTexture]) {
    currentPlayer.removeAllActions()
    run(SKAction.playSoundFileNamed("popSound.mp3", waitForCompletion: true))
    currentPlayer.run(SKAction.playSoundFileNamed("pla.mp3", waitForCompletion: false))
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
    allCooperate.position = CGPoint(x: 615 , y: 280)
    allCooperate.delegate = self
    addChild(allCooperate)
    allCooperate.addTextNode(text: "Continue?")
    allCooperate.setButtonType(buttonType: .allCooperate)
  }
  
}

extension IntroScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonType) {
    sender.setButtonDeactive()
    let gameScene = OpponentScene(fileNamed: "GameScene3")!
    let transition = SKTransition.doorway(withDuration: 1.0)
    gameScene.scaleMode = .aspectFill
    view?.presentScene(gameScene, transition: transition)
  }
}
