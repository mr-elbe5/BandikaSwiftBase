//
// Created by Michael Rönnau on 07.04.21.
//

import Foundation



extension StaticFileController{

    public func processLayoutPath(path: String, request: Request) -> Response?{
        var path = path
        path.removeFirst(BandikaRouter.layoutPrefix.count)
        let fullPath = Paths.layoutDirectory.appendPath(path)
        if let data : Data = Files.readFile(path: fullPath){
            let contentType = MimeType.from(fullPath)
            return Response(data: data, fileName: fullPath.lastPathComponent(), contentType: contentType)
        }
        Log.info("reading file from \(fullPath) failed")
        return Response(code: .notFound)
    }

    public func ensureLayout(){
        if Files.directoryIsEmpty(path: Paths.layoutDirectory) {
            for sourcePath in Files.listAllFiles(dirPath: Paths.defaultLayoutDirectory){
                let targetPath = Paths.layoutDirectory.appendPath(sourcePath.lastPathComponent())
                if !Files.copyFile(from: sourcePath, to: targetPath){
                    Log.error("could not copy layout file \(sourcePath)")
                }
            }
        }
    }
    
    public func useBaseFiles(){
        self.bundle = Bundle.module
        self.bundleName = "Web"
    }

}
