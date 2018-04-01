import Foundation
import SpriteKit

protocol RuleButtonDelegate: class {
  func didTap(sender: RuleButton, type: ButtonType)
}

public class RuleButton: SKSpriteNode {

  weak var delegate: RuleButtonDelegate?
  private var type: ButtonType!
  var textNode: SKLabelNode!
  
  init() {
    let texture = SKTexture(imageNamed: "buttonNormal.png")
    
    let color = SKColor.clear
    let size = CGSize(width: 200, height: 50)
    super.init(texture: texture, color: color, size: size)
    isUserInteractionEnabled = true
    zPosition = 1
    type = .allCooperate
  }
  
  func addTextNode(text: String) {
    textNode = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    textNode.text = text
    textNode.zPosition = 2
    textNode.fontSize = 19
    textNode.fontColor = SKColor.black
    textNode.position = CGPoint(x: 0 , y: -10)
    addChild(textNode)
  }
  
  func setButtonNormal() {
    self.texture = SKTexture(imageNamed: "buttonNormal.png")
    self.textNode.fontColor = SKColor.black
  }
  
  func setButtonDeactive() {
    self.texture = SKTexture(imageNamed: "buttonDeactivated.png")
    self.textNode.fontColor = SKColor.gray
  }
  
  func setButtonType(buttonType : ButtonType) {
    type = buttonType
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    alpha = 0.5
    let action = SKAction.playSoundFileNamed("button1.mp3", waitForCompletion: false)
    run(action)
    self.texture = SKTexture(imageNamed: "buttonDeactivated.png")
  }
  
  public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    let alphaAction = SKAction.fadeAlpha(to: 0.5, duration: 0.10)
    alphaAction.timingMode = .easeInEaseOut
    run(alphaAction)
  }
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    performButtonAppearanceResetAnimation()
    
    delegate?.didTap(sender: self, type: type)
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    performButtonAppearanceResetAnimation()
  }
  
  func performButtonAppearanceResetAnimation() {
    let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
    alphaAction.timingMode = .easeInEaseOut
    self.texture = SKTexture(imageNamed: "buttonNormal.png")
    run(alphaAction)
  }
  
}




