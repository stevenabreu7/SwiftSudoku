//
//  GameScene.swift
//  Sudoku
//
//  Created by Steven Abreu on 09.05.17.
//  Copyright © 2017 stevenabreu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var textNodes: [[SKLabelNode]] = Array(repeating: Array(repeating: SKLabelNode(), count: 9), count: 9)
    var buttons: [SKLabelNode] = Array(repeating: SKLabelNode(), count: 9)
    var touched = (-1,-1)
    var board: Board!
    
    override func didMove(to view: SKView) {
        
        let nodeSize = CGSize(width: 0.1111 * self.size.width, height: 0.1111 * self.size.width)
        let basePosition = CGPoint(x: -0.5 * self.size.width + 0.5 * nodeSize.width, y: 0.5 * self.size.width - 0.5 * nodeSize.height)
        for i in 0...8 {
            for j in 0...8 {
                let node: SKLabelNode = SKLabelNode(fontNamed: "Futura-CondensedMedium")
                node.text = "0"
                node.fontSize = 60
                node.fontColor = UIColor.white
                node.horizontalAlignmentMode = .center
                node.position.x = basePosition.x + CGFloat(j) * nodeSize.width
                node.position.y = basePosition.y - CGFloat(i) * nodeSize.height
                textNodes[i][j] = node
                self.addChild(textNodes[i][j])
            }
        }
        for i in 0...8 {
            let button = SKLabelNode(fontNamed: "Futura-CondensedMedium")
            button.position.y = -0.4 * self.size.height
            button.position.x = -0.4 * self.size.width + CGFloat(i) * 0.1 * self.size.width
            button.fontColor = UIColor.white
            button.fontSize = 70
            button.text = String(i+1)
            buttons[i] = button
            self.addChild(buttons[i])
        }
        
        let _ = "726493815315728946489651237852147693673985124941362758194836572567214389238579461"
        board = Board(board: "000490815315720940489651207852140090673985124941300758194806572000214389038579460")
        
        for i in 0...8 {
            for j in 0...8 {
                let num = board.getField(i: i, j: j)
                textNodes[i][j].text = (num == 0) ? "-" : String(num)
            }
        }
    }
    
    func checkBoard() {
        if self.board.isSolved() {
            print("YOU WIN!!")
        } else if self.board.isFull() {
            print("SOMETHINGS NOT RIGHT!")
        } else {
            print("KEEP GOING!")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchedNodes = nodes(at: t.location(in: self))
            // activate label
            for i in 0...8 {
                for j in 0...8 {
                    if touchedNodes.contains(textNodes[i][j]) {
                        self.touched = (i,j)
                        print(i,j)
                    }
                }
            }
            // enter new number
            for i in 0...8 {
                if touchedNodes.contains(buttons[i]) {
                    if self.touched != (-1,-1) {
                        let (first, second) = self.touched
                        let node = textNodes[first][second]
                        // check correctness
                        if self.board.moveCorrectness(row: first, col: second, number: i+1) == .incorrect {
                            node.fontColor = UIColor.darkGray
                        } else {
                            node.fontColor = UIColor.white
                        }
                        // make move (or not)
                        let result = self.board.makeMove(i: first, j: second, number: i+1)
                        if result {
                            print("valid move")
                            node.text = String(i+1)
                        }
                    }
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


// old code:
//    var shapeNodes: [[SKShapeNode]] = Array(repeating: Array(repeating: SKShapeNode(), count: 9), count: 9)
//                let shapePosition = CGPoint(x: basePosition.x + CGFloat(j) * nodeSize.width, y: basePosition.y - CGFloat(i) * nodeSize.height)
//                let shapeNode = SKShapeNode(rect: CGRect(origin: shapePosition, size: nodeSize))
//                shapeNode.strokeColor = UIColor.lightGray
//                shapeNode.fillColor = UIColor.darkGray
//                shapeNodes[i][j] = shapeNode
//                self.addChild(shapeNodes[i][j])
//
//                self.shapeNodes[i][j].addChild(textNodes[i][j])
