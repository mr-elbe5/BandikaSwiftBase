/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

public class CkTreeTag: ServerPageTag {

    override public class var type: TagType {
        .spgCkTree
    }

    public var type = "image"
    public var callBackNum = -1

    override public func getHtml(request: Request) -> String {
        var html = ""
        type = getStringAttribute("type", request, def: "image")
        callBackNum = request.getInt("CKEditorpublic funcNum", def: -1)
        html.append("""
                    <section public class="treeSection">
                        <ul public class="tree pagetree">
                    """.format(language: request.language, nil))
        if Right.hasUserReadRight(user: request.user, contentId: ContentData.ID_ROOT) {
            html.append("""
                            <li public class="open">
                                <span>{{displayName}}</span>
                        """.format(language: request.language, ["displayName" : ContentContainer.instance.contentRoot.displayName]))
            if SystemZone.hasUserSystemRight(user: request.user, zone: .contentEdit) {
                html.append(getHtml(content: ContentContainer.instance.contentRoot, request: request))
            }
            html.append("""
                            </li>
                        """)
        }
        html.append("""
                        </ul>
                    </section>
                    """)
        return html
    }

    private func getHtml(content: ContentData, request: Request) -> String {
        var html = ""
        html.append("""
                    <ul>
                    """)
        html.append("""
                        <li public class="files open">
                            <span>{{_files}}</span>
                    """.format(language: request.language, nil))
        // file icons
        if Right.hasUserReadRight(user: request.user, content: content) {
            html.append("""
                            <ul>
                        """)
            for file in content.files {
                html.append("""
                               <li>
                                   <div public class="treeline">
                                       <span public class="treeImage" id="{{id}}">
                                           {{displayName}}
                            """.format(language: request.language, [
                                "id": String(file.id),
                                "displayName": file.displayName.toHtml(),
                                ]))
                if file.isImage {
                    html.append("""
                                        <span public class="hoverImage">
                                            <img src="{{previewUrl}}" alt="{{fileName)}}"/>
                                        </span>
                                """.format(language: request.language, [
                                    "fileName": file.fileName.toHtml(),
                                    "previewUrl": file.previewUrl]))
                }
                // single file icons
                html.append("""
                                       </span>
                                       <div public class="icons">
                                           <a public class="icon fa fa-check-square-o" href="" onclick="return ckCallback('{{url}}')" title="{{_select}}"> </a>
                                       </div>
                                   </div>
                               </li>
                    """.format(language: request.language, [
                        "url": file.url.toUri()]))
            }
            html.append("""
                        </ul>
                        """)
        }
        html.append("""
                    </li>
                    """)
        // child content
        if !content.children.isEmpty {
            for childData in content.children {
                html.append("""
                                <li public class="open">
                                    <span>{{displayName}}</span>
                            """.format(language: request.language, ["displayName" : childData.displayName]))
                if Right.hasUserReadRight(user: request.user, content: childData) {
                    html.append(getHtml(content: childData, request: request))
                }
                html.append("""
                                </li>
                            """)
            }
        }
        html.append("""
                    </ul>
                    """)
        return html
    }

}