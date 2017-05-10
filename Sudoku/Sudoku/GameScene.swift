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
    var shapeNodes: [[SKShapeNode]] = Array(repeating: Array(repeating: SKShapeNode(), count: 9), count: 9)
    var buttons: [SKLabelNode] = Array(repeating: SKLabelNode(), count: 9)
    var gameLabel: SKLabelNode!
    var touched = (-1,-1)
    var board: Board!
    
    override func didMove(to view: SKView) {
        setupView()
        setupBoard()
    }
    
    func setupBoard() {
        let _ = "726493815315728946489651237852147693673985124941362758194836572567214389238579461"
        let _ = "000490815315720940489651207852140090673985124941300758194806572000214389038579460"
        board = Board(board: "000000810000720040400000207000140090673000000000300700004806572000200009038570000")
        
        for i in 0...8 {
            for j in 0...8 {
                let num = board.getField(i: i, j: j)
                textNodes[i][j].text = (num == 0) ? " " : String(num)
            }
        }
    }
    
    func setupView() {
        // general constants
        let nodeSize = CGSize(width: 0.1111 * self.size.width, height: 0.1111 * self.size.width)
        let basePosition = CGPoint(x: -0.5 * self.size.width + 0.5 * nodeSize.width, y: 0.5 * self.size.width - 0.5 * nodeSize.height)
        
        // title
        for i in 0...2 {
            let title = SKLabelNode(text: "SUDOKU")
            title.name = "titleLabel"
            title.position = CGPoint(x: Double(i) * 7.5, y: Double(0.375 * self.size.height - CGFloat(i) * 5.0))
            title.fontColor = UIColor(white: CGFloat(0.1490196078) + CGFloat(i) * 0.3, alpha: 1.0)
            title.fontSize = 160
            title.zPosition = CGFloat(10 - i)
            title.fontName = "Futura-CondensedMedium"
            self.addChild(title)
        }
        
        // game label
        gameLabel = SKLabelNode(fontNamed: "Futura-CondensedMedium")
        gameLabel.position.x = 0.0
        gameLabel.position.y = -0.35 * self.size.height
        gameLabel.fontSize = 50
        gameLabel.text = "KEEP PLAYING.."
        self.addChild(gameLabel)
        
        // background image
        let bgTexture = SKTexture(image: #imageLiteral(resourceName: "Background"))
        let background = SKSpriteNode(texture: bgTexture)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: 0, y: 0.3 * nodeSize.height)
        background.size.width = self.size.width
        background.size.height = background.size.width
        self.addChild(background)
        
        // board
        for i in 0...8 {
            for j in 0...8 {
                // shape nodes
                let shapePosition = CGPoint(x: basePosition.x + (CGFloat(j) - 0.5) * nodeSize.width, y: basePosition.y - (CGFloat(i)+0.2) * nodeSize.height)
                let shapeNode = SKShapeNode(rect: CGRect(origin: shapePosition, size: nodeSize))
                shapeNode.fillColor = UIColor.clear
                shapeNodes[i][j] = shapeNode
                self.addChild(shapeNodes[i][j])
                
                // text nodes
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
        
        // buttons on the bottom
        for i in 0...8 {
            let button = SKLabelNode(fontNamed: "Futura-CondensedMedium")
            button.position.y = -0.45 * self.size.height
            button.position.x = -0.4 * self.size.width + CGFloat(i) * 0.1 * self.size.width
            button.fontColor = UIColor.white
            button.fontSize = 70
            button.text = String(i+1)
            buttons[i] = button
            self.addChild(buttons[i])
        }
    }
    
    func checkBoard() {
        // check for win / loss / not done yet
        if self.board.isSolved() {
            print("YOU WIN!!")
        } else if self.board.isFull() {
            print("SOMETHINGS NOT RIGHT!")
        } else {
            print("KEEP GOING!")
        }
    }
    
    func selectedNode(_ i: Int, _ j: Int) {
        // selected node in board
        if self.touched != (-1,-1) {
            let (a,b) = self.touched
            self.shapeNodes[a][b].fillColor = UIColor.clear
        }
        if self.touched == (i,j) {
            self.touched = (-1,-1)
            self.shapeNodes[i][j].fillColor = UIColor.clear
        } else {
            self.touched = (i,j)
            self.shapeNodes[i][j].fillColor = UIColor.lightGray
        }
    }
    
    func pressedNumber(_ num: Int) {
        //pressed number button
        if self.touched != (-1,-1) {
            let (first, second) = self.touched
            let node = textNodes[first][second]
            // check correctness
            let incorrect = self.board.moveCorrectness(row: first, col: second, number: num) == .incorrect
            // make move
            let result = self.board.makeMove(i: first, j: second, number: num)
            // if move was valid, change the number and change the font color accordingly
            if result {
                node.text = String(num)
                if incorrect {
                    node.fontColor = UIColor.darkGray
                } else {
                    node.fontColor = UIColor.white
                }
            }
        }
    }
    
    func search(_ fields: [[Int]]) -> [[Int]]? {
        if board.solution(fields) {
            return fields
        } else {
            var fieldz = fields
            var freeX = -1
            var freeY = -1
            for i in 0...8 {
                for j in 0...8 {
                    if fields[i][j] == 0 {
                        freeX = i
                        freeY = j
                    }
                }
            }
            for choice in board.choices(fields, freeX, freeY) {
                fieldz[freeX][freeY] = choice
                self.textNodes[freeX][freeY].text = String(choice)
                let x = search(fieldz)
                if x != nil {
                    return x
                }
                fieldz[freeX][freeY] = 0
                self.textNodes[freeX][freeY].text = String(0)
            }
            return nil
        }
    }
    
    func solveGame() {
        print("solve now!")
        if let solutionBoard = search(self.board.fields) {
            self.board.fields = solutionBoard
            self.board.solved()
        } else {
            print("failed.")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchedNodes = nodes(at: t.location(in: self))
            // activate label
            for i in 0...8 {
                for j in 0...8 {
                    if touchedNodes.contains(shapeNodes[i][j]) {
                        selectedNode(i, j)
                    }
                }
            }
            // enter new number
            for i in 0...8 {
                if touchedNodes.contains(buttons[i]) {
                    pressedNumber(i+1)
                }
            }
            if touchedNodes.contains(self.childNode(withName: "titleLabel")!) {
                solveGame()
            }
        }
    }
}
