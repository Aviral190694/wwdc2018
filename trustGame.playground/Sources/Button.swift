import Foundation
import SpriteKit


// MARK: Play Button Delegate

protocol ButtonDelegate: class {
  func didTap(sender: Button, type: ButtonTypes)
}

public class Button: SKSpriteNode {
  
  // MARK: Properties
  
  weak var delegate: ButtonDelegate?
  private var type: ButtonTypes!
  var textNode: SKLabelNode!
  
  // MARK: Lifecycle
  
  init() {
    let texture = SKTexture(imageNamed: "buttonNormal.png")

    let color = SKColor.clear
    let size = CGSize(width: 250, height: 60)
    super.init(texture: texture, color: color, size: size)
//
    isUserInteractionEnabled = true
    zPosition = 1
    type = .allCooperate
  }
  
  func addTextNode(text: String) {
    textNode = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    textNode.text = text
    textNode.zPosition = 2
    textNode.fontSize = 24
    textNode.fontColor = SKColor.black
    textNode.position = CGPoint(x: 0 , y: -10)
    addChild(textNode)
  }
  
  func setButtonType(buttonType : ButtonTypes) {
    type = buttonType
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Touch Handling
  
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
  
  // MARK: Helper Functions
  
  func performButtonAppearanceResetAnimation() {
    let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
    alphaAction.timingMode = .easeInEaseOut
    self.texture = SKTexture(imageNamed: "buttonNormal.png")
    run(alphaAction)
  }
  
}




