//
//  ChipImages.swift
//
//  Reversi OS X
//  
//  This class is using for creating different images for the game usage
//
//  Created by Владислав Эдуардович Дембский on 28.01.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import AppKit

final class ChipImages {

    // cell image - background and yelow border
    var cellImage: NSImage!

    // chip images with light effect
    var whiteChipWithLight: NSImage!
    var whiteCIChipWithLight: CIImage!
    var blackChipWithLight: NSImage!
    var blackCIChipWithLight: CIImage!

    private let size = CGSize(width: 100, height: 100)

    private func chipWithLight(color: NSColor) -> NSImage {
        func handler(rect: CGRect) -> Bool {
            let circlePath = NSBezierPath(ovalInRect: rect)
            let startColor: NSColor = (color == NSColor.whiteColor()) ?
                NSColor.lightGrayColor() : NSColor.blackColor()
            let endColor: NSColor = (color == NSColor.whiteColor()) ?
                NSColor.whiteColor() : NSColor.lightGrayColor()
            let gradient = NSGradient(startingColor: startColor,
                endingColor: endColor)
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let lightPoint = CGPoint(x: center.x+(rect.width/10),
                y: center.y+(rect.height/10))
            gradient?.drawFromCenter(center, radius: rect.width/2,
                toCenter: lightPoint, radius: 0, options: 0)
            startColor.setStroke()
            circlePath.stroke()
            return true
        }
        return NSImage(size:size,flipped:false,drawingHandler:handler)
    }

    private func createCellImage() -> NSImage {
        func handler(rect: CGRect) -> Bool {
            let borderPath = NSBezierPath(rect: rect)
            let borderColor = NSColor.yellowColor()
            var fillColor: NSColor
            if let paternImage = NSImage(named:
                Constants.cellBackgroundImage)
            {
                fillColor = NSColor(patternImage: paternImage)
            } else {
                fillColor = NSColor.greenColor()
            }
            fillColor.setFill()
            borderPath.fill()
            borderColor.setStroke()
            borderPath.stroke()
            return true
        }
        return NSImage(size:size,flipped:false, drawingHandler:handler)
    }

    init() {
        cellImage = createCellImage()

        whiteChipWithLight = chipWithLight(NSColor.whiteColor())
        whiteCIChipWithLight = CIImage(CGImage:
            whiteChipWithLight.CGImageForProposedRect(nil, context: nil,
                hints: nil)!)

        blackChipWithLight = chipWithLight(NSColor.blackColor())
        blackCIChipWithLight = CIImage(CGImage:
            blackChipWithLight.CGImageForProposedRect(nil, context: nil,
                hints: nil)!)
    }
}

