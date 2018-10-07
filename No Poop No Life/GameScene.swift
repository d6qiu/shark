//
//  GameScene.swift
//  No Poop No Life
//
//  Created by wenlong qiu on 8/4/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

//attributions: the jellyfish image made by vecteezy at www.vecteezy.com, the tap Icon made by Freepik from www.flaticon.com, ocean image made by pixabay but dont need attribution
//water splash sound by Hampusnoren at https://freesound.org/s/147182/ had cut
//electrocted man sound by balloonhead at www.freesound.org //no attributon required
//ding sound by InspectorJ at https://freesound.org/s/411088/, had cut
//down arrow Icon made by Pixel perfect from www.flaticon.com
//Emerald by Freepik from wwww.flaticon.com, also www.freepik.com
import SpriteKit
import GameplayKit
import GoogleMobileAds


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    
    let defaults = UserDefaults.standard
    //ads
    var bannerView : GADBannerView?
    
    //MARK: - UI gamescene variables
    //player's best score
    var best : Double = 0
    var troll : SKSpriteNode?
    var topBite : SKSpriteNode?
    var botBite : SKSpriteNode?
    var leftEdge : SKSpriteNode?
    var rightEdge : SKSpriteNode?
    var topEdge : SKSpriteNode?
    var botEdge : SKSpriteNode?
    //scorer
    var leftContact : SKSpriteNode?
    var rightContact : SKSpriteNode?
    var score : Double = 0
    var scoreBoard : SKLabelNode?
    
    //shark bite gameover
    var midContact : SKSpriteNode?
    
    var backGround : SKSpriteNode?
    //lights
    var lightOfDiver : SKLightNode?
    var lightOfDiver2 : SKLightNode?
    var lightOfDiver3 : SKLightNode?
    
    //jelly
    var poop : SKSpriteNode?
    var poop2 : SKSpriteNode?
    var poop3 : SKSpriteNode?
    var gem : SKSpriteNode?
    var gemColor : UIColor?
    
    var diverTexture : SKSpriteNode?
    
    //elements on the gameover board
    var gameBoard : SKSpriteNode?
    var bestScore : SKLabelNode?
    var thisScore : SKLabelNode?
    var rankScore : SKLabelNode?
    var metalRank : SKLabelNode?
    
    //ring texture
    let ringsArray : [SKTexture] = [SKTexture(imageNamed: "Saphire1"), SKTexture(imageNamed: "Ruby1"),SKTexture(imageNamed: "Gold1"),SKTexture(imageNamed: "Silver1"),SKTexture(imageNamed: "Bronze1")]
    let ringsNameArray : [String] = ["Sapphire", "Ruby", "Gold", "Silver", "Bronze"]
    var ring : SKSpriteNode?
    
    //MARK: - Category variables
    let trollCategory : UInt32 = 0x1 << 1
    let topBiteCategory : UInt32 = 0x1 << 2
    let botBiteCategory : UInt32 = 0x1 << 3
    let poopCategory : UInt32 = 0x1 << 4
    let edgeCategory : UInt32 = 0x1 << 5
    //gravity
    let gravityCategory : UInt32 = 0x1 << 6
    let reverseGravityCategory: UInt32 = 0x1 << 7
    let gemCategory: UInt32 = 0x1 << 8
    //score contact sprites on both sides
    //let scoreCategory: UInt32 = 0x1 << 8
    //when top Bite or bot Bite bitten the punish contact
    let punishCategory : UInt32 = 0x1 << 9
    let lightsOutCategory : UInt32 = 0x1 << 10
    let jellyScoreCategory : UInt32 = 0x1 << 11

    var rotateCounterClock : SKAction?

    
    //MARK: - timer variables
    var poopTimer : Timer?
    var poopDelay : Timer?
    var fireImme : Bool = false
    
    
    
    //MARK: - sounds handle variables
    let diverSound = SKAction.playSoundFileNamed("diverSplash.mp3", waitForCompletion: true)
    let buzzSound = SKAction.playSoundFileNamed("buzz.wav", waitForCompletion: true)
    let dingSound = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: true)
    let biteSound2 = SKAction.playSoundFileNamed("biteSound2.wav", waitForCompletion: true)
    
    //MARK: - animations texture handle
    //diver's animation
    let diverTexture1 = SKTexture(imageNamed: "diver")
    let diverTexture2 = SKTexture(imageNamed: "diverE")
    //one animation
    var animation = SKAction()
    //repeated electric animation
    var strike = SKAction()
    
    //jelly's animation
    let jellyTexture1 = SKTexture(imageNamed: "Jellyfish4")
    let jellyTextureFliped1 = SKTexture(imageNamed: "jellyfish5")
    let jellyTexture2Fliped2 = SKTexture(imageNamed: "jellyfishFliped5")
    let jellyTextureRed = SKTexture(imageNamed: "jellyfishRed1")
    let tapTexture = SKTexture(imageNamed: "tap")
    var jellyAnimation = SKAction()
    
    //shark teeth's animation
    var sharkTopTeeth : SKSpriteNode?
    var sharkBotTeeth : SKSpriteNode?
    let topTeethTexture = SKTexture(imageNamed: "topTeeth")
    let botTeethTexture = SKTexture(imageNamed: "botTeeth")
    let topTeethBloodTexture = SKTexture(imageNamed: "topBlood")
    let botTeethBloodTexture = SKTexture(imageNamed: "botBlood")
    
    var gameOver : Bool = false
    
    var restartButton : SKSpriteNode?
    //action makes board visible when gameover
    let opacityAction = SKAction.fadeIn(withDuration: 2)
    
    //MARK: - tutorial handle variables
    var tapIcon : SKSpriteNode?
    var tapText : SKLabelNode?
    var tutorial : Bool = true
    var rightJellyPassed : Bool = false
    var leftJellyPassed : Bool = false
    //lightBox blind dodge double points
    var points : Int = 1
    var lightBox : SKSpriteNode?
    //marks whether jelly comes from right or left
    var rightJelly : Bool = false
    
    
    //after first jelly touch left edge, start beginJelly
    var firstJellyPassed : Bool = false
    
    //fix gem multitouch bug
    var gemTouched = false
    
    //record troll's zrotation
    var trollRotation : CGFloat = 0
    
    //distancefactor of gaps between jellyfishes
    var disMultiplier : CGFloat = 2.9
    
    
    //saved position array
    var positionArray : [CGPoint]?
    
    //bool first single jellyfish
    var firstSingleJelly : Bool = true
    
    
    
    //MARK: - game startup methods
    override func didMove(to view: SKView) {
        UIScreen.main.brightness = 0.66
        physicsWorld.contactDelegate = self
        setUpGame()
        positionArray = [topBite?.position, botBite?.position, leftEdge?.position, rightEdge?.position] as? [CGPoint]
        //bannerView = self.view?.viewWithTag(100) as? GADBannerView
        bannerView = view.viewWithTag(100) as? GADBannerView
        bannerView?.isHidden = true
    }

    
    func setUpGame() {
        //scuba diver animation setup
        animation = SKAction.animate(with: [diverTexture2, diverTexture1], timePerFrame: 0.1)

        jellyAnimation = SKAction.animate(with: [jellyTexture1, jellyTextureRed], timePerFrame: 0.3)

        strike = SKAction.repeat(animation, count: 3)
        best = defaults.double(forKey: "best")
        backGround = childNode(withName: "backGround") as? SKSpriteNode
        backGround?.zPosition = -1
        backGround?.lightingBitMask = 1
        backGround?.shadowCastBitMask = 0
        backGround?.shadowedBitMask = 1
        
        
        troll = childNode(withName: "troll") as? SKSpriteNode
        troll?.physicsBody?.categoryBitMask = trollCategory
        troll?.physicsBody?.contactTestBitMask = topBiteCategory | botBiteCategory | poopCategory | gemCategory
        // only dummy can exert force/effect on troll
        //topBite bouces because its not pinned, edges are pinned
        troll?.physicsBody?.collisionBitMask = 0
        troll?.color = UIColor.clear
        trollRotation = (troll?.zRotation)!
        
        diverTexture = troll?.childNode(withName: "diverTexture") as? SKSpriteNode
        
        //end of game scoreboard
        gameBoard = childNode(withName: "board") as? SKSpriteNode
        bestScore = gameBoard?.childNode(withName: "bestScore") as? SKLabelNode
        thisScore = gameBoard?.childNode(withName: "thisScore") as? SKLabelNode
        rankScore = gameBoard?.childNode(withName: "rank") as? SKLabelNode
        metalRank = gameBoard?.childNode(withName: "metalRank") as? SKLabelNode

        restartButton = childNode(withName: "restart") as? SKSpriteNode
        restartButton?.color = UIColor.clear
        ring = gameBoard?.childNode(withName: "ring") as? SKSpriteNode
        let zeroAlpha = SKAction.fadeAlpha(to: 0, duration: 0.01)
        diverTexture?.run(strike)
        gameBoard?.run(SKAction.sequence([opacityAction, zeroAlpha]))
        gameBoard?.removeAllActions()
        
        opacityZero()
        

        topBite = childNode(withName: "topBite") as? SKSpriteNode
        topBite?.color = UIColor.clear
        topBite?.physicsBody?.categoryBitMask = topBiteCategory
        topBite?.physicsBody?.contactTestBitMask = trollCategory | botBiteCategory | punishCategory
        topBite?.physicsBody?.collisionBitMask = trollCategory
        
        
        //top bite lighting
        topBite?.lightingBitMask = 1
        topBite?.shadowCastBitMask = 0
        topBite?.shadowedBitMask = 1
        
        
        botBite = childNode(withName: "botBite") as? SKSpriteNode
        botBite?.color = UIColor.clear
        botBite?.physicsBody?.categoryBitMask = botBiteCategory
        botBite?.physicsBody?.contactTestBitMask = trollCategory | topBiteCategory | punishCategory
        botBite?.physicsBody?.collisionBitMask = trollCategory
        
        
        //bot bite lighting
        botBite?.lightingBitMask = 1
        botBite?.shadowCastBitMask = 0
        botBite?.shadowedBitMask = 1
        
        sharkTopTeeth = topBite?.childNode(withName: "sharkTop") as? SKSpriteNode
        sharkBotTeeth = botBite?.childNode(withName: "sharkBot") as? SKSpriteNode

        
        //lights
        lightOfDiver = troll?.childNode(withName: "lightOfDiver") as? SKLightNode
        lightOfDiver2 = troll?.childNode(withName: "lightOfDiver2") as? SKLightNode
        lightOfDiver3 = troll?.childNode(withName: "lightOfDiver3") as? SKLightNode



        lightEnable(enable: false)
        
        
        
        leftEdge = childNode(withName: "leftEdge") as? SKSpriteNode
        leftEdge?.physicsBody?.categoryBitMask = 0
        leftEdge?.physicsBody?.contactTestBitMask = poopCategory
        leftEdge?.physicsBody?.collisionBitMask = 0
        
        
        rightEdge = childNode(withName: "rightEdge") as? SKSpriteNode
        rightEdge?.physicsBody?.categoryBitMask = edgeCategory
        rightEdge?.physicsBody?.contactTestBitMask = 0
        rightEdge?.physicsBody?.collisionBitMask = 0
        
        topEdge = childNode(withName: "topEdge") as? SKSpriteNode
        topEdge?.physicsBody?.categoryBitMask = edgeCategory
        
        botEdge = childNode(withName: "botEdge") as? SKSpriteNode
        botEdge?.physicsBody?.categoryBitMask = edgeCategory
        
        //2.7, 2.4
        //actions
        rotateCounterClock = SKAction.rotate(byAngle: CGFloat.pi / 1.8, duration: 0.28)
        
        //gravity
        let gravity = SKFieldNode.linearGravityField(withVector: vector3(0, -13.8, 0))
        gravity.categoryBitMask = gravityCategory
        addChild(gravity)
        
        let reverseGravity = SKFieldNode.linearGravityField(withVector: vector3(0, 13.8, 0))
        reverseGravity.categoryBitMask = reverseGravityCategory
        addChild(reverseGravity)
        
        topBite?.physicsBody?.fieldBitMask = gravityCategory
        botBite?.physicsBody?.fieldBitMask = reverseGravityCategory
        
        //score triger handlers
        leftContact = childNode(withName: "leftContact") as? SKSpriteNode
        leftContact?.color = UIColor.clear
       
        leftContact?.physicsBody?.categoryBitMask = lightsOutCategory | jellyScoreCategory
        leftContact?.physicsBody?.contactTestBitMask = poopCategory

        rightContact = childNode(withName: "rightContact") as? SKSpriteNode
        rightContact?.color = UIColor.clear
      
        rightContact?.physicsBody?.categoryBitMask = lightsOutCategory | jellyScoreCategory
        rightContact?.physicsBody?.contactTestBitMask = poopCategory
        
        
        //bite trigerr handler
        midContact = childNode(withName: "midContact") as? SKSpriteNode
        midContact?.color = UIColor.clear
        midContact?.physicsBody?.categoryBitMask = punishCategory
        midContact?.physicsBody?.contactTestBitMask = topBiteCategory | botBiteCategory
        midContact?.zPosition = (topBite?.zPosition)!
        
        scoreBoard = childNode(withName: "score") as? SKLabelNode
        
        scoreBoard?.text = String(score)
        scoreBoard?.zPosition = (troll?.zPosition)! - 1
        
        
        
        //tuturoial handler
        tapIcon = childNode(withName: "tapIcon") as? SKSpriteNode
        let tapWidth = tapIcon?.size.width
        let tapHeight = tapIcon?.size.height
        tapIcon!.run(SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: tapWidth!, height: tapHeight!, duration: 0.3), SKAction.resize(toWidth: tapWidth! * 0.6, height: tapHeight! * 0.6, duration: 0.3)])))
        tapText = childNode(withName: "tapText") as? SKLabelNode
        
        lightBox = troll?.childNode(withName: "lightBox") as? SKSpriteNode
        lightBox?.color = UIColor.clear
        
        initJelly()
