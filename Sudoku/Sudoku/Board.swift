//
//  Board.swift
//  Sudoku
//
//  Created by Steven Abreu on 09.05.17.
//  Copyright © 2017 stevenabreu. All rights reserved.
//

import Foundation

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
            if c == .incorrect {
                print("incorrect move")
            }
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
                if !result {
                    print("incorrect:", i/9, i%9)
                }
            }
            i += 1
        }
    }
}
