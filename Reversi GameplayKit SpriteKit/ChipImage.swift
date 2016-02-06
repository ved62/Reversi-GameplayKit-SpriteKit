//
//  ChipImage.swift
//  Try3/Try4 
//  
//  This class is using for creating different images for the game usage
//
//  Created by Владислав Эдуардович Дембский on 28.01.16.
//  Copyright © 2016 Vladislav Dembskiy. All rights reserved.
//

import AppKit

final class ChipImage {
    // Just white circle
    var whiteImage: NSImage!
    var whiteCGImage: CGImage!
    var whiteCIImage: CIImage!

    // Just black circle
    var blackImage: NSImage!
    var blackCIImage: CIImage!
    var blackCGImage: CGImage!

    // cell image - background and yelow border
    var cellImage: NSImage!
    var cellCGImage: CGImage!
    var cellCIImage: CIImage!

    var whiteChip: NSImage! // White circle with background for sprite
    var blackChip: NSImage! // Black circle with background for sprite

    // chip images with light effect
    var whiteChipWithLight: NSImage!
    var whiteCGChipWithLight: CGImage!
    var whiteCIChipWithLight: CIImage!
    var blackChipWithLight: NSImage!
    var blackCGChipWithLight: CGImage!
    var blackCIChipWithLight: CIImage!

    let size = NSSize(width: 100, height: 100)

    private func createWhiteImage() -> NSImage {

        let whiteImage = NSImage(size: size, flipped: false,
            drawingHandler: {rect in
            let circlePath = NSBezierPath(ovalInRect: rect)
            let circleColor = NSColor.whiteColor()
            circleColor.set()
            circlePath.fill()
            circlePath.stroke()
            return true
        })
        return whiteImage
    }

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
        let chip = NSImage(size: size, flipped: false,
            drawingHandler:handler)
        return chip
    }

    private func createChip(color: NSColor) -> NSImage {
        func handler(rect: NSRect) -> Bool {
            let borderPath = NSBezierPath(rect: rect)
            var fillColor: NSColor
            if let paternImage = NSImage(named: Constants.cellBackgroundImage)
            {
                fillColor = NSColor(patternImage: paternImage)
            } else {
                fillColor = NSColor.greenColor()
            }
            fillColor.setFill()
            borderPath.fill()
            let circlePath = NSBezierPath(ovalInRect: rect)
            let circleColor = color
            circleColor.set()
            circlePath.fill()
            circlePath.stroke()
            return true
        }
        let cellImage = NSImage(size: size, flipped: false,
            drawingHandler:handler)
        return cellImage
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
        let cellImage = NSImage(size: size, flipped: false, drawingHandler:handler)
        return cellImage
    }

    private func invertColor(image: CIImage) -> CIImage {
        let colorInvert = CIFilter(name: "CIColorInvert")
        colorInvert!.setValue(image, forKey: kCIInputImageKey)
        return colorInvert!.outputImage!
    }

    private func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        let context = CIContext(options: nil)
        return context.createCGImage(inputImage, fromRect: inputImage.extent)
    }

    init() {
        whiteImage = createWhiteImage()
        whiteCGImage = whiteImage.CGImageForProposedRect(nil,
            context: nil, hints: nil)
        whiteCIImage = CIImage(CGImage: whiteCGImage!)
        blackCIImage = invertColor(whiteCIImage!)
        blackCGImage = convertCIImageToCGImage(blackCIImage!)
        blackImage = NSImage(CGImage: blackCGImage!,
            size: NSZeroSize)

        cellImage = createCellImage()
        cellCGImage = cellImage.CGImageForProposedRect(nil, context: nil, hints: nil)
        cellCIImage = CIImage(CGImage: cellCGImage)

        whiteChip = createChip(NSColor.lightGrayColor())
        blackChip = createChip(NSColor.blackColor())

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

