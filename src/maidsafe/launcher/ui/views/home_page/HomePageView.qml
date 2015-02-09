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
import QtQuick.Controls 1.3
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

    ExclusiveGroup {
      id: exclusiveGroup
    }

    GridView {
      anchors.fill: parent
      model: homePageController_.homePageModel

      moveDisplaced: Transition {
        NumberAnimation {
          properties: "x,y"
          duration: 300
        }
      }

      delegate: Item {
        id: delegateItem

        height: 50
        width: 50

        Rectangle {
          id: delegateRect

          property int index: model.index

          opacity: mouseArea.drag.active ? .4 : 1
          Drag.active: mouseArea.drag.active
          Drag.hotSpot.x: width / 2
          Drag.hotSpot.y: height / 2

          color: model.data.objColor

          anchors {
            top: parent.top
            left: parent.left
          }

          width: 50
          height: 50

          states: State {
            when: mouseArea.drag.active
            ParentChange {
              target: delegateRect
              parent: mainWindowItem
            }
            AnchorChanges {
              target: delegateRect
              anchors {
                top: undefined
                left: undefined
              }
            }
          }

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

            property bool checked: false

            Component.onCompleted: {
              exclusiveGroup.bindCheckable(mouseArea)
            }

            Binding on checked {
              when: mouseArea.drag.active
              value: false
            }

            drag.target: parent
            onPressed: checked = !checked
          }

          Rectangle {
            anchors {
              bottom: detailsRect.top
              bottomMargin: -height / 2
              horizontalCenter: parent.horizontalCenter
            }

            width: 10
            height: width

            rotation: 45

            color: "transparent"
            border {
              color: "grey"
              width: 1
            }

            visible: detailsRect.visible
          }

          Rectangle {
            id: detailsRect

            anchors {
              top: parent.bottom
              topMargin: 10
            }

            color: "white"

            border {
              color: "grey"
              width: 1
            }

            height: 200
            width: focusScopeRoot.width - 34
            visible: mouseArea.checked

            onVisibleChanged: {
              x = mapFromItem(focusScopeRoot, 17, 0).x
            }

            Column {
              anchors.fill: parent
              Text {
                anchors.leftMargin: 100
                text: model.data.name
                color: "blue"
              }
              Text {
                color: "green"
                anchors.leftMargin: 100
                text: model.data.objColor
              }
            }
          }
        }

        DropArea {
          id: dropArea
          anchors.fill: parent

          onEntered: {
            homePageController_.move(drag.source.index, model.index)
          }
        }
      }
    }
  }
}
