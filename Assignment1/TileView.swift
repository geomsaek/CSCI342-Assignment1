//
//  TileView.swift
//  Assignment1
//
//  Created by Matthew Saliba on 1/04/2016.
//  Copyright © 2016 Matthew Saliba. All rights reserved.
//

import Foundation
import UIKit

class TileView : UIView {
    
    var img : UIImage?
    var imgView : UIImageView
    var tileDelegate : TileViewDelegate?
    var tileIndex : Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        
        imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 69, height: 69))
        imgView.image = img
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(coder: aDecoder)
        
        let topConst = NSLayoutConstraint(
            item: imgView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1, constant: 0
        )
        
        let bottomConst = NSLayoutConstraint(
            item: imgView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1, constant: 0
        )
        
        let rightConst = NSLayoutConstraint(
            item: imgView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1, constant: 0
        )
        
        let leftConst = NSLayoutConstraint(
            item: imgView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1, constant: 0
        )
        
        self.addSubview(imgView)
        self.addConstraints([bottomConst,topConst,leftConst,rightConst])
        
        let tapEvent = UITapGestureRecognizer(target: self, action: #selector(TileView.userAction))
        self.addGestureRecognizer(tapEvent)
    }
    
    func userAction() {
        let temp: UIImage? = self.img
        
        if ((temp) != nil) {
            
            if(tileIndex != self.tag){
                self.imgView.alpha=0
                self.imgView.alpha=1
                
                self.displayTile()
                tileDelegate?.didSelectTile(self)
            }
        }
    }
    
    func displayTile(){
        
        let temp: UIImage? = img
        if ((temp) != nil) {
            imgView.alpha=0;
            imgView.image = img;
            alterOpacity()
        }
    }
    
    func coverImage() {
        imgView.alpha=0;
        imgView.image = UIImage(named: "question.png")!
        alterOpacity()
    }
    
    func hideTile() {
        imgView.alpha=0;
        imgView.image = nil
        img = nil
        alterOpacity()
    }
    
    func alterOpacity(){
        UIView.animateWithDuration(1,animations: { self.imgView.alpha = 1.0 })
    }
}

protocol TileViewDelegate {
    func didSelectTile(tileView: TileView)
}