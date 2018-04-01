//
//  MinesweeperViewController.swift
//  Minesweeper
//
//  Created by Morena Rong on 11/20/16.
//  Copyright © 2016 Morena Rong. All rights reserved.
//

import UIKit


class MinesweeperButton: UIButton {
    
    var row: Int
    var col: Int
    var isMine = false
    var revealed = false
    var mineNeighbors = 0 //-1 if a mine
    
    init(frame: CGRect, row: Int, col: Int) {
        self.row = row
        self.col = col
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MinesweeperViewController: UIViewController {
    
    
    var squares = [[MinesweeperButton]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        createNewGame()
        

        let newGameButton = UIButton(frame: CGRect(x: 0, y: 600, width: 100, height: 30))
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.setTitleColor(.red, for: .normal)
        newGameButton.center.x = view.center.x
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        view.addSubview(newGameButton)
        
        
        
    }
    
    
    func createNewGame() {
        
        //creating the squares
        for i in 0...7 {
            var row = [MinesweeperButton]()
            for j in 0...7 {
                let mineButton = MinesweeperButton(frame: CGRect(x: 10 + 50*j, y: 150 + 50*i, width: 45, height: 45), row: i, col: j)
                mineButton.addTarget(self, action: #selector(squarePressed), for: .touchUpInside)
                row.append(mineButton)
            }
            squares.append(row)
        }
        
        
        //randomly decide which ones are mines
        for i in 0...7 {
            var currentRow = squares[i]
            for j in 0...7 {
                currentRow[j].isMine = ((arc4random()%10) == 0) //any number, mod 10, has 1 in 10 chance of being == 0, so 1 in 10 chance of being true
            }
        }
        
        
        //add the squares to the view
        for rowOfSquares in squares {
            for square in rowOfSquares {
                //set the # to be revealed if its clicked
                determineMineNeighborNumber(square: square)
                square.backgroundColor = .lightGray
                view.addSubview(square)
            }
        }
    }
    
    
    func determineMineNeighborNumber(square: MinesweeperButton) {
        if square.isMine == true {
            square.mineNeighbors = -1
        }
        
        let squareNeighbors = getNeighbors(square: square)
        
        for neigh in squareNeighbors {
            if neigh.isMine == true {
                square.mineNeighbors += 1
            }
        }
        
    }
    
    func getNeighbors(square: MinesweeperButton) -> [MinesweeperButton] {
        
        var neighboringSquares = [MinesweeperButton]()
        
        if let topLeft = getSquareAt(row: square.row-1, col: square.col-1) {
            neighboringSquares.append(topLeft)
        }
        if let top = getSquareAt(row: square.row-1, col: square.col) {
            neighboringSquares.append(top)
        }
        if let topRight = getSquareAt(row: square.row-1, col: square.col+1) {
            neighboringSquares.append(topRight)
        }
        if let left = getSquareAt(row: square.row, col: square.col-1) {
            neighboringSquares.append(left)
        }
        if let right = getSquareAt(row: square.row, col: square.col+1) {
            neighboringSquares.append(right)
        }
        if let bottomLeft = getSquareAt(row: square.row+1, col: square.col-1) {
            neighboringSquares.append(bottomLeft)
        }
        if let bottom = getSquareAt(row: square.row+1, col: square.col) {
            neighboringSquares.append(bottom)
        }
        if let bottomRight = getSquareAt(row: square.row+1, col: square.col+1) {
            neighboringSquares.append(bottomRight)
        }
        
        return neighboringSquares
    }
    
    //returns the square at row, col. if no such square at row, col, returns nil
    func getSquareAt(row: Int, col: Int) -> MinesweeperButton? {
        if row > -1 && row < 8 && col > -1 && col < 8 {
            return squares[row][col]
        }
        else {
            return nil
        }
    }
    
    
    func squarePressed(sender: MinesweeperButton) { //determines which mine got pressed
        
        sender.revealed = true
        
        sender.backgroundColor = .gray
        
        if sender.isMine == true {
            sender.setTitle("X", for: .normal)
            let alert = UIAlertController(title: "Game Over", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: newGame)
        }
        
        else {
            sender.setTitle("\(sender.mineNeighbors)", for: .normal)
            checkIfWon()
        }
        
        
    }
    
    func checkIfWon() {
        var allNonMinesRevealed = true
        for rowOfButtons in squares {
            for button in rowOfButtons {
                if button.isMine == false && button.revealed == false { //not a mine, not revealed
                    allNonMinesRevealed = false
                }
            }
        }
        
        if (allNonMinesRevealed) {
            let alert = UIAlertController(title: "You won!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: newGame)
        }
        
    }
    
    
    
    
    func newGame() {
        
        squares = [[MinesweeperButton]]() //clearing it, making it an empty array again
        createNewGame()
        
    }
    
    
}

