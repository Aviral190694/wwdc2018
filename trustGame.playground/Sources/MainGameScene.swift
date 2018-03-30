import Foundation

import Foundation
import SpriteKit
import UIKit
import GameKit

public class MainGameScene: SKScene {
  
  private var label: SKLabelNode!
  private var spinnyNode: SKShapeNode!
  private var machineAnim: SKSpriteNode!
  private var player: SKSpriteNode!
  private var player1: SKSpriteNode!
  private var coin: SKSpriteNode!
  private var coin1: SKSpriteNode!
  
  private var cooperateButton: Button!
  private var cheatButton: Button!
  
  private var youCheatLabel: SKLabelNode!
  private var youCooperateLabel: SKLabelNode!
  private var theyCooperateLabel: SKLabelNode!
  private var theyCheatLabel: SKLabelNode!
  private var scoreLabelPlayer: SKLabelNode!
  private var scoreLabelAi: SKLabelNode!
  private var opponentCountLabel: SKLabelNode!
  private var totalScoreLabel: SKLabelNode!
  
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
  
  private var isExtraTextHidden = false
  
  private var currentPlayerScore = 0 {
    didSet {
      scoreLabelPlayer.text = "\(currentPlayerScore)"
    }
  }
  
  private var currentAiScore = 0 {
    didSet {
      scoreLabelAi.text = "\(currentAiScore)"
    }
  }
  
  private var totalScore = 0 {
    didSet {
      totalScoreLabel.text = "Your total score : \(totalScore)"
    }
  }
  
  
  private var playerOrder: [(type: PlayerType, round: Int, imageName: String)] = [(type: .copycat, round: 5, imageName : "copycat"),
                                           (type: .allDefect, round: 4, imageName : "cheat"),
                                           (type: .allCooperate, round: 4, imageName : "cooperate"),
                                           (type: .grudges, round: 5, imageName : "grudge"),
                                           (type: .prober, round: 7, imageName : "detective")]
  
  var currentRound = 0 
  
  var currentPlayer = 0 {
    didSet {
      opponentCountLabel.text = "opponent: \(currentPlayer + 1) of 5"
    }
  }
  var lastMove : PlayerAction = .cooperate
  var everCheated = false
  var proberMoves: [PlayerAction] = [.cooperate, .cheat, .cooperate , .cooperate]
  
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
    
    scoreLabelPlayer = childNode(withName: "//scoreLabelPlayer") as? SKLabelNode
    scoreLabelAi = childNode(withName: "//scoreLabelAi") as? SKLabelNode
    opponentCountLabel = childNode(withName: "//oppnentLabel") as? SKLabelNode
    totalScoreLabel = childNode(withName: "//totalScoreLabel") as? SKLabelNode
    
    playerMood = .normal
    player1Mood = .normal
    setPlayerMode(currentPlayer : player, playerMood : .normal, image: "player")
    setPlayerMode(currentPlayer : player1, playerMood : .normal, image: "copycat")
    
