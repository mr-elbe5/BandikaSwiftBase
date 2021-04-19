//
// Created by Michael Rönnau on 19.04.21.
//

import Foundation

import Foundation
import SwiftyHttpServer

#if os(macOS)
import Cocoa
#elseif os(Linux)

#endif

open class ImageFactory {

    public static var instance : ImageFactory = ImageFactory()

    open func createPreview(fileData: FileData, original: MemoryFile) -> MemoryFile? {
        #if os(macOS)
        return createMacOSPreview(fileData: fileData, original: original)
        #elseif os(Linux)
        return nil
        #else
        return nil
        #endif
    }

    open func canCreatePreview() -> Bool {
        #if os(macOS)
        return true
        #elseif os(Linux)
        return false
        #else
        return false
        #endif
    }

    #if os(macOS)
    open func createMacOSPreview(fileData: FileData, original: MemoryFile) -> MemoryFile? {
        if let src = NSImage(data: original.data) {
            if let previewImage: NSImage = resizeImage(original: src, toSize: NSSize(width: FileData.MAX_PREVIEW_SIDE, height: FileData.MAX_PREVIEW_SIDE)) {
                if let tiff = previewImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
                    if let previewData = tiffData.representation(using: .jpeg, properties: [:]) {
                        let preview = MemoryFile(name: fileData.previewFileName, data: previewData)
                        preview.contentType = "image/jpeg"
                        return preview
                    }
                }
            }
        }
        return nil
    }

    open func resizeImage(original: NSImage, toSize: NSSize) -> NSImage? {
        let newSize: NSSize
        let widthRatio  = toSize.width / original.size.width
        let heightRatio = toSize.height / original.size.height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(original.size.width * heightRatio),
                    height: floor(original.size.height * heightRatio))
        } else {
            newSize = NSSize(width: floor(original.size.width * widthRatio),
                    height: floor(original.size.height * widthRatio))
        }
        let frame = NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        guard let representation = original.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: newSize, flipped: false, drawingHandler: { (_) -> Bool in
            representation.draw(in: frame)
        })
        return image
    }

    #endif

}
