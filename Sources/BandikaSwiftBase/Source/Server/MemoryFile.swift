//
// Created by Michael Rönnau on 07.04.21.
//

import Foundation
import SwiftyHttpServer

#if os(macOS)
import Cocoa
#elseif os(Linux)

#endif

extension MemoryFile{

    public func createPreview(fileName: String, maxSize: Int) -> MemoryFile?{
        #if os(macOS)
        if let src = NSImage(data: data){
            if let previewImage : NSImage = src.resizeMaintainingAspectRatio(withSize: NSSize(width: FileData.MAX_PREVIEW_SIDE, height: FileData.MAX_PREVIEW_SIDE)){
                if let tiff = previewImage.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
                    if let previewData = tiffData.representation(using: .jpeg, properties: [:]) {
                        let preview = MemoryFile(name: fileName, data: previewData)
                        preview.contentType = "image/jpeg"
                        return preview
                    }
                }
            }
        }
        return nil
        #elseif os(Linux)
        // no real preview
        let preview = MemoryFile(name: fileName, data: data)
        preview.contentType = contentType
        return preview
        #endif
    }

}

#if os(macOS)
extension NSImage {

    public func resize(withSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            representation.draw(in: frame)
        })
        return image
    }

    public func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
        let newSize: NSSize
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(size.width * heightRatio),
                    height: floor(size.height * heightRatio))
        } else {
            newSize = NSSize(width: floor(size.width * widthRatio),
                    height: floor(size.height * widthRatio))
        }
        return resize(withSize: newSize)
    }

}
#endif
