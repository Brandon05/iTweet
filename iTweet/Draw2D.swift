//
//  Draw2D.swift
//  DiagonalLine
//
//  Created by Brandon Sanchez on 2/21/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

//@IBDesignable
class Draw2D: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        //Drawing Code
        let deviceWidth = UIScreen.main.bounds.width
        let deviceHeight = UIScreen.main.bounds.height
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowOffset = CGSize(width: -1, height: 0)
        shadow.shadowBlurRadius = 7
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0, y: self.frame.height))
        bezierPath.addLine(to: CGPoint(x: UIScreen.main.bounds.maxX, y: self.frame.height))
        bezierPath.addLine(to: CGPoint(x: UIScreen.main.bounds.maxX, y: self.frame.height * 0.6))
        //bezierPath.addLine(to: CGPoint(x: 73.5, y: 64.5))
        //bezierPath.addLine(to: CGPoint(x: 73.5, y: 64.5))
        bezierPath.close()
        context?.saveGState()
        context?.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        
        color.setFill()
        bezierPath.fill()
        context?.restoreGState()
    }
 

}
