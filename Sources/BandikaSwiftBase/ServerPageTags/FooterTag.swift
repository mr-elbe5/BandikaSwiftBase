/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

public class FooterTag: ServerPageTag {

    override public class var type: TagType {
        .spgFooter
    }

    override public func getHtml(request: Request) -> String {
        var html = ""
        html.append("""
                        <ul public class="nav">
                            <li public class="nav-item">
                                <a public class="nav-link">&copy; {{copyRight}}
                                </a>
                            </li>
                    """.format(language: request.language, [
            "copyRight": "_copyright".toLocalizedHtml(language: request.language)]
        ))
        for child in ContentContainer.instance.contentRoot.children {
            if child.navType == ContentData.NAV_TYPE_FOOTER && Right.hasUserReadRight(user: request.user, content: child) {
                html.append("""
                            <li public class="nav-item">
                                <a public class="nav-link" href="{{url}}">{{displayName}}
                                </a>
                            </li>
                            """.format(language: request.language, [
                    "url": child.getUrl().toHtml(),
                    "displayName": child.displayName.toHtml()]
                ))
            }
        }
        html.append("""
                        </ul>
                    """)
        return html
    }

}
