//
//  GameViewController.swift
//  No Poop No Life
//
//  Created by wenlong qiu on 8/4/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate{

    
    @IBOutlet var bannerView: GADBannerView!
    //var bannerView : GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        //bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        
        //self.view.addSubview(bannerView)
        bannerView.adUnitID = "ca-app-pub-4899697066667270/1539318048"
        bannerView.rootViewController = self
        bannerView.tag = 100
        bannerView.load(GADRequest())
        bannerView.isHidden = true
        //bannerView.delegate = self
        
//        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
//        addBannerView(bannerView)
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
//        bannerView.delegate = self
        
    }
//    func addBannerView(_ bannerView: GADBannerView) {
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(bannerView)
//        view.addConstraints(
//            [NSLayoutConstraint(item: bannerView,
//                                attribute: .bottom,
//                                relatedBy: .equal,
//                                toItem: view.safeAreaLayoutGuide.bottomAnchor,
//                                attribute: .top,
//                                multiplier: 1,
//                                constant: 0),
//             NSLayoutConstraint(item: bannerView,
//                                attribute: .centerX,
//                                relatedBy: .equal,
//                                toItem: view,
//                                attribute: .centerX,
//                                multiplier: 1,
//                                constant: 0)
//            ])
//    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
