//
//  GameViewController.swift
//  Sudoku
//
//  Created by Steven Abreu on 09.05.17.
//  Copyright © 2017 stevenabreu. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    }
    
    @IBAction func easyPressed(_ sender: Any) {
        handleButtonPress(.easy)
    }
    
    @IBAction func mediumPressed(_ sender: Any) {
        handleButtonPress(.medium)
    }
    
    @IBAction func hardPressed(_ sender: Any) {
        handleButtonPress(.hard)
    }
    
    func handleButtonPress(_ dif: Difficulty) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "GameSceneViewController") as! GameSceneViewController
        vc.difficulty = dif
        self.navigationController?.pushViewController(vc, animated: true)
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
