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
  
  private var coinPosition: CGPoint!
  private var coin1Position: CGPoint!
  
  private var coinGiveAway: SKSpriteNode!
  private var coinGiveAway1: SKSpriteNode!
  private var coinGiveAway2: SKSpriteNode!
  private var coinGiveAwayAi: SKSpriteNode!
  private var coinGiveAwayAi1: SKSpriteNode!
  private var coinGiveAwayAi2: SKSpriteNode!
  
  public override func didMove(to view: SKView) {
    
    machineAnim = childNode(withName: "//payoffAnim") as? SKSpriteNode
    player = childNode(withName: "//player") as? SKSpriteNode
    player1 = childNode(withName: "//player1") as? SKSpriteNode
    coin = childNode(withName: "//coin") as? SKSpriteNode
    coin1 = childNode(withName: "//coin1") as? SKSpriteNode
    coinGiveAway = childNode(withName: "//coinPlayMachine") as? SKSpriteNode
    coinGiveAway1 = childNode(withName: "//coinPlayMachine1") as? SKSpriteNode
    coinGiveAway2 = childNode(withName: "//coinPlayMachine2") as? SKSpriteNode
    
    coinGiveAwayAi = childNode(withName: "//coinPlayMachineAi") as? SKSpriteNode
    coinGiveAwayAi1 = childNode(withName: "//coinPlayMachineAi1") as? SKSpriteNode
    coinGiveAwayAi2 = childNode(withName: "//coinPlayMachineAi2") as? SKSpriteNode
    
    youCheatLabel = childNode(withName: "//youCheat") as? SKLabelNode
    youCooperateLabel = childNode(withName: "//youCooperate") as? SKLabelNode
    theyCheatLabel = childNode(withName: "//theyCheat") as? SKLabelNode
    theyCooperateLabel = childNode(withName: "//theyCooperate") as? SKLabelNode
    
    playerMood = .normal
    player1Mood = .sad
    setPlayerMode(currentPlayer : player, playerMood : .normal, image: "player")
    setPlayerMode(currentPlayer : player1, playerMood : .sad, image: "player")
    
    addButtons()
    startMachine()
    
    self.changeColorLabel(colorLabel1: self.youCooperateLabel, colorLabel2: self.theyCooperateLabel , changeColor: self.getYellow())
    changeColorLabel2(colorLabel1: self.youCooperateLabel, changeColor: UIColor.red)
  }
  
  func changeColorLabel2(colorLabel1: SKLabelNode, changeColor : UIColor) {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let newString = NSMutableAttributedString(string: colorLabel1.attributedText!.string, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
    newString.addAttribute(NSAttributedStringKey.foregroundColor, value: changeColor , range: NSMakeRange(0,colorLabel1.attributedText!.length))
    newString.addAttribute( NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!, range: NSMakeRange(0,colorLabel1.attributedText!.length))
    colorLabel1.attributedText = newString
    
  }
  
  func setPlayerMode(currentPlayer : SKSpriteNode, playerMood : PlayerMood, image: String) {
    var texture1 = [SKTexture]()
    var texture2 = [SKTexture]()
    currentPlayer.removeAllActions()
    switch playerMood {
    case .normal:
      currentPlayer.texture = SKTexture(imageNamed: image + "0.png")
      texture1 = [SKTexture(imageNamed: image + "0.png"),
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
      texture1 = [SKTexture(imageNamed: image + "8.png"),
                  SKTexture(imageNamed: image + "9.png"),
                  SKTexture(imageNamed: image + "8.png")]
      
      texture2 = [SKTexture(imageNamed: image + "8.png"),
                  SKTexture(imageNamed: image + "9.png"),
                  SKTexture(imageNamed: image + "8.png"),
                  SKTexture(imageNamed: image + "9.png"),
                  SKTexture(imageNamed: image + "8.png")]
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
    allCooperate.setButtonType(buttonType: .allCooperate)
    
    cooperateCheat = Button()
    cooperateCheat.position = CGPoint(x: 661.484 , y: 208.675)
    cooperateCheat.delegate = self
    addChild(cooperateCheat)
    cooperateCheat.addTextNode(text: "Cooperate - Cheat")
    cooperateCheat.setButtonType(buttonType: .cooperateCheat)
    
    cheatCooperate = Button()
    cheatCooperate.position = CGPoint(x: 349.01 , y: 97.728)
    cheatCooperate.delegate = self
    addChild(cheatCooperate)
    cheatCooperate.addTextNode(text: "Cheat - Cooperate")
    cheatCooperate.setButtonType(buttonType: .cheatCooperate)
    
    allCheat = Button()
    allCheat.position = CGPoint(x: 661.484 , y: 97.728)
    allCheat.delegate = self
    addChild(allCheat)
    allCheat.addTextNode(text: "All Cheat")
    allCheat.setButtonType(buttonType: .allCheat)
    
  }
  
  func changeColorLabel(colorLabel1: SKLabelNode, colorLabel2: SKLabelNode, changeColor : UIColor) {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    
    let newString = NSMutableAttributedString(string: colorLabel1.attributedText!.string, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
    newString.addAttribute(NSAttributedStringKey.foregroundColor, value: changeColor , range: NSMakeRange(0,colorLabel1.attributedText!.length))
    newString.addAttribute( NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!, range: NSMakeRange(0,colorLabel1.attributedText!.length))
    colorLabel1.attributedText = newString
    
    let newString1 = NSMutableAttributedString(string: colorLabel2.attributedText!.string, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
    newString1.addAttribute(NSAttributedStringKey.foregroundColor, value: changeColor , range: NSMakeRange(0,colorLabel2.attributedText!.length))
    newString1.addAttribute( NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 18.0)!, range: NSMakeRange(0,colorLabel2.attributedText!.length))
    colorLabel2.attributedText = newString1
  }
  
  func startMachine() {
    deactiveAllButton()
    machineAnim.run(SKAction.repeat(SKAction(named: "machineAnimation")! , count: 1), completion: {
      self.activateAllButton()
    })
  }
  
  
  
  func deactiveAllButton() {
    allCheat.isUserInteractionEnabled = false
    allCheat.setButtonDeactive()
    allCooperate.isUserInteractionEnabled = false
    allCooperate.setButtonDeactive()
    cheatCooperate.isUserInteractionEnabled = false
    cheatCooperate.setButtonDeactive()
    cooperateCheat.isUserInteractionEnabled = false
    cooperateCheat.setButtonDeactive()
  }
  
  func activateAllButton() {
    allCheat.isUserInteractionEnabled = true
    allCheat.setButtonNormal()
    allCooperate.isUserInteractionEnabled = true
    allCooperate.setButtonNormal()
    cheatCooperate.isUserInteractionEnabled = true
    cheatCooperate.setButtonNormal()
    cooperateCheat.isUserInteractionEnabled = true
    cooperateCheat.setButtonNormal()
  }
  
  func gamePlay(sender: Button, type: ButtonType) {
    deactiveAllButton()
    switch type {
    case .allCooperate:
      playerAnimate(player1Action: .cooperate, player2Action: .cooperate)
    case .allCheat:
      playerAnimate(player1Action: .cheat, player2Action: .cheat)
    case .cooperateCheat:
      playerAnimate(player1Action: .cooperate, player2Action: .cheat)
    case .cheatCooperate:
      playerAnimate(player1Action: .cheat, player2Action: .cooperate)
    default:
      print("Wrong Button")
    }
    
  }
  
  func playerAnimate(player1Action: PlayerAction, player2Action: PlayerAction) {
    
    if player1Action == .cooperate {
      if player2Action == .cooperate {
        playerAllCooperateAnimation()
      } else {
        playerCooperateCheatAnimation()
      }
    } else {
      if player2Action == .cooperate {
        playerCheatCooperateAnimation()
      } else {
        playerAllCheatAnimation()
      }
    }
    
  }
  
  func changePlayerTexture(currentPlayer: SKSpriteNode, texture: String) {
    currentPlayer.removeAllActions()
    currentPlayer.texture = SKTexture(imageNamed: texture)
  }
  
  func getYellow() -> UIColor {
   return UIColor(red: 255.0/255.0,green: 230.0/255.0, blue: 99.0/255.0,alpha: 1)
  }
  
  func playerAllCooperateAnimation() {
    let actionPlayer =  SKAction(named : "playerMoveJump")!
    let actionCoin = SKAction(named : "coinCooperate")!
    let actionPlayer1 = SKAction(named : "playerMoveJump1")!
    let actionCoin1 = SKAction(named : "coinCooperate1")!
    let wait = SKAction.wait(forDuration:0.1)
    let give = SKAction(named : "coinGive", duration: 0.8)!
    let giveAi = SKAction(named : "coinGive1", duration: 0.8)!
    
    let action = SKAction.run {
      self.player.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer]))
      self.coin.run(actionCoin, completion: {
        self.changePlayerTexture(currentPlayer: self.player, texture: "player10.png")
        self.machineAnim.texture = SKTexture(imageNamed: "payoff5.png")
        self.changeColorLabel(colorLabel1: self.youCooperateLabel,colorLabel2: self.theyCooperateLabel , changeColor: self.getYellow())
        let changeAction = SKAction.run {
          
          self.coinGiveAway.run(give)
          self.coinGiveAway1.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),
                                                    give]), completion: {
                                                      self.coinGiveAway.position = CGPoint(x: 323.65,y: 340.443)
                                                      self.coinGiveAway1.position = CGPoint(x: 323.65,y: 340.443)
                                                      self.setPlayerMode(currentPlayer : self.player, playerMood : .happy, image: "player")
                                                      self.player.position = CGPoint(x: 97.058,y: 391.391)
                                                      self.coin.position = CGPoint(x: 130.471,y: 319.144)
                                                      self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
                                                      self.changeColorLabel(colorLabel1: self.youCooperateLabel,colorLabel2: self.theyCooperateLabel , changeColor: UIColor.black)
                                                      self.activateAllButton()
          })
          
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
      })
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1, completion: {
        self.changePlayerTexture(currentPlayer: self.player1, texture: "player10.png")
        let changeAction = SKAction.run {
          
          self.coinGiveAwayAi.run(giveAi)
          self.coinGiveAwayAi1.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),
                                                      giveAi]), completion: {
                                                        self.setPlayerMode(currentPlayer : self.player1, playerMood : .happy, image: "player")
                                                        self.player1.position = CGPoint(x: 924.971,y: 391.391)
                                                        self.coin1.position = CGPoint(x: 883.623,y: 319.208)
                                                        self.coinGiveAwayAi.position = CGPoint(x: 700.995,y: 340.443)
                                                        self.coinGiveAwayAi1.position = CGPoint(x: 700.995,y: 340.443)
          })
          
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction]))
      })
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func playerAllCheatAnimation() {
    let actionPlayer =  SKAction(named : "playerMoveJump")!
    let actionCoin = SKAction(named : "coinCheat")!
    let actionPlayer1 = SKAction(named : "playerMoveJump1")!
    let actionCoin1 = SKAction(named : "coinCheat1")!
    let wait = SKAction.wait(forDuration:0.1)
    
    let action = SKAction.run {
      self.player.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer]))
      self.coin.run(actionCoin, completion: {
        self.changePlayerTexture(currentPlayer: self.player, texture: "player11.png")
        self.machineAnim.texture = SKTexture(imageNamed: "payoff8.png")
//        self.changeColorLabel(colorLabel1: self.youCheatLabel, colorLabel2: self.theyCheatLabel , changeColor: self.getYellow())
        self.player.run(SKAction.playSoundFileNamed("fart.mp3", waitForCompletion: false))
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player, playerMood : .angry, image: "player")
          self.player.position = CGPoint(x: 97.058,y: 391.391)
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
        self.coin.run(SKAction.sequence([actionPlayer1,
                                         SKAction.group([SKAction.moveBy(x: -40.0,y: -90.0,duration: 0.25),
                                                         SKAction.sequence([SKAction.wait(forDuration:0.18),
                                                                            SKAction.fadeOut(withDuration:0.1)])
                                          ])
          ]), completion: {
            self.coin.position = CGPoint(x: 130.471,y: 319.144)
            self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
//            self.changeColorLabel(colorLabel1: self.youCheatLabel,colorLabel2: self.theyCheatLabel , changeColor: UIColor.black)
            self.activateAllButton()
        })
      })
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1, completion: {
        self.changePlayerTexture(currentPlayer: self.player1, texture: "player11.png")
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player1, playerMood : .angry, image: "player")
          self.player1.position = CGPoint(x: 924.971,y: 391.391)
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction]))
        self.coin1.run(SKAction.sequence([actionPlayer,
                                          SKAction.group([SKAction.moveBy(x: 40.0,y: -90.0,duration: 0.25),
                                                          SKAction.sequence([SKAction.wait(forDuration:0.18),
                                                                             SKAction.fadeOut(withDuration:0.1)])
                                            ])
          ]), completion: {
            self.coin1.position = CGPoint(x: 883.623,y: 319.208)
            
        })
      })
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func playerCooperateCheatAnimation() {
    let actionPlayer =  SKAction(named : "playerMoveJump")!
    let actionPlayer1 = SKAction(named : "playerMoveJump1")!
    let actionCoin1Cheat = SKAction(named : "coinCheat1")!
    let actionCoinCooperate = SKAction(named : "coinCooperate")!
    let wait = SKAction.wait(forDuration:0.1)
    let giveAi = SKAction(named : "coinGive1", duration: 0.8)!
    
    let action = SKAction.run {
      self.player.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer]))
      self.coin.run(actionCoinCooperate, completion: {
        self.changePlayerTexture(currentPlayer: self.player, texture: "player12.png")
        self.machineAnim.texture = SKTexture(imageNamed: "payoff7.png")
//        self.changeColorLabel(colorLabel1: self.youCooperateLabel,colorLabel2: self.theyCheatLabel , changeColor: self.getYellow())
        self.player.run(SKAction.playSoundFileNamed("evil_laugh.mp3", waitForCompletion: false))
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player, playerMood : .sad, image: "player")
          self.player.position = CGPoint(x: 97.058,y: 391.391)
          self.coin.position = CGPoint(x: 130.471,y: 319.144)
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
        self.changePlayerTexture(currentPlayer: self.player1, texture: "player13.png")
        let changeAction1 = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player1, playerMood : .swag, image: "player")
          self.player1.position = CGPoint(x: 924.971,y: 391.391)
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction1]))
        self.coin1.run(SKAction.sequence([actionPlayer,
                                          SKAction.group([SKAction.moveBy(x: 40.0,y: -90.0,duration: 0.25),
                                                          SKAction.sequence([SKAction.wait(forDuration:0.18),
                                                                             SKAction.fadeOut(withDuration:0.1)])
                                            ])
          ]), completion: {
            
            
            self.coinGiveAwayAi.run(giveAi)
            self.coinGiveAwayAi1.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),giveAi]))
            self.coinGiveAwayAi2.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                        giveAi]), completion: {
                                                          self.coinGiveAwayAi.position = CGPoint(x: 700.995,y: 340.443)
                                                          self.coinGiveAwayAi1.position = CGPoint(x: 700.995,y: 340.443)
                                                          self.coinGiveAwayAi2.position = CGPoint(x: 700.995,y: 340.443)
                                                          self.coin1.position = CGPoint(x: 883.623,y: 319.208)
                                                          self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
//                                                          self.changeColorLabel(colorLabel1: self.youCooperateLabel,colorLabel2: self.theyCheatLabel , changeColor: UIColor.black)
                                                          self.activateAllButton()
            })
            
        })
      })
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1Cheat)
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func playerCheatCooperateAnimation() {
    let actionPlayer =  SKAction(named : "playerMoveJump")!
    let actionCoinCheat = SKAction(named : "coinCheat")!
    let actionPlayer1 = SKAction(named : "playerMoveJump1")!
    let actionCoin1Cooperate = SKAction(named : "coinCooperate1")!
    let wait = SKAction.wait(forDuration:0.1)
    let give = SKAction(named : "coinGive", duration: 0.8)!
    
    let action = SKAction.run {
      self.player.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer]))
      self.coin.run(actionCoinCheat)
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1Cooperate, completion: {
        self.run(SKAction.playSoundFileNamed("evil_laugh.mp3", waitForCompletion: false))
        self.changePlayerTexture(currentPlayer: self.player, texture: "player13.png")
        self.machineAnim.texture = SKTexture(imageNamed: "payoff6.png")
//        self.changeColorLabel(colorLabel1: self.youCheatLabel,colorLabel2: self.theyCooperateLabel , changeColor: self.getYellow())
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player, playerMood : .swag, image: "player")
          self.player.position = CGPoint(x: 97.058,y: 391.391)
          
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
        self.coin.run(SKAction.sequence([actionPlayer1,
                                         SKAction.group([SKAction.moveBy(x: -40.0,y: -90.0,duration: 0.25),
                                                         SKAction.sequence([SKAction.wait(forDuration:0.18),
                                                                            SKAction.fadeOut(withDuration:0.1)])
                                          ])
          ]), completion: {
            
            self.coinGiveAway.run(give)
            self.coinGiveAway1.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),give]))
            self.coinGiveAway2.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                      give]), completion: {
                                                        self.coinGiveAway.position = CGPoint(x: 323.65,y: 340.443)
                                                        self.coinGiveAway1.position = CGPoint(x: 323.65,y: 340.443)
                                                        self.coinGiveAway2.position = CGPoint(x: 323.65,y: 340.443)
                                                        self.coin.position = CGPoint(x: 130.471,y: 319.144)
                                                        self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
//                                                        self.changeColorLabel(colorLabel1: self.youCheatLabel,colorLabel2: self.theyCooperateLabel , changeColor: UIColor.black)
                                                        self.activateAllButton()
            })
        })
        
        self.changePlayerTexture(currentPlayer: self.player1, texture: "player12.png")
        let changeAction1 = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player1, playerMood : .sad, image: "player")
          self.player1.position = CGPoint(x: 924.971,y: 391.391)
          self.coin1.position = CGPoint(x: 883.623,y: 319.208)
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction1]))
      })
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  
}

extension GameScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonType) {
    sender.setButtonDeactive()
    gamePlay(sender: sender, type: type)
  }
}
