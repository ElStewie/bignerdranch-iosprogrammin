//
//  DrawView.swift
//  TouchTracker
//
//  Created by Hisham Abraham on 3/12/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine = [NSValue:Line]()
    var finisedLines = [Line]()
    
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
        for(_, line ) in currentLine{
            stroke(line)
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
            currentLine[key] = newLine
            
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //log statement to see the order of events
        print(#function)
        for touch in touches{

            let key = NSValue(nonretainedObject: touch)
            currentLine[key]?.end = touch.location(in: self)
            
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //log statement to see the order of events
        print(#function)
        for touch in touches{
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLine[key] {
                line.end = touch.location(in: self)
                finisedLines.append(line)
                currentLine.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //log statement to see the order of events
        print(#function)
        
        currentLine.removeAll()
        setNeedsDisplay()
    }
}
