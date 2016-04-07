//
//  Model.swift
//  Assignment1
//
//  Created by Matthew Saliba on 1/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import Foundation
import UIKit

// tiledata struct
struct TileData {
    var imageId : Int
    var imageObject : UIImage
}

class GameModel: CustomStringConvertible {

    var lastTileTap : Int?
    var secondTileTap : Int?
    var tiles: [TileData] = []
    var tileIndex = 0
    var turn : Bool?
    var matchCount : Int = 0
    var score : Int = 0
    var userView : UIView?
    var delegate: GameModelDelegate?
    
    init(number : Int, images : [UIImage]){
        
        reset(number, images : images)
    }
    
    
    func reset(number: Int, images: [UIImage]) {
        
        self.lastTileTap = nil
        self.secondTileTap = nil
        self.turn = nil
        self.matchCount = 0
        self.score = 0
        self.tiles = []
        
        var counter = 0
        var imageCounter = 0
        
        repeat {
            
            if imageCounter >= images.count {
                imageCounter = 0
            }
            
            tiles.append(TileData(imageId : imageCounter, imageObject : images[imageCounter]))
            tiles.append(TileData(imageId : imageCounter, imageObject : images[imageCounter]))
            imageCounter += 1
            counter += 1
            
        }while counter < number
        
        
        let length = tiles.count
        var index = length - 1
        
        var temp : TileData
        
        repeat {
            let k = Int(arc4random_uniform(UInt32(length-1)))
            
            /*swap function passes array by ref*/
            temp = tiles[index]
            tiles[index] = tiles[k]
            tiles[k] = temp
            
            //swap(&tiles[index], &tiles[k])
            index -= 1
            
        }while index > 0
    }
    
    // object description
    var description : String {
        
        var imgs: String = ""
        
        for index in 0..<tiles.count {
            
            imgs = imgs + String(tiles[index].imageId) + ","
            
        }
        return imgs
    }
    
    // updated the tile on click
    func pushTileIndex(touchTileIndex: Int){
        
        secondTileTap = lastTileTap
        lastTileTap = touchTileIndex
    
    }

}

protocol GameModelDelegate {

    func gameDidComplete(gameModel: GameModel)
    func didMatchTile(gameModel : GameModel, tileIndex : Int, previousTileIndex : Int)
    func didFailToMatchTile(gameModel : GameModel,  tileIndex : Int, previousTileIndex: Int)
    func scoreDidUpdate(gameModel: GameModel, newScore: Int)
    
}
