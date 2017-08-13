//
//  Board.swift
//  Sudoku
//
//  Created by Steven Abreu on 09.05.17.
//  Copyright © 2017 stevenabreu. All rights reserved.
//

import Foundation

enum Difficulty {
    case easy
    case medium
    case hard
}

class Board {
    
    enum Correctness {
        case correct
        case incorrect
        case notset
    }
    
    
    var fields: [[Int]]
    var correct: [[Correctness]]
    var changeable: [[Bool]]
    
    init() {
        self.fields = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.correct = Array(repeating: Array(repeating: .notset, count: 9), count: 9)
        self.changeable = Array(repeating: Array(repeating: true, count: 9), count: 9)
    }
    
    init(board: String) {
        self.fields = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        self.correct = Array(repeating: Array(repeating: .notset, count: 9), count: 9)
        self.changeable = Array(repeating: Array(repeating: true, count: 9), count: 9)
        self.parseBoard(board: board)
    }
    
//    init(_ random: Bool=false) {
//        self.fields = Array(repeating: Array(repeating: 0, count: 9), count: 9)
//        self.correct = Array(repeating: Array(repeating: .notset, count: 9), count: 9)
//        self.changeable = Array(repeating: Array(repeating: true, count: 9), count: 9)
//        self.fields = self.search(self.fields) ?? Array(repeating: Array(repeating: 0, count: 9), count: 9)
//    }
    
    convenience init(_ difficulty: Difficulty) {
        let cs = CreationService()
        self.init(board: cs.getBoard(difficulty))
    }
    
    func getField(i: Int, j: Int) -> Int {
        return self.fields[i][j]
    }
    
    func moveCorrectness(row: Int, col: Int, number: Int) -> Correctness {
        // returns whether the move is correct, incorrect or not determined
        // check row.
        for i in 0...8 {
            if self.fields[row][i] == number {
                return .incorrect
            }
        }
        // check col.
        for i in 0...8 {
            if self.fields[i][col] == number {
                return .incorrect
            }
        }
        // check square.
        let topLeftX = Int(row / 3) * 3
        let topLeftY = Int(col / 3) * 3
        for i in 0...2 {
            for j in 0...2 {
                if self.fields[topLeftX+i][topLeftY+j] == number {
                    return .incorrect
                }
            }
        }
        return .correct
    }
    
    func makeMove(i: Int, j: Int, number: Int) -> Bool {
        if i < 0 || i > 8 || j < 0 || j > 8 || number < 1 || number > 9 {
            // if invalid, don't make move
            return false
        } else if !self.changeable[i][j] {
            // if field is not changeable, don't make move
            return false
        } else if self.fields[i][j] == number {
            // don't allow making the same move again
            return false
        }else {
            // save if correct and then make move.
            let c = self.moveCorrectness(row: i, col: j, number: number)
            self.correct[i][j] = c
            self.fields[i][j] = number
            return true
        }
    }
    
    func isFull() -> Bool {
        for i in 0...8 {
            for j in 0...8 {
                if self.fields[i][j] == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func isSolved() -> Bool {
        if self.isFull() {
            for i in 0...8 {
                for j in 0...8 {
                    if self.correct[i][j] == .incorrect {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func parseBoard(board: String) {
        var i = 0
        for char in board.characters {
            if let number = Int(String(char)) {
                let result = self.makeMove(i: i / 9, j: i % 9, number: number)
                self.changeable[i/9][i%9] = !result
            }
            i += 1
        }
    }
    
    func solved() {
        for i in 0...8 {
            for j in 0...8 {
                self.correct[i][j] = .correct
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////SOLVING ALGORITHM///////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////
    
    func solution(_ fields: [[Int]]) -> Bool {
        for i in 0...8 {
            for j in 0...8 {
                if fields[i][j] == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func correctMove(_ fields: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        // check row.
        for i in 0...8 {
            if fields[row][i] == num {
                return false
            }
        }
        // check col.
        for i in 0...8 {
            if fields[i][col] == num {
                return false
            }
        }
        // check square.
        let topLeftX = Int(row / 3) * 3
        let topLeftY = Int(col / 3) * 3
        for i in 0...2 {
            for j in 0...2 {
                if fields[topLeftX+i][topLeftY+j] == num {
                    return false
                }
            }
        }
        // all good -> correct move
        return true
    }
    
    func choices(_ fields: [[Int]], _ row: Int, _ col: Int) -> [Int] {
        var possibleMoves = [Int]()
        for pos in 1...9 {
            if correctMove(fields, row, col, pos) {
                possibleMoves.append(pos)
            }
        }
        // randomize choices before returning them
        for i in 0..<(possibleMoves.count) {
            for j in i+1..<(possibleMoves.count) {
                if (arc4random() < arc4random()) {
                    let helper = possibleMoves[j]
                    possibleMoves[j] = possibleMoves[i]
                    possibleMoves[i] = helper
                }
            }
        }
        return possibleMoves
    }
    
    func search(_ fields: [[Int]]) -> [[Int]]? {
        if solution(fields) {
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
            for choice in choices(fields, freeX, freeY) {
                fieldz[freeX][freeY] = choice
                let x = search(fieldz)
                if x != nil {
                    return x
                }
                fieldz[freeX][freeY] = 0
            }
            return nil
        }
    }
    
    func solve() -> [[Int]]? {
        return search(self.fields)
    }
}
