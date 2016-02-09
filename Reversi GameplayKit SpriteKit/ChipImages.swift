//
//  ChipImage.swift
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
    var cellCGImage: CGImage!
    var cellCIImage: CIImage!

    // chip images with light effect
    var whiteChipWithLight: NSImage!
    var whiteCGChipWithLight: CGImage!
    var whiteCIChipWithLight: CIImage!
    var blackChipWithLight: NSImage!
    var blackCGChipWithLight: CGImage!
    var blackCIChipWithLight: CIImage!

    let size = NSSize(width: 100, height: 100)

    private func chipWithLight(color: NSColor) -> NSImage {
        func handler(rect: NSRect) -> Bool {
            let circlePath = NSBezierPath(ovalInRect: rect)
            let startColor: NSColor = (color == NSColor.whiteColor()) ?
                NSColor.lightGrayColor() : NSColor.blackColor()
            let endColor: NSColor = (color == NSColor.whiteColor()) ?
                NSColor.whiteColor() : NSColor.lightGrayColor()
            let gradient = NSGradient(startingColor: startColor,
                endingColor: endColor)
            let center = NSPoint(x: rect.midX, y: rect.midY)
            let lightPoint = NSPoint(x: center.x+(rect.width/10),
                y: center.y+(rect.height/10))
            gradient?.drawFromCenter(center, radius: rect.width/2,
                toCenter: lightPoint, radius: 0, options: 0)
            startColor.setStroke()
            circlePath.stroke()
            return true
        }
        return NSImage(size: size, flipped: false,
            drawingHandler:handler)
    }

    private func createCellImage() -> NSImage {
        func handler(rect: NSRect) -> Bool {
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
        return NSImage(size: size, flipped: false, drawingHandler:handler)
    }

    init() {
        cellImage = createCellImage()
        cellCGImage = cellImage.CGImageForProposedRect(nil, context: nil, hints: nil)
        cellCIImage = CIImage(CGImage: cellCGImage)

        whiteChipWithLight = chipWithLight(NSColor.whiteColor())
        whiteCGChipWithLight = whiteChipWithLight.CGImageForProposedRect(nil,
            context: nil, hints: nil)
        whiteCIChipWithLight = CIImage(CGImage: whiteCGChipWithLight)

        blackChipWithLight = chipWithLight(NSColor.blackColor())
        blackCGChipWithLight = blackChipWithLight.CGImageForProposedRect(nil,
            context: nil, hints: nil)
        blackCIChipWithLight = CIImage(CGImage: blackCGChipWithLight)
    }
}

