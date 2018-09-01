//
//  Endgame.swift
//  No Poop No Life
//
//  Created by wenlong qiu on 8/13/18.
//  Copyright © 2018 wenlong qiu. All rights reserved.
//

import SpriteKit

class Endgame: SKSpriteNode {
    
    let type : Int
    
    init(type: Int, size: CGSize) {
        self.type = type
        super.init(texture: nil, color: UIColor.clear, size: size)
        setUpPopup() 
    }
    
    func setUpPopup() {
        let background = SKSpriteNode(imageNamed: "board")
        background.scale(to: CGSize(width: size.width / 3, height: size.height / 3))
    
    }
    
    func buttonHandler(index: Int) {
                
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
