//
// Created by Michael Rönnau on 07.04.21.
//

import Foundation
import SwiftyHttpServer

extension ControllerCache{

    public func showHome(request: Request) -> Response{
        let home = ContentContainer.instance.contentRoot
        if let controller = ControllerCache.get(home.type.rawValue) as? ContentController{
            return controller.show(id: home.id, request: request) ?? Response(code: .notFound)
        }
        return Response(code: .notFound)
    }

    public func openAdminPage(page: String, request: Request) -> Response {
        request.addPageString("title", (Configuration.instance.applicationName + " | " + "_administration".localize(language: request.language)).toHtml())
        request.addPageString("includeUrl", page)
        request.addPageString("hasUserRights", String(SystemZone.hasUserSystemRight(user: request.user, zone: .user)))
        request.addPageString("hasContentRights", String(SystemZone.hasUserSystemRight(user: request.user, zone: .contentEdit)))
        return ForwardResponse(path: "administration/adminMaster", request: request)
    }

    public func showUserAdministration(request: Request) -> Response {
        openAdminPage(page: "administration/userAdministration", request: request)
    }

    public func showContentAdministration(request: Request) -> Response {
        openAdminPage(page: "administration/contentAdministration", request: request)
    }

    public func showContentAdministration(contentId: Int, request: Request) -> Response {
        request.setParam("contentId", contentId)
        return showContentAdministration(request: request)
    }

}