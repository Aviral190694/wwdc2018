import PlaygroundSupport
import SpriteKit

/*:
 In this playground, You will play the game to understand **Game Theory**. There are 5 different opponents whom you have to beat and win.
 
 The goal of the game is to choose weather you are going to cheat or cooperate with a player by iteratively playing with them without knowing the number of rounds.
 */
/*:
  # Game Theory
The branch of mathematics concerned with the analysis of strategies for dealing with competitive situations where the outcome of a participant's choice of action depends critically on the actions of other participants. Game theory has been applied to contexts in war, business, and biology
 */
/*:
 # Prisoner's Dilemma
  A situation in which two players each have two options whose outcome depends crucially on the simultaneous choice made by the other, often formulated in terms of two prisoners separately deciding whether to confess to a crime.
 */
/*:
 ### Rules
 
 * If both the player and the opponent cooperates : both earn **2 coins**.   ![both earn 2 coins](allCoopScoreSmall.png)
 * If player cooperates and opponent cheats : you lose **a coin** and opponent earn **3 coins**.    ![you lose a coin and opponents earn 3](coopCheatScoreSmall.png)
 * If player cheat and opponent cooperates : you earn **3 coins** and opponent lose **1 coin**.   ![you earn 3 coins and opponents lose 1](cheatCoopScoreSmall.png)
 * If both the player cheats they both earn **nothing**.   ![both earn nothing](allCheatScoreSmall.png)
 */
/*:
### Your opponents/ Strategies:
 
 * **Tit for Tat** : Hello! I start with Cooperate, and afterwards, I just copy whatever you did in the last round. Meow
 * **Always defect** : the strong shall eat the weak. Always cheat!
 * **Always Cooperate** : Let's be best friends! ❤️ Always Cooperate!
 * **Grudge** : Listen, pardner. I'll start cooperatin', and keep cooperatin', but if y'all ever cheat me, I'LL CHEAT YOU BACK 'TIL THE END OF TARNATION.
 * **Prober** : First: I analyze you. I start: Cooperate, Cheat, Cooperate, Cooperate. If you cheat back, I'll act like Copycat. If you never cheat back I'll act like Always Cheat, to exploit you. Elementary, my dear Watson.
 */


let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 560, height: 420))
if let scene = IntroScene(fileNamed: "IntroScene") {
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView



