//
// Created by Michael Rönnau on 07.04.21.
//

import Foundation
import Cocoa
import SwiftyHttpServer

extension MemoryFile{

    public func createPreview(fileName: String, maxSize: Int) -> MemoryFile?{
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
    }

}