//
//  ViewController.swift
//  Assignment1
//
//  Created by Matthew Saliba on 1/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameModelDelegate, TileViewDelegate {

    var gameTiles: [TileView]
    let tileCount = 12
    var puzzle : GameModel
    let tiles: [UIImage] = [UIImage(named: "baldhill.png")!, UIImage(named: "cathedral.png")!, UIImage(named: "lake.png")!]
    
    required init?(coder aDecoder: NSCoder){
        
        puzzle = GameModel(number : tileCount, images : tiles)
        gameTiles = [TileView]()
        
        //print(puzzle)
        // initialise the superclass
        super.init(coder: aDecoder)
        
        // delegate the game model delegate to the current object
        puzzle.delegate = self
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeTiles()
    }
    
    func makeTiles(){
        
        for index in 0..<tileCount {
            
            if let tile = self.view.viewWithTag(index+1) as? TileView {
                gameTiles.append(tile)
                gameTiles[index].img = puzzle.tiles[index].imageObject
                gameTiles[index].tileIndex = index
                gameTiles[index].tileDelegate = self
                gameTiles[index].coverImage()
            }
            
        }
    }
    
    // if the user selected the tile - from TileView
    func didSelectTile(tileView: TileView) {
        puzzle.pushTileIndex(tileView.tileIndex)
    }
    
    
    func gameDidComplete(gameModel: GameModel){
    
    }
    
    func didMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int) {
    
    }
    
    func didFailToMatchTile(gameModel: GameModel, tileIndex: Int, previousTileIndex: Int) {
        
    }
    
    func scoreDidUpdate(gameModel: GameModel, newScore: Int) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

