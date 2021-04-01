/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

public enum ControllerType: String {
    case admin
    case ckeditor
    case file
    case fullpage
    case group
    case templatepage
    case user
}

public class Controller {

    public class var type: ControllerType {
        get {
            fatalError()
        }
    }

    public func processRequest(method: String, id: Int?, request: Request) -> Response? {
        nil
    }

    public func setSuccess(request: Request, _ name: String) {
        request.setMessage(name.toLocalizedHtml(language: request.language), type: .success)
    }

    public func setError(request: Request, _ name: String) {
        request.setMessage(name.toLocalizedHtml(language: request.language), type: .danger)
    }

    public func showHome(request: Request) -> Response{
        let home = ContentContainer.instance.contentRoot
        if let controller = ControllerFactory.getDataController(type: home.type) as? ContentController{
            return controller.show(id: home.id, request: request) ?? Response(code: .notFound)
        }
        return Response(code: .notFound)
    }

    public func openAdminPage(page: String, request: Request) -> Response {
        request.addPageVar("title", (Configuration.instance.applicationName + " | " + "_administration".localize(language: request.language)).toHtml())
        request.addPageVar("includeUrl", page)
        request.addPageVar("hasUserRights", String(SystemZone.hasUserSystemRight(user: request.user, zone: .user)))
        request.addPageVar("hasContentRights", String(SystemZone.hasUserSystemRight(user: request.user, zone: .contentEdit)))
        return ForwardResponse(page: "administration/adminMaster", request: request)
    }

    public func showUserAdministration(request: Request) -> Response {
        openAdminPage(page: "administration/userAdministration", request: request)
    }

    public func showContentAdministration(request: Request) -> Response {
        return openAdminPage(page: "administration/contentAdministration", request: request)
    }

    public func showContentAdministration(contentId: Int, request: Request) -> Response {
        request.setParam("contentId", contentId)
        return showContentAdministration(request: request)
    }

}
