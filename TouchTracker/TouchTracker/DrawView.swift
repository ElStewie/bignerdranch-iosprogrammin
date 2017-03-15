//
//  DrawView.swift
//  TouchTracker
//
//  Created by Hisham Abraham on 3/12/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    var currentLines = [NSValue:Line]()
    var finisedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet  {
            if selectedLineIndex == nil {
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapeGesterRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapeGesterRecognizer.numberOfTapsRequired = 2
        doubleTapeGesterRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapeGesterRecognizer)
        
        let tapeRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapeRecognizer.delaysTouchesBegan = true
        tapeRecognizer.require(toFail: doubleTapeGesterRecognizer)
        addGestureRecognizer(tapeRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    func doubleTap(_ gesterRecognizer: UIGestureRecognizer){
        print("Recognized a double tap")
        
        selectedLineIndex = nil
        currentLines.removeAll()
        finisedLines.removeAll()
        setNeedsDisplay()
    }
    
    func tap(_ gesterRecognizer: UIGestureRecognizer){
        print("Recognized a tap")
        
        let point = gesterRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        
        //Grab the menu controller
        let menu = UIMenuController.shared
        
        if selectedLineIndex != nil {
            
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            
            //Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            //Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            //Hide menu if no lines selected
            menu.setMenuVisible(false, animated: true)
        }
        setNeedsDisplay()

    }
    
    func longPress(_ gesterRecognizer: UIGestureRecognizer){
        print("Recognized a long press")
        
        if(gesterRecognizer.state == .began){
            let point = gesterRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            
            if(selectedLineIndex != nil){
                currentLines.removeAll()
            }
        } else if gesterRecognizer.state == .ended {
            selectedLineIndex = nil
            
        }
        
    }
    
    func moveLine(_ gesterRecognizer: UIPanGestureRecognizer){
        print("Recognized a pan")
        
        // If a line is selected... 
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position... 
            if gesterRecognizer.state == .changed {
                // How far has the pan moved? 
                let transelation = gesterRecognizer.translation(in: self)
                
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos! 
                finisedLines[index].begin.x += transelation.x
                finisedLines[index].begin.y += transelation.y
                finisedLines[index].end.x += transelation.x
                finisedLines[index].end.y += transelation.y
                gesterRecognizer.setTranslation(CGPoint.zero, in: self)
                // Redraw the screen 
                setNeedsDisplay()
            }
        } else {
            // If no line is selected, do not do anything 
            return
        }

    }
    
    func stroke(_ line: Line){
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finisedLines{
            stroke(line)
        }
        
        currentLineColor.setStroke()
        for(_, line ) in currentLines{
            stroke(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.green.setStroke()
            let selectedLine = finisedLines[index]
            stroke(selectedLine)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //log statement to see the order of events
        print(#function)
        for touch in touches{
            //Get location of the touch in view's coordinate system
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
            
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //log statement to see the order of events
        print(#function)
        for touch in touches{

            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
            
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //log statement to see the order of events
        print(#function)
        for touch in touches{
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                finisedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //log statement to see the order of events
        print(#function)
        
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        //find a line close to the point
        for (index, line) in finisedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            
            // Check a few points on the line 
            for t in stride( from: CGFloat( 0), to: 1.0, by: 0.05) {
                let x = begin.x + (( end.x - begin.x) * t)
                let y = begin.y + (( end.y - begin.y) * t)
                // If the tapped point is within 20 points, let's return this line 
                if hypot( x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        return nil
    }
    
    func deleteLine(_ sender: UIMenuController){
        //Remove the selected line from the list of finised lines
        if let index = selectedLineIndex {
            finisedLines.remove(at: index)
            selectedLineIndex = nil
            
            setNeedsDisplay()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
