//
//  ViewController.swift
//  Assignment1
//
//  Created by Matthew Saliba on 1/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TileViewDelegate, GameModelDelegate {
    
    var puzzle : GameModel
    let tileCount = 12
    var prevTouch = 0
    var gameTiles: [TileView]
    let tiles: [UIImage] = [UIImage(named: "baldhill.png")!, UIImage(named: "cathedral.png")!, UIImage(named: "lake.png")!]
    
    @IBOutlet var scoreValue: UILabel!
    
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
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func gameDidComplete(gameModel: GameModel){
        
        let message = "The score: " + String(puzzle.score);
        var title : String
        let actionTitle = "RETRY"
        
        if puzzle.score == -500 {
            title = "You lose! Game over!"
        }else{
            title = "Game Completed!"
        }
        
        showAlert(message, title: title, actionTitle: actionTitle)
        
        puzzle.reset(tileCount, images: tiles)
        
        let loop = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.makeTiles), userInfo: nil, repeats: false)
        
    }
    
    // matched the tile
    func didMatchTile(gameModel : GameModel, tileIndex : Int, previousTileIndex : Int) {
        
        // call the "selector" function "hideTile" in the TileView file
        // to hide the tile from view
        setTimer(tileIndex, selectorOption: Selector("hideTile"))
        setTimer(previousTileIndex, selectorOption: Selector("hideTile"))
    }
    
    // failed to match the tile
    func didFailToMatchTile(gameModel : GameModel,  tileIndex : Int, previousTileIndex: Int) {
        
        // call the "selector" function "coverImage" in the TileView file
        // to set reset the default image back to the question mark JPG
        setTimer(tileIndex, selectorOption: "coverImage")
        setTimer(previousTileIndex, selectorOption: "coverImage")
    }
    
    // update the score
    func scoreDidUpdate(gameModel: GameModel, newScore: Int) {
        scoreValue.text = String(newScore)
    }
    
    // if the user selected the tile
    func didSelectTile(tileView: TileView) {
        puzzle.pushTileIndex(tileView.tileIndex)
    }
    
    // change the opacity of a tile
    func opacityChange(tileIndex: Int, opacityVal: CGFloat){
        UIView.animateWithDuration(1,animations: {
            self.gameTiles[tileIndex].alpha = opacityVal
        })
    }
    
    
    // generic function for hiding and showing tiles based on the supplied indexes
    // timers call selector functions to manipulate the tile before showing it again
    
    func setTimer(tileIndex: Int, selectorOption: Selector){
        
        let invisible : CGFloat = 0.0
        let visible : CGFloat = 1.0
        
        // set the current index of the tile to be invisible
        opacityChange(tileIndex, opacityVal: invisible)
        
        // set the first timer
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: gameTiles[tileIndex], selector: selectorOption, userInfo: nil, repeats: false)
        
        // redisplay the tile after the timer is complete
        opacityChange(tileIndex, opacityVal: visible)
    }
    
    // show alert
    func showAlert(message: String, title: String, actionTitle: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

