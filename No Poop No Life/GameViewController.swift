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

class GameViewController: UIViewController, GADBannerViewDelegate, UITextFieldDelegate{

    
    @IBOutlet var bannerView: GADBannerView!
    //var bannerView : GADBannerView!
    
    let name1: UITextField = {
        let textField = UITextField()
        textField.textColor = .green
        let placeHolder = NSAttributedString(string: "Name a fake friend", attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 91, green: 94, blue: 101)])
        textField.attributedPlaceholder = placeHolder
        //textField.backgroundColor = UIColor(white: 0, alpha: 0.03) //0 white means black alpha 0.03 of black gets u white grey
        textField.backgroundColor = UIColor.rgb(red: 30, green: 41, blue: 53) //dark blue
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        
        textField.addTarget(self, action: #selector(handlerTextInputChange), for: .editingChanged)
        
        return textField
    }()
    
    @objc func handlerTextInputChange() {
        let isFormValid = name1.text?.count ?? 0 > 0
        if isFormValid {
            startButton.isEnabled = true
            //startButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237) //blue
            //startButton.backgroundColor = .green
            startButton.backgroundColor = UIColor.rgb(red: 83, green: 172, blue: 102) //green
            startButton.setTitleColor(.white, for: .normal)

        } else {
            startButton.isEnabled = false
            //startButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244) //light blue
            //startButton.backgroundColor = UIColor.rgb(red: 30, green: 41, blue: 53)
            //startButton.backgroundColor = UIColor.rgb(red: 158, green: 255, blue: 152) //light green
            startButton.backgroundColor = UIColor.rgb(red: 6, green: 59, blue: 0) //dark green
            startButton.setTitleColor(UIColor.rgb(red: 91, green: 94, blue: 101), for: .normal)
            
        }
    }
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal) //select or highlihgt or normal
        //button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244) //lightblue
        button.backgroundColor = UIColor.rgb(red: 158, green: 255, blue: 152) //lightgreen
        button.backgroundColor = UIColor.rgb(red: 6, green: 59, blue: 0) //dark green
        button.layer.cornerRadius = 5 //changing to round border of button differ from changing UITextfield, layer is for animation
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.rgb(red: 91, green: 94, blue: 101), for: .normal)
        
        //button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    @objc func handleStart() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                //let poop = scene.childNode(withName: "poop")
                let name1 = scene.childNode(withName: "name1") as? SKLabelNode
                name1?.text = self.name1.text
                stackView?.removeFromSuperview()
                whiteView.removeFromSuperview()
                // Present the scene
//                bannerView.adUnitID = "ca-app-pub-4899697066667270/1539318048"
//                bannerView.rootViewController = self
//                bannerView.tag = 100
//                bannerView.load(GADRequest())
//                bannerView.isHidden = true
                view.presentScene(scene)
                
//                self.bannerView.adUnitID = "ca-app-pub-4899697066667270/1539318048"
//                self.bannerView.rootViewController = self
//                self.bannerView.tag = 100
//                self.bannerView.load(GADRequest())
//                self.bannerView.isHidden = true
            }
            
            
            
            view.ignoresSiblingOrder = true
            //shows fps label on bottom left
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    var stackView : UIStackView?
    private func setupInput() {
    
        name1.delegate = self
        stackView = UIStackView(arrangedSubviews: [name1, startButton])
        
        stackView?.axis = .vertical
        stackView?.spacing = 10
        stackView?.distribution = .fillEqually
        view.addSubview(stackView!)
        stackView?.anchor(top: nil, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 100, paddingBottom: -50, paddingRight: -100, width: 0, height: 90)
        //stackView?.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    let whiteView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 22, green: 28, blue: 37)
        //view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(whiteView)
        whiteView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        setupInput()
        
        
        
//        if let view = self.view as! SKView? {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//            //shows fps label on bottom left
//            view.showsFPS = false
//            view.showsNodeCount = false
//        }
        
        //bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
        
        //self.view.addSubview(bannerView)
        
        
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        
        bannerView.adUnitID = "ca-app-pub-4899697066667270/1539318048"
        bannerView.rootViewController = self
        bannerView.tag = 100
        bannerView.load(GADRequest())
        bannerView.isHidden = true
//
        
        
        
        
        
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