    addButtons()
    startMachine()
  }
  
   func addButtons() {
    cooperateButton = Button()
    cooperateButton.position = CGPoint(x: 349.01 , y: 97.728)
    cooperateButton.delegate = self
    addChild(cooperateButton)
    cooperateButton.addTextNode(text: "Cooperate")
    cooperateButton.setButtonType(buttonType: .cooperate)
    
    cheatButton = Button()
    cheatButton.position = CGPoint(x: 661.484 , y: 97.728)
    cheatButton.delegate = self
    addChild(cheatButton)
    cheatButton.addTextNode(text: "Cheat")
    cheatButton.setButtonType(buttonType: .cheat)
  }
  
  func startMachine() {
    deactiveAllButton()
    machineAnim.run(SKAction.repeat(SKAction(named: "machineAnimation")! , count: 1), completion: {
      self.activateAllButton()
    })
  }
  
  func gamePlay(sender: Button, type: ButtonType) {
    hideArrowAndLabel()
    deactiveAllButton()
    currentRound += 1
    switch type {
    case .cooperate:
      let playerAction2 = getPlayerStrategy(type : playerOrder[currentPlayer].type, playerAction: .cooperate)
      playerAnimate(player1Action: .cooperate, player2Action: playerAction2, imageName: playerOrder[currentPlayer].imageName)
    case .cheat:
      let playerAction2 = getPlayerStrategy(type : playerOrder[currentPlayer].type, playerAction: .cheat)
      playerAnimate(player1Action: .cheat, player2Action: playerAction2, imageName: playerOrder[currentPlayer].imageName)
    default:
      print("Wrong Button")
    }
  }
  
  func getPlayerStrategy(type: PlayerType, playerAction: PlayerAction) -> PlayerAction {
    switch type {
    case .allCooperate :
      return .cooperate
    case .allDefect :
      return .cheat
    case .copycat :
      let move = lastMove
      lastMove = playerAction
      return move
    case .grudges:
      let cheated = everCheated
      if playerAction == .cheat {
        everCheated = true
      }
      
      if (cheated) {
        return .cheat
      } else {
        return .cooperate
      }
    case .prober:
      let cheated = everCheated
      if playerAction == .cheat {
        everCheated = true
      }
      
      if (proberMoves.count > 0) {
        let move = proberMoves[0]
        proberMoves.remove(at: 0)
        return move
      }
      
      if (!cheated) {
        return .cheat
      } else {
        return lastMove
      }
    }
  }
  
  func resetAnimationAI() {
    
    self.deactiveAllButton()
    self.everCheated = false
    self.lastMove = .cooperate
    self.currentAiScore = 0
    self.currentPlayerScore = 0
    if self.currentPlayer == 5 {
      let gameScene = ResultScene(fileNamed: "result")!
      let transition = SKTransition.flipVertical(withDuration: 1.0)
      gameScene.score = totalScore
      gameScene.scaleMode = .aspectFill
      view?.presentScene(gameScene, transition: transition)
    } else {
      
      let action1 = SKAction.run {
        self.setPlayerMode(currentPlayer : self.player1, playerMood : .normal, image: self.playerOrder[self.currentPlayer].imageName)
        self.player1.alpha = 1
        self.activateAllButton()
      }
      let action2 = SKAction.run {
        self.setPlayerMode(currentPlayer : self.player, playerMood : .normal, image: "player")
        self.player.alpha = 1
      }
      self.player1.run(SKAction.sequence([SKAction.fadeOut(withDuration : 0.5),SKAction.wait(forDuration: 0.5), action1]))
      self.player.run(SKAction.sequence([SKAction.fadeOut(withDuration : 0.5),SKAction.wait(forDuration: 0.5),action2]))
      
    }
   }
  
  func setPlayerMode(currentPlayer : SKSpriteNode, playerMood : PlayerMood, image: String) {
    var texture1 = [SKTexture]()
    var texture2 = [SKTexture]()
    currentPlayer.removeAllActions()
    setAiPosition(currentPlayer: currentPlayer, image: image)
    
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
  
  func deactiveAllButton() {
    cheatButton.isUserInteractionEnabled = false
    cheatButton.setButtonDeactive()
    cooperateButton.isUserInteractionEnabled = false
    cooperateButton.setButtonDeactive()
  }
  
  func activateAllButton() {
    cheatButton.isUserInteractionEnabled = true
    cheatButton.setButtonNormal()
    cooperateButton.isUserInteractionEnabled = true
    cooperateButton.setButtonNormal()
  }
  
  func playerAnimate(player1Action: PlayerAction, player2Action: PlayerAction, imageName: String) {
    if player1Action == .cooperate {
      if player2Action == .cooperate {
        playerAllCooperateAnimation(imageName: imageName)
      } else {
        playerCooperateCheatAnimation(imageName: imageName)
      }
    } else {
      if player2Action == .cooperate {
        playerCheatCooperateAnimation(imageName: imageName)
      } else {
        playerAllCheatAnimation(imageName: imageName)
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
  
  func playerAllCooperateAnimation(imageName: String) {
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
          self.coinGiveAway1.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),give]))
          self.coinGiveAway2.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                    give]), completion: {
                                                      self.resetCoinGiveAwayPlayerPosition()
                                                      self.setPlayerMode(currentPlayer : self.player, playerMood : .happy, image: "player")
                                                      self.setPlayerPosition()
                                                      self.setCoinPosition()
                                                      self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
                                                      self.changeColorLabel(colorLabel1: self.youCooperateLabel,colorLabel2: self.theyCooperateLabel , changeColor: UIColor.black)
                                                      self.totalScore += 2
                                                      self.currentPlayerScore += 2
                                                      self.currentAiScore += 2
                                                      self.activateAllButton()
                                                      
                                                      
          })
          
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
      })
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1, completion: {
        self.changePlayerTexture(currentPlayer: self.player1, texture: imageName + "10.png")
        let changeAction = SKAction.run {
          
          self.coinGiveAwayAi.run(giveAi)
          self.coinGiveAwayAi1.run(SKAction.sequence([SKAction.wait(forDuration: 0.25),giveAi]))
          self.coinGiveAwayAi2.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                      giveAi]), completion: {
                                                        self.setAiPosition(currentPlayer: self.player1, image: imageName)
                                                        if self.currentRound == self.playerOrder[self.currentPlayer].round {
                                                          self.currentRound = 0
                                                          self.currentPlayer += 1
                                                          self.resetAnimationAI()
                                                        } else {
                                                          self.setPlayerMode(currentPlayer : self.player1, playerMood : .happy, image: imageName)
                                                        }
                                                        
                                                        //                                                        self.player1.position = CGPoint(x: 924.971,y: 391.391)
                                                        self.setCoinAiPosition()
                                                        self.resetCoinGiveAwayPosition()
                                                        
          })
          
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction]))
      })
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func playerAllCheatAnimation(imageName: String) {
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
        self.changeColorLabel(colorLabel1: self.youCheatLabel, colorLabel2: self.theyCheatLabel , changeColor: self.getYellow())
        self.player.run(SKAction.playSoundFileNamed("fart.mp3", waitForCompletion: false))
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player, playerMood : .angry, image: "player")
          self.setPlayerPosition()
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
        self.coin.run(SKAction.sequence([actionPlayer1,
                                         SKAction.group([SKAction.moveBy(x: -40.0,y: -90.0,duration: 0.25),
                                                         SKAction.sequence([SKAction.wait(forDuration:0.18),
                                                                            SKAction.fadeOut(withDuration:0.1)])
                                          ])
          ]), completion: {
            self.setCoinPosition()
            self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
            self.changeColorLabel(colorLabel1: self.youCheatLabel, colorLabel2: self.theyCheatLabel, changeColor: UIColor.black)
            self.activateAllButton()
            if self.currentRound == self.playerOrder[self.currentPlayer].round {
              self.currentRound = 0
              self.currentPlayer += 1
              self.resetAnimationAI()
            }
        })
      })
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1, completion: {
        self.changePlayerTexture(currentPlayer: self.player1, texture: imageName + "11.png")
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player1, playerMood : .angry, image: imageName)
          self.setAiPosition(currentPlayer: self.player1, image: imageName)
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction]))
        self.coin1.run(SKAction.sequence([actionPlayer,
                                          SKAction.group([SKAction.moveBy(x: 40.0,y: -90.0,duration: 0.25),
                                                          SKAction.sequence([SKAction.wait(forDuration:0.18),
                                                                             SKAction.fadeOut(withDuration:0.1)])
                                            ])
          ]), completion: {
            self.setCoinAiPosition()
            
        })
      })
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func playerCooperateCheatAnimation(imageName: String) {
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
        self.changeColorLabel(colorLabel1: self.youCooperateLabel, colorLabel2: self.theyCheatLabel, changeColor: self.getYellow())
        self.player.run(SKAction.playSoundFileNamed("evil_laugh.mp3", waitForCompletion: false))
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player, playerMood : .sad, image: "player")
          self.setPlayerPosition()
          self.setCoinPosition()
        }
        self.player.run(SKAction.sequence([actionPlayer1,wait,changeAction]))
        self.changePlayerTexture(currentPlayer: self.player1, texture: imageName + "13.png")
        let changeAction1 = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player1, playerMood : .swag, image: imageName)
          self.setAiPosition(currentPlayer: self.player1, image: imageName)
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
                                                          self.resetCoinGiveAwayPosition()
                                                          self.setCoinAiPosition()
                                                          self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
                                                          self.changeColorLabel(colorLabel1: self.youCooperateLabel, colorLabel2: self.theyCheatLabel, changeColor: UIColor.black)
                                                          self.activateAllButton()
                                                          self.totalScore += -1
                                                          self.currentPlayerScore += -1
                                                          self.currentAiScore += 3
                                                          if self.currentRound == self.playerOrder[self.currentPlayer].round {
                                                            self.currentRound = 0
                                                            self.currentPlayer += 1
                                                            self.resetAnimationAI()
                                                          }
            })
            
        })
      })
      
      self.player1.run(SKAction.sequence([SKAction.wait(forDuration:0.25), actionPlayer1]))
      self.coin1.run(actionCoin1Cheat)
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func playerCheatCooperateAnimation(imageName: String) {
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
        self.changeColorLabel(colorLabel1: self.youCheatLabel, colorLabel2: self.theyCooperateLabel, changeColor: self.getYellow())
        let changeAction = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player, playerMood : .swag, image: "player")
          self.setPlayerPosition()
          
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
                                                        self.resetCoinGiveAwayPlayerPosition()
                                                        self.setCoinPosition()
                                                        self.machineAnim.texture = SKTexture(imageNamed: "payoff4.png")
                                                        self.changeColorLabel(colorLabel1: self.youCheatLabel, colorLabel2: self.theyCooperateLabel, changeColor: UIColor.black)
                                                        self.activateAllButton()
                                                        self.totalScore += 3
                                                        self.currentPlayerScore += 3
                                                        self.currentAiScore += -1
                                                        if self.currentRound == self.playerOrder[self.currentPlayer].round {
                                                          self.currentRound = 0
                                                          self.currentPlayer += 1
                                                          self.resetAnimationAI()
                                                        }
            })
        })
        
        self.changePlayerTexture(currentPlayer: self.player1, texture: imageName + "12.png")
        let changeAction1 = SKAction.run {
          self.setPlayerMode(currentPlayer : self.player1, playerMood : .sad, image: imageName)
          self.setAiPosition(currentPlayer: self.player1, image: imageName)
          self.setCoinAiPosition()
        }
        self.player1.run(SKAction.sequence([actionPlayer,wait,changeAction1]))
      })
      
    }
    run(SKAction.sequence([wait, action]))
  }
  
  func setAiPosition(currentPlayer: SKSpriteNode, image: String) {
    if image == "detective" {
      currentPlayer.position = CGPoint(x: 921.664 ,y: 293.834)
      currentPlayer.size = CGSize(width: 100, height: 180)
    } else if image == "cheat" {
      currentPlayer.position = CGPoint(x: 921.664 ,y: 301.834)
      currentPlayer.size = CGSize(width: 190, height: 190)
    } else if image == "cooperate" {
      currentPlayer.position = CGPoint(x: 921.664 ,y: 298.834)
      currentPlayer.size = CGSize(width: 130, height: 190)
    } else if image == "grudge" {
      currentPlayer.position = CGPoint(x: 921.664 ,y: 298.834)
      currentPlayer.size = CGSize(width: 100, height: 190)
    } else if image == "copycat" {
      currentPlayer.position = CGPoint(x: 921.664 ,y: 309.834)
      currentPlayer.size = CGSize(width: 100, height: 215)
    }
  }
  
  func setPlayerPosition() {
    player.position = CGPoint(x: 97.503,y: 298.712)
  }
  
  func resetCoinGiveAwayPosition() {
    let position = CGPoint(x: 701.439,y: 242.764)
    self.coinGiveAwayAi.position = position
    self.coinGiveAwayAi1.position = position
    self.coinGiveAwayAi2.position = position
  }
  
  func resetCoinGiveAwayPlayerPosition() {
    let position = CGPoint(x: 324.095,y: 242.764)
    self.coinGiveAway.position = position
    self.coinGiveAway1.position = position
    self.coinGiveAway2.position = position
  }
  
  func setCoinAiPosition() {
    coin1.position = CGPoint(x: 884.067,y: 221.529)
  }
  
  func setCoinPosition() {
    coin.position = CGPoint(x: 130.915, y: 221.529)
  }
  
  func hideArrowAndLabel() {
    if !isExtraTextHidden {
      isExtraTextHidden = true
      
      let you = childNode(withName: "//youLabel") as! SKLabelNode
      let otherPlayer = childNode(withName: "//otherPlayer") as! SKLabelNode
      let machineText = childNode(withName: "//machineText") as! SKLabelNode
//
      let arrowYou = childNode(withName: "//ArrowYou") as! SKSpriteNode
      let machineArrow = childNode(withName: "//ArrowMachine") as! SKSpriteNode
      let arrowOtherPlayer = childNode(withName: "//ArrowOtherPlayer") as! SKSpriteNode
//
      you.isHidden = true
      otherPlayer.isHidden = true
      machineText.isHidden = true
      arrowYou.isHidden = true
      machineArrow.isHidden = true
      arrowOtherPlayer.isHidden = true
    }
  }
  
}

extension MainGameScene: ButtonDelegate {
  func didTap(sender: Button, type: ButtonType) {
    sender.setButtonDeactive()
    gamePlay(sender: sender, type: type)
  }
}
