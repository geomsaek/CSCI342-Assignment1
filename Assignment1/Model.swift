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
            index -= 1
            
        }while index > 0
    }
    
    // updated the tile on click
    func pushTileIndex(touchTileIndex: Int){
        
        // if the the user is past their first turn
        // response to determine the function to call
        // 0 - match
        // 1 - miss: when squares are the same tile
        // 2 - miss: when squares are different tile
        // -1 - first turn
        
        var response = -1;
        
        if let temp = turn{
            
            if temp {
                lastTileTap = touchTileIndex
                turn = false
            } else {
                
                secondTileTap = lastTileTap
                lastTileTap = touchTileIndex
                turn = true
                
                // if the indexes of the squares are the same then it's a fail
                if secondTileTap! == touchTileIndex {
                    response = 1
                    
                } else {
                    // test to see if the IDs of the two squares are the same
                    // if so = match
                    
                    if tiles[touchTileIndex].imageId == tiles[secondTileTap!].imageId {
                        response = 0
                    } else {
                        // failed match
                        response = 2
                    }
                    updateGameScore(response)
                }
            }
        }else{
            // the user is playing for the first time
            // set only the lastTileTap value to the current 'touchTileIndex' value
            
            lastTileTap = touchTileIndex
            // update the turn to indicate the second turn
            turn = false
        }
        
        // perform the action based on the response
        if(score > -500){
            action_event(response, touchTileIndex: touchTileIndex)
        }
    }
    
    // action the delegate file match based on the response signal passed
    func action_event(response: Int, touchTileIndex: Int){
        
        var index : Int = touchTileIndex
        
        switch response {
        case 0:
            if let temp = secondTileTap {
                delegate?.didMatchTile(self, tileIndex: index, previousTileIndex: secondTileTap!)
            }
            
        case 1:
            delegate?.didFailToMatchTile(self, tileIndex: index, previousTileIndex: index)
            
        case 2:
            if let temp = secondTileTap {
                delegate?.didFailToMatchTile(self, tileIndex: index, previousTileIndex: secondTileTap!)
            }
            
        default:
            index = -1
        }
        
    }
    
    // update the game score
    func updateGameScore (response: Int){
        
        let temp : Int?
        switch response {
            
        case 0:
            
            score += 200
            matchCount += 2
            if (matchCount * 2)==tiles.count{
                delegate?.gameDidComplete(self)
            }
            
        case 2:
            score -= 100
            if self.score <= -500 {
                delegate?.gameDidComplete(self)
            }
        default:
            temp = -1
        }
        
        delegate?.scoreDidUpdate(self, newScore: score)
        
    }
    
    // object description
    var description : String {
        
        var imgs: String = ""
        
        for index in 0..<tiles.count {
            
            imgs = imgs + String(tiles[index].imageId) + ","
            
        }
        return imgs
    }
    
    
}

protocol GameModelDelegate {
    
    func gameDidComplete(gameModel: GameModel)
    func didMatchTile(gameModel : GameModel, tileIndex : Int, previousTileIndex : Int)
    
    func didFailToMatchTile(gameModel : GameModel,  tileIndex : Int, previousTileIndex: Int)
    
    func scoreDidUpdate(gameModel: GameModel, newScore: Int)
    
}