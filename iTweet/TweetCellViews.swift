//
//  TweetCellViews.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable
class TweetBackgroundView: UIView {
    
    let shape = CAShapeLayer()
    let shadow = NSShadow()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Background Color
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        
        //// Shadow Declarations
        
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.28)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 12
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: self.frame.width - 10, height: self.frame.height - 10), byRoundingCorners: [.topLeft, .bottomRight], cornerRadii: CGSize(width: 60, height: 60))
        rectanglePath.close()
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.white.setFill()
        rectanglePath.fill()
        context.restoreGState()
        
        
        shape.frame = self.bounds
        shape.path = rectanglePath.cgPath
        shape.borderWidth = 5
        shape.borderColor = UIColor.clear.cgColor
        //shape.fillColor = UIColor.blue.cgColor
        
        shape.shadowRadius = 100
        
        shape.shadowColor = UIColor.black.withAlphaComponent(0.38).cgColor
        shape.shadowOffset = CGSize(width: 0, height: 0)
        shape.shadowPath = rectanglePath.cgPath
        
        
        self.layer.insertSublayer(shape, at: 0)
        self.clipsToBounds = true
        //self.layer.mask = shape
        //self.layer.addSublayer(shadow)
        //self.layer.anchorPoint = (0.5, 0.5)
        //self.layer.mask?.position = self.center
        
//        self.layer.shadowRadius = 6
////        
//        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.38).cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowPath = rectanglePath.cgPath
        
        
    }
    
    @IBInspectable var fillColor: UIColor? {
        didSet {
            shape.fillColor = fillColor?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat? {
        didSet {
            shadow.shadowBlurRadius = shadowRadius!
        }
    }
}

class ProfileImageView: UIImageView {
    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0), radius: self.bounds.width, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
//        
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        mask.fillColor = UIColor.blue.cgColor
//        self.layer.mask = mask
        
        let width = self.frame.width
        let height = self.frame.height
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.38)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 6
        
        context.saveGState()
        context.setAlpha(0.2)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: width - 8, height: height - 8))
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.black.setFill()
        oval5Path.fill()
        context.restoreGState()
        
        
        context.endTransparencyLayer()
        context.restoreGState()
        
        let maskedImage = UIImageView()
        maskedImage.image = #imageLiteral(resourceName: "Canvas 6")
        maskedImage.frame = self.bounds
        self.mask = maskedImage
        
        let layer2 = CAShapeLayer()
        layer2.path = oval5Path.cgPath
        layer2.frame = self.bounds
        layer2.fillColor = UIColor.darkGray.cgColor
        
        self.image = #imageLiteral(resourceName: "twitterImage")
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 6
        //self.layer.mask = layer2
    }
    
    func maskImage(image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: maskReference!.width,
                                height: maskReference!.height,
                                bitsPerComponent: maskReference!.bitsPerComponent,
                                bitsPerPixel: maskReference!.bitsPerPixel,
                                bytesPerRow: maskReference!.bytesPerRow,
                                provider: maskReference!.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference!.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }
}


@IBDesignable
class ProfileTweetImageView: UIView {
    
    override func draw(_ rect: CGRect) {
        let width = self.frame.width
        let height = self.frame.height
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        
        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.38)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 6
        
        //// Oval 4 Drawing
        context.saveGState()
        context.setAlpha(0.1)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: 2, y: 2, width: width - 4, height: height - 4))
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.black.setFill()
        oval4Path.fill()
        context.restoreGState()
        
        
        context.endTransparencyLayer()
        context.restoreGState()
        
        
        //// Oval 5 Drawing
        context.saveGState()
        context.setAlpha(0.2)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: width - 8, height: height - 8))
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        UIColor.black.setFill()
        oval5Path.fill()
        context.restoreGState()
        
        
        context.endTransparencyLayer()
        context.restoreGState()
        
        
        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 6, y: 6, width: width - 12, height: height - 12))
        context.saveGState()
        context.setShadow(offset: shadow.shadowOffset, blur: shadow.shadowBlurRadius, color: (shadow.shadowColor as! UIColor).cgColor)
        
        UIColor.darkGray.setFill()
        oval6Path.fill()
        context.restoreGState()
        
        /// UIImageView
//        let profileImageView = UIImageView(frame: CGRect(x: 6, y: 6, width: width - 12, height: height - 12))
//        profileImageView.clipsToBounds = true
//        profileImageView.image = #imageLiteral(resourceName: "twitterImage")
//        profileImageView.contentMode = .scaleAspectFit
        
        let layer1 = CAShapeLayer()
        layer1.path = oval4Path.cgPath
        layer1.frame = self.bounds
        layer1.fillColor = UIColor.lightGray.cgColor
        
        let layer2 = CAShapeLayer()
        layer2.path = oval5Path.cgPath
        layer2.frame = self.bounds
        layer2.fillColor = UIColor.darkGray.cgColor
        
        self.layer.insertSublayer(layer1, at: 0)
        self.layer.insertSublayer(layer2, at: 1)
        //self.layer.mask = layer1
//        self.image = #imageLiteral(resourceName: "twitterImage")
//        self.clipsToBounds = true
//        self.contentMode = .scaleAspectFit
        
        
    }
}
