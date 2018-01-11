//
//  WCMidThumbSlider.swift
//  WCMidThumbSlider
//
//  Created by wanchenxie on 03/01/2018.
//  Copyright © 2018 wanchen. All rights reserved.
//

import UIKit

let kCaputeScopeTimes:CGFloat = 3.0

protocol WCMidThumbSliderDelegate {
    func sliderValueChanged(sender: WCMidThumbSlider)
    func sliderTouchedDown(sender: WCMidThumbSlider)
    func sliderTouchedUp(sender: WCMidThumbSlider)
}

class WCMidThumbSlider: UIView {

    let trackHight: CGFloat = 2
    var delegate: WCMidThumbSliderDelegate?
    
    var minValue: Float = 0
    var maxValue: Float = 100
    var value: Float    = 50 {
        didSet {
            updateDisplay(value: value)
        }
    }
    
    private var thumb = UIImageView()
    
    
    private func updateDisplay(value: Float) {
        
        thumb.center.x = convertValueToLocation(value: value)
        
        self.setNeedsDisplay()
        
    }
    
    private func convertValueToLocation(value: Float) -> CGFloat {
        let ratio = value / (maxValue - minValue) + minValue
        let location = CGFloat.init(ratio) * ( self.bounds.size.width - thumb.bounds.size.width)
        
        return location + thumb.bounds.size.width / 2
    }
    
    private func convertLocationToValue(location: CGFloat) -> Float {
        let ratio = (location - thumb.bounds.size.width / 2) / (self.bounds.size.width - thumb.bounds.width)
        let value = Float.init(ratio) * (maxValue - minValue) + minValue
        
        return value
    }
    
    override func draw(_ rect: CGRect) {
        // Rectangle
        let thumbX = thumb.center.x
        let midX = self.bounds.size.width / 2
        
        var startX: CGFloat?
        var endX: CGFloat?
        if thumbX > midX {
            startX = midX
            endX = thumbX
        }
        else {
            startX = thumbX
            endX = midX
        }
        
        let startY = self.bounds.size.height / 2 - trackHight / 2
        let drawRect = CGRect.init(x: startX!,
                                   y: startY,
                                   width: endX! - startX!,
                                   height: trackHight)
        
        let backgroundRectOne = CGRect.init(x: 0,
                                            y: startY,
                                            width: startX!,
                                            height: trackHight)
        
        let backgroundRectTwo = CGRect.init(x: endX!,
                                            y: startY,
                                            width: self.bounds.size.width - endX!,
                                            height: trackHight)
        
        // Drawing
        let drawContext = UIGraphicsGetCurrentContext()
        
        let selectTrackColor = UIColor.init(red: 9 / 255,
                                            green: 113 / 255,
                                            blue: 255 / 255,
                                            alpha: 1)
        
        drawContext?.setFillColor(selectTrackColor.cgColor)
        drawContext?.fill(drawRect)
        
        let backgroundTrackColor = UIColor.init(red: 210 / 255,
                                                green: 210 / 255,
                                                blue: 210 / 255,
                                                alpha: 1)
        
        drawContext?.setFillColor(backgroundTrackColor.cgColor)
        drawContext?.fill(backgroundRectOne)
        drawContext?.fill(backgroundRectTwo)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializer()
    }
    
    private func initializer() {
        
        addThumb()
        addTouchGesture()
        
    }
    
    private func addTouchGesture() {
        let touch = UIPanGestureRecognizer.init(target: self,
                                                action: #selector(touchGestureHandler(sender:)))
        self.addGestureRecognizer(touch)
    }
    
    @objc func touchGestureHandler(sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        print("touch point (\(point.x), \(point.y)")
        movingThumb(with: sender)
        
        
    }
    
    private func addThumb() {
        // Location
        thumb.bounds = CGRect.init(x: 0, y: 0, width: 15, height: 15)
        thumb.center = CGPoint.init(x: thumb.bounds.width / 2, y: self.bounds.size.height / 2)
        
        // Round
        thumb.layer.masksToBounds = true
        thumb.layer.cornerRadius = thumb.bounds.size.width / 2
        
        // Shadown
        thumb.layer.borderColor = UIColor.lightGray.cgColor
        thumb.layer.borderWidth = 0.5
        thumb.layer.shadowColor = UIColor.init(white: 0.3, alpha: 1).cgColor
        //thumb.layer.shadowRadius = 3.0
        thumb.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        thumb.layer.shadowOpacity = 0.6
        
        // Color
        thumb.backgroundColor = UIColor.white
        
 
        self.addSubview(thumb)
        
    }
    
    private var movingGesture: UIPanGestureRecognizer?
    
    private func movingThumb(with sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            delegate?.sliderTouchedDown(sender: self)
            
            let senderLocation = sender.location(in: self)
            
            // capture scope
            if abs(senderLocation.x - thumb.center.x) < thumb.bounds.size.width * kCaputeScopeTimes {
                
                movingGesture = sender
            }
            
        }
        
        
        if sender == movingGesture {
 
            var location = sender.location(in: self)
            
            // header
            if location.x < thumb.bounds.size.width / 2 {
               location.x = thumb.bounds.size.width / 2
            }
            
            // tailer
            if location.x > self.bounds.width - thumb.bounds.size.width / 2 {
                location.x = self.bounds.width - thumb.bounds.size.width / 2
            }
            
            
            thumb.center = CGPoint.init(x: location.x,
                                        y: thumb.center.y)
            
            
            value = convertLocationToValue(location: location.x)
            
            delegate?.sliderValueChanged(sender: self)
            
            
            sender.setTranslation(CGPoint.zero, in: self)
            
            self.setNeedsDisplay()
        }
        
        
        if (sender.state == .ended
            || sender.state == .cancelled
            || sender.state == .failed) {
            
            movingGesture = nil
            
            delegate?.sliderTouchedUp(sender: self)
        }
    }
    
    
}