//        if best > 15 {
//            bannerView?.isHidden = false
//        }
    }
    
    
    
    //MARK: - lighting control and scoreboard opacity control
    func opacityZero() {
        gameBoard?.alpha = 0
        bestScore?.alpha = 0
        thisScore?.alpha = 0
        rankScore?.alpha = 0
        metalRank?.alpha = 0
        ring?.alpha = 0
    }
    
    func lightEnable(enable : Bool) {
        lightOfDiver?.isEnabled = enable
        lightOfDiver2?.isEnabled = enable
        lightOfDiver3?.isEnabled = enable
    }
    
    //MARK: - Jellyfishes creation methods
    func initJelly() {
        poop = SKSpriteNode(imageNamed: "Jellyfish4")
        poop?.position = CGPoint(x: size.width * 2, y: 0)
        poop?.zPosition = (topBite?.zPosition)! + 1
        poop?.name = "poop"
        addChild(poop!)
        
        gem = SKSpriteNode(imageNamed: "emerald")
        gem?.name = "gem"
        gem?.position = CGPoint(x: size.width * 3, y: 0)
        gem?.zPosition = (topBite?.zPosition)! + 1
        addChild(gem!)
        
        poop?.physicsBody = SKPhysicsBody(rectangleOf: (poop?.size)!)
        poop?.physicsBody?.categoryBitMask = poopCategory
        poop?.physicsBody?.affectedByGravity = false
        poop?.physicsBody?.contactTestBitMask = trollCategory | jellyScoreCategory
        
        //set this to 0 if u dont want collison of poop
        //poop.physicsBody?.collisionBitMask = topBiteCategory | botBiteCategory
        poop?.physicsBody?.collisionBitMask = 0
        poop?.lightingBitMask = 1
        poop?.shadowCastBitMask = 0
        poop?.shadowedBitMask = 1
        poop?.run(SKAction.repeatForever(jellyAnimation))
        
        poop2 = SKSpriteNode(imageNamed: "Jellyfish4")
        poop2?.position = CGPoint(x: size.width * 2, y: 0)
        poop2?.zPosition = (topBite?.zPosition)! + 1
        poop2?.name = "poop"
        addChild(poop2!)
        poop2?.physicsBody = SKPhysicsBody(rectangleOf: (poop?.size)!)
        poop2?.physicsBody?.categoryBitMask = poopCategory
        poop2?.physicsBody?.affectedByGravity = false
        poop2?.physicsBody?.contactTestBitMask = trollCategory | jellyScoreCategory
        
        //set this to 0 if u dont want collison of poop
        poop2?.physicsBody?.collisionBitMask = 0
        poop2?.lightingBitMask = 1
        poop2?.shadowCastBitMask = 0
        poop2?.shadowedBitMask = 1
        
        poop2?.run(SKAction.repeatForever(jellyAnimation))
        
        poop3 = SKSpriteNode(imageNamed: "Jellyfish4")
        poop3?.position = CGPoint(x: size.width * 2, y: 0)
        poop3?.zPosition = (topBite?.zPosition)! + 1
        poop3?.name = "poop"
        addChild(poop3!)
        poop3?.physicsBody = SKPhysicsBody(rectangleOf: (poop?.size)!)
        
        poop3?.physicsBody?.categoryBitMask = poopCategory
        poop3?.physicsBody?.affectedByGravity = false
        poop3?.physicsBody?.contactTestBitMask = trollCategory | lightsOutCategory | jellyScoreCategory
        
        //set this to 0 if u dont want collison of poop
        poop3?.physicsBody?.collisionBitMask = 0
        poop3?.lightingBitMask = 1
        poop3?.shadowCastBitMask = 0
        poop3?.shadowedBitMask = 1
        
        poop3?.run(SKAction.repeatForever(jellyAnimation))
        
        gem?.physicsBody = SKPhysicsBody(rectangleOf: (gem?.size)!)
        //gem?.physicsBody?.isDynamic = true
        gem?.physicsBody?.categoryBitMask = gemCategory
        gem?.physicsBody?.affectedByGravity = false
        gem?.physicsBody?.contactTestBitMask = trollCategory
        gem?.physicsBody?.collisionBitMask = 0
    }
    
    //create jellyfishes for the rest of the game after tutorial
    func beginCreateJelly() {
        var time : Double = 4
        //2.6
        poopTimer = Timer.scheduledTimer(withTimeInterval: 3.3, repeats: true, block: { (timer) in
            if arc4random_uniform(2) == 1 {
                time = 0.05
            } else {
                time = 0
            }
            self.poopDelay = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { (timer) in
                if self.firstSingleJelly == false {
                    
                    if arc4random_uniform(2) == 1 {
                        self.createAJelly(right: false, tutorial: false)
                        self.leftJellyPassed = true
                        
                    } else {
                        self.createAJelly(right: true, tutorial: false)
                        self.rightJellyPassed = true
                        
                    }
                } else {
                    self.createTutorJelly()
                    self.firstSingleJelly = false
                }
            })
        })
        if fireImme == true {
            DispatchQueue.main.async {
                self.poopTimer?.fire()
                
            }
        } else {
            DispatchQueue.main.async {
                self.fireImme = true

            }
        }
    }

    func createTutorJelly() {
        let poopX = (size.width / 2) + ((poop?.size.width)! / 2)
        poop?.zRotation = 0
        //2.3
        let poopInBetween  = (poop?.size.width)! * 2.3
       
        let moveDis = (size.width + (poop?.size.width)! + poopInBetween + poopInBetween) * 0.93
        let iniMoveDis = moveDis / 0.93 * 0.07

        let jellyDistance = (troll?.size.height)! / 2 - (poop?.size.height)! / 2.5
        let poopY = jellyDistance

        poop?.position = CGPoint(x: poopX, y: poopY)
        //2.325 2.625
        let moveToLeft = SKAction.moveBy(x: -moveDis, y: 0, duration: 2.325)
        let moveIniLeft = SKAction.moveBy(x: -iniMoveDis, y: 0, duration: 0.6)
        poop?.run(SKAction.sequence([moveIniLeft, moveToLeft]))

    }
   

    func createAJelly(right : Bool, tutorial : Bool) {
        
        let jellyDistance = (troll?.size.height)! / 2 - (poop?.size.height)! / 2.5
        let poopInBetween  = (poop?.size.width)! * disMultiplier
        if disMultiplier > 2.4 {
            disMultiplier -= 0.2
        }
        
        let poopX = (size.width / 2) + ((poop?.size.width)! / 2)
        let poop2X = poopX + poopInBetween
        let poop3x = poop2X + poopInBetween
        let gemWidth = gem?.size.width
        let poopWidth = poop?.size.width
        let gemDis = CGFloat(arc4random_uniform(UInt32(poopInBetween - gemWidth! - poopWidth!))) + poopWidth! / 2 + gemWidth! / 2
        gem?.isHidden = false
        gem?.speed = 1
        gemTouched = false
        
        let moveDis = (size.width + (poop?.size.width)! + poopInBetween + poopInBetween) * 0.93
        let iniMoveDis = moveDis / 0.93 * 0.07
        if right == true {
            self.rightJelly = true
           
            poop?.zRotation = 0
            poop2?.zRotation = 0
            poop3?.zRotation = 0
            let poopY = jellyDistance
            poop?.position = CGPoint(x: poopX, y: poopY)
            poop2?.position = CGPoint(x: poop2X, y: poopY)
            poop3?.position = CGPoint(x: poop3x, y: poopY)
            if arc4random_uniform(2) == 1 {
                gem?.position = CGPoint(x: poopX + gemDis, y: poopY)
            } else {
                gem?.position = CGPoint(x: poop2X + gemDis, y: poopY)
            }
            //2.325
            let moveToLeft = SKAction.moveBy(x: -moveDis, y: 0, duration: 2.325)
            let moveIniLeft = SKAction.moveBy(x: -iniMoveDis, y: 0, duration: 0.6)
           
            poop?.run(SKAction.sequence([moveIniLeft, moveToLeft]))
            poop2?.run(SKAction.sequence([moveIniLeft, moveToLeft]))
            poop3?.run(SKAction.sequence([moveIniLeft, moveToLeft]))
            gem?.run(SKAction.sequence([moveIniLeft, moveToLeft]))
            
            
            
        } else {
            self.rightJelly = false
            
            
            poop?.zRotation = CGFloat.pi
            poop2?.zRotation = CGFloat.pi
            poop3?.zRotation = CGFloat.pi
            
            
            //unint 32 has to be unsigned otherwise error
            let poopY = -jellyDistance
            poop?.position = CGPoint(x: -poopX, y: poopY)
            poop2?.position = CGPoint(x: -poop2X, y: poopY)
            poop3?.position = CGPoint(x: -poop3x, y: poopY)
            
            if arc4random_uniform(2) == 1 {
                gem?.position = CGPoint(x: -(poopX + gemDis), y: poopY)
            } else {
                gem?.position = CGPoint(x: -(poop2X + gemDis), y: poopY)
            }
     
            //2.325
            let moveToRight = SKAction.moveBy(x: moveDis, y: 0, duration: 2.325)
            let moveIniRight = SKAction.moveBy(x: iniMoveDis, y: 0, duration: 0.6)
            
            
            poop?.run(SKAction.sequence([moveIniRight, moveToRight]))
            poop2?.run(SKAction.sequence([moveIniRight, moveToRight]))
            poop3?.run(SKAction.sequence([moveIniRight, moveToRight]))
            gem?.run(SKAction.sequence([moveIniRight, moveToRight]))
        }
    }

    //MARK: - game object contact responder methods
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
            //have to set boundingrectangle in gamescene to enable contact , need physcialBody of both parties!

            if contact.bodyA.node?.name == "gem" && contact.bodyB.node?.name == "troll" && gemTouched == false || contact.bodyA.node?.name == "troll" && contact.bodyB.node?.name == "gem" && gemTouched == false{
                gemTouched = true
                gem?.isHidden = true
                run(dingSound)
                score += 1.5
                scoreBoard?.text = String(score)
            }
            else if contact.bodyA.node?.name == "poop" && contact.bodyB.node?.name == "troll" || contact.bodyA.node?.name == "troll" && contact.bodyB.node?.name == "poop" {
               
                troll?.physicsBody?.angularVelocity = 0
                run(buzzSound)
                diverTexture?.run(strike)
                gameIsOver(bitten : false)
            
            }
            else if contact.bodyA.node?.name == "midContact" && contact.bodyB.node?.name == "topBite" || contact.bodyA.node?.name == "topBite" && contact.bodyB.node?.name == "midContact"{
                troll?.physicsBody?.angularVelocity = 0
                sharkTopTeeth?.texture = topTeethBloodTexture
                sharkBotTeeth?.texture = botTeethBloodTexture
                lightEnable(enable: false)
                run(biteSound2)
                gameIsOver(bitten: true)
            }
            else if contact.bodyA.node?.name == "poop" && contact.bodyB.node?.name == "leftContact" || contact.bodyB.node?.name == "poop" && contact.bodyA.node?.name == "leftContact" || contact.bodyA.node?.name == "poop" && contact.bodyB.node?.name == "rightContact" || contact.bodyB.node?.name == "poop" && contact.bodyA.node?.name == "rightContact" {
                run(dingSound)
                score += 0.5
                scoreBoard?.text = String(score)
                tapIcon?.removeFromParent()
                tapText?.removeFromParent()
                
            }

        }
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "rightContact" && contact.bodyB.node == poop3 || contact.bodyA.node == poop3 && contact.bodyB.node?.name == "rightContact" || contact.bodyA.node?.name == "leftContact" && contact.bodyB.node == poop3 || contact.bodyA.node == poop3 && contact.bodyB.node?.name == "leftContact" {
            if lightOfDiver?.isEnabled == false  && leftJellyPassed == true && rightJellyPassed == true {
                lightEnable(enable: true)
            }
        }
    }
    
    //MARK: - player taps handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
            if tutorial == true {
                troll?.run(rotateCounterClock!)
                run(diverSound)
                //-4.6, 6.6
                troll?.physicsBody?.applyAngularImpulse(-9.6)
                beginCreateJelly()
                tutorial = false
                tapText?.text = "keep taping"
            } else {
                troll?.run(rotateCounterClock!)
                run(diverSound)
                if (lightBox?.intersects(poop!))! || (lightBox?.intersects(poop2!))! || (lightBox?.intersects(poop3!))! {
                    if leftJellyPassed == true && rightJellyPassed == true {
                        lightEnable(enable: false)
                    }
                    
                }
                
            }
            
        } else {
            if let touch = touches.first {
                let location = touch.location(in: self)
                if (restartButton?.contains(location))! {
                    restart()
                }
            }
        }
        
    }
    
    
    //MARK: - gameover handle methods
    func gameIsOver(bitten : Bool) {
        bannerView?.isHidden = false
        poop?.speed = 0
        poop2?.speed = 0
        poop3?.speed = 0
        gem?.speed = 0
        if score > best {
            best = score
            defaults.set(best, forKey: "best")
        }
        //calculate rank here
//        var rank : Int = 103 - score
//        if score < 4 {
//            rank = 99
//        } else if score > 102 {
//            rank = 1
//        }
        var rank : CGFloat = 100 - CGFloat(score) * 1.49
        if score < 1 {
            rank = 99
        } else if score > 66 {
            rank = 1
        } else {
            if arc4random_uniform(2) == 1 {
                rank -= 1
            }
        }
//        var rank : CGFloat = 100 - CGFloat(score) * 2.13
//        if score < 1 {
//            rank = 99
//        } else if score > 46 {
//            rank = 1
//        } else {
//            if arc4random_uniform(2) == 1 {
//                rank -= 1
//            }
//        }
        bestScore?.text = String(best)
        thisScore?.text = String(score)
        if InternetConnection.connectedToInternet() {
            rankScore?.text = "\(Int(rank))% beats u"
            metalRank?.text = "\(ringsNameArray[Int(rank/20)])"
            ring?.texture = ringsArray[Int(rank/20)]
        } else {
            rankScore?.text = "No internet"
            metalRank?.text = "\(ringsNameArray[4])"
            ring?.texture = ringsArray[4]
        }
        let revealBoard = SKAction.fadeIn(withDuration: 1.5)
        gameBoard?.run(revealBoard)
        

        troll?.physicsBody?.angularVelocity = 0
        //invalidates timer
        poopTimer?.invalidate()
        poopDelay?.invalidate()
        

        
        //make jellyfish visible by light
        poop?.lightingBitMask = 0
        poop?.shadowCastBitMask = 0
        poop?.shadowedBitMask = 0
        poop2?.lightingBitMask = 0
        poop2?.shadowCastBitMask = 0
        poop2?.shadowedBitMask = 0

        
        //markGame is over
        gameOver = true
        if score > best {
            best = score
            defaults.set(best, forKey: "best")
        }
                
        bestScore?.alpha = 1
        thisScore?.alpha = 1
        rankScore?.alpha = 1
        metalRank?.alpha = 1
        ring?.alpha = 1
        
        ring?.zPosition = 4
        
    }
    
  
    func restart() {
        gameBoard?.removeAllActions()
        sharkTopTeeth?.texture = topTeethTexture
        sharkBotTeeth?.texture = botTeethTexture
        gameOver = false
        score = 0
        scoreBoard?.text = String(score)
        troll?.zRotation = trollRotation
        troll?.physicsBody?.angularVelocity = 0
        disMultiplier = 3.1
        topBite?.position = positionArray![0]
        botBite?.position = positionArray![1]
        leftEdge?.position = positionArray![2]
        rightEdge?.position = positionArray![3]
        poop?.removeFromParent()
        poop2?.removeFromParent()
        poop3?.removeFromParent()
        gem?.removeFromParent()
        scoreBoard?.zPosition = (troll?.zPosition)! - 1

        gemTouched = false
        
        leftJellyPassed = false
        rightJellyPassed = false
        firstSingleJelly = true
        opacityZero()

        
        initJelly()
     
        tutorial = true
        lightEnable(enable: false)
        firstJellyPassed = false
        
        bannerView?.isHidden = true
    }
    
}
