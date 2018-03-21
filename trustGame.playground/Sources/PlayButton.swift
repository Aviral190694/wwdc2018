import Foundation
import SpriteKit


// MARK: Play Button Delegate

protocol PlayButtonDelegate: class {
  func didTapPlay(sender: PlayButton)
}

public class PlayButton: SKSpriteNode {
  
  // MARK: Properties
  
  weak var delegate: PlayButtonDelegate?
  
  // MARK: Lifecycle
  
  init() {
    let texture = SKTexture(imageNamed: "buttonNormal.png")

    let color = SKColor.clear
    let size = CGSize(width: 320, height: 60)
    super.init(texture: texture, color: color, size: size)
//
    isUserInteractionEnabled = true
    zPosition = 1
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Touch Handling
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    alpha = 0.5
    print("Touched")
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
    
    delegate?.didTapPlay(sender: self)
  }
  
  public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    performButtonAppearanceResetAnimation()
  }
  
  // MARK: Helper Functions
  
  func performButtonAppearanceResetAnimation() {
    let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
    alphaAction.timingMode = .easeInEaseOut
    run(alphaAction)
  }
  
}




