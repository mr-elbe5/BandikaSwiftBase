/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import SwiftyHttpServer

public class CloseDialogResponse: Response{

    public init(url: String, request: Request){
        request.addPageString("url", url)
        request.addPageBool("hasMessage", request.hasMessage)
        if request.hasMessage{
            request.addPageString("message", request.message!.text)
            request.addPageString("messageType", request.message!.type.rawValue)
        }
        if let html = ServerPageController.instance.processPage(path: "closeDialog.ajax", request: request) {
            super.init(html: html)
        }
        else {
            super.init(code: .internalServerError)
        }
    }

}