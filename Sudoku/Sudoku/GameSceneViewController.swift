//
//  GameSceneViewController.swift
//  Sudoku
//
//  Created by Steven Abreu on 23.06.17.
//  Copyright © 2017 stevenabreu. All rights reserved.
//

import UIKit
import SpriteKit

class GameSceneViewController: UIViewController {
    
    var difficulty: Difficulty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let gameScene = SKScene(fileNamed: "GameScene") {
                let scene =  gameScene as! GameScene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.difficulty = self.difficulty
                scene.vc = self
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
