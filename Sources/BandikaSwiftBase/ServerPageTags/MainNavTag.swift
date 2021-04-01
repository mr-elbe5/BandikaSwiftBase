/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

public class MainNavTag: ServerPageTag {

    override public class var type: TagType {
        .spgMainNav
    }

    override public func getHtml(request: Request) -> String {
        var html = ""
        html.append("""
                        <section public class="col-12 menu">
                            <nav public class="navbar navbar-expand-lg navbar-light">
                                <a public class="navbar-brand" href="/"><img src="/layout/logo.png"
                                                                      alt="{{appName}}"/></a>
                                <button public class="navbar-toggler" type="button" data-toggle="collapse"
                                        data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                                        aria-expanded="false" aria-label="Toggle navigation">
                                    <span public class="fa fa-bars"></span>
                                </button>
                                <div public class="collapse navbar-collapse" id="navbarSupportedContent">
                                    <ul public class="navbar-nav mr-auto">
                    """.format(language: request.language, [
                        "appName": Configuration.instance.applicationName.toHtml()]
        ))
        let home = ContentContainer.instance.contentRoot
        let content = request.getSafeContent()
        var activeIds = ContentContainer.instance.collectParentIds(contentId: content.id);
        activeIds.append(content.id)
        for data in home.children {
            if data.navType == ContentData.NAV_TYPE_HEADER && Right.hasUserReadRight(user: request.user, content: data) {
                var children = Array<ContentData>()
                for child in data.children {
                    if child.navType == ContentData.NAV_TYPE_HEADER && Right.hasUserReadRight(user: request.user, content: child) {
                        children.append(child)
                    }
                }
                if !children.isEmpty {
                    html.append("""
                                        <li public class="nav-item dropdown">
                                            <a public class="nav-link {{active}} dropdown-toggle"
                                               data-toggle="dropdown" href="{{url}}" role="button"
                                               aria-haspopup="true" aria-expanded="false">{{displayName}}
                                            </a>
                                            <div public class="dropdown-menu">
                                                <a public class="dropdown-item {{active}}"
                                                   href="{{url}}">{{displayName}}
                                                </a>
                                """.format(language: request.language, [
                                    "active": activeIds.contains(data.id) ? "active" : "",
                                    "url": data.getUrl().toUri(),
                                    "displayName": data.displayName.toHtml()]
                    ))
                    for child in children {
                        html.append("""
                                                <a public class="dropdown-item {{active}}"
                                                   href="{{url}}">{{displayName}}
                                                </a>
                                    """.format(language: request.language, [
                                        "active": activeIds.contains(data.id) ? "active" : "",
                                        "url": child.getUrl().toUri(),
                                        "displayName": child.displayName.toHtml()]
                        ));
                    }
                    html.append("""
                                            </div>
                                        </li>
                                """)
                } else {
                    html.append("""
                                        <li public class="nav-item">
                                            <a public class="nav-link {{active}}}"
                                               href="{{url}}">{{displayName}}
                                            </a>
                                        </li>
                                """.format(language: request.language, [
                                    "active": activeIds.contains(data.id) ? "active" : "",
                                    "url": data.getUrl().toUri(),
                                    "displayName": data.displayName.toHtml()]
                    ))
                }
            }
        }
        html.append("""
                                    </ul>
                                </div>
                            </nav>
                        </section>
                    """)
        return html
    }

}
