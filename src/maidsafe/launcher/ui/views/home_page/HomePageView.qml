/*  Copyright 2015 MaidSafe.net limited

    This MaidSafe Software is licensed to you under (1) the MaidSafe.net Commercial License,
    version 1.0 or later, or (2) The General Public License (GPL), version 3, depending on which
    licence you accepted on initial access to the Software (the "Licences").

    By contributing code to the MaidSafe Software, or to this project generally, you agree to be
    bound by the terms of the MaidSafe Contributor Agreement, version 1.0, found in the root
    directory of this project at LICENSE, COPYING and CONTRIBUTOR respectively and also
    available at: http://www.maidsafe.net/licenses

    Unless required by applicable law or agreed to in writing, the MaidSafe Software distributed
    under the GPL Licence is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
    OF ANY KIND, either express or implied.

    See the Licences for the specific language governing permissions and limitations relating to
    use of the MaidSafe Software.                                                                 */

import QtQuick 2.4
import SAFEAppLauncher.HomePageController 1.0

import "../../custom_components"

FocusScope {
  id: focusScopeRoot
  objectName: "focusScopeRoot"

  Component.onCompleted: {
    mainWindow_.width = 800
    mainWindow_.minimumWidth = 80
    mainWindow_.maximumWidth = 10000

    mainWindow_.height = 600
    mainWindow_.minimumHeight = 60
    mainWindow_.maximumHeight = 10000
  }

  Item {
    anchors {
      fill: parent
      margins: 20
    }

    GridView {
      anchors.fill: parent
      model: homePageController_.homePageModel

      delegate: Rectangle {
        height: 50
        width: 50
        color: model.data.objColor

        Text {
          color: "#ffffff"
          anchors.fill: parent
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          elide: Text.ElideMiddle

          text: model.data.name
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent

          drag.target: dragme

          onReleased: {
            dragme.Drag.drop()
          }

          Rectangle {
            id: dragme

            property int index: model.index

            anchors {
              left: parent.left
              top: parent.top
            }

            height: mouseArea.height
            width: mouseArea.width
            color: "#808080"
            opacity: .5

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            visible: mouseArea.drag.active

            states: State {
              when: mouseArea.drag.active
              ParentChange {
                target: dragme
                parent: mainWindowItem
              }
              AnchorChanges {
                target: dragme
                anchors {
                  left: undefined
                  top: undefined
                }
              }
            }
          }
        }

        DropArea {
          id: dropArea
          anchors.fill: parent

          onDropped: {
            console.log("Dropped from", drag.source.index, "to", model.index)
            homePageController_.move(drag.source.index, model.index)
          }

          Rectangle {
            anchors.fill: parent

            visible: dropArea.containsDrag
            opacity: .5

            SequentialAnimation on color {
              alwaysRunToEnd: true
              loops: Animation.Infinite
              running: dropArea.containsDrag
              ColorAnimation { from: "white"; to: "black"; duration: 300 }
              PauseAnimation { duration: 100 }
              ColorAnimation { from: "black"; to: "white"; duration: 300 }
              PauseAnimation { duration: 100 }
            }
          }
        }
      }
    }
  }
}
