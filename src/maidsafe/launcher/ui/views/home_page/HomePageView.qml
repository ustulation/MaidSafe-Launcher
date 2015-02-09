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
import QtQuick.Layouts 1.1
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

    Grid {
      id: gridView

      signal dragActive()
      readonly property int delegateWidth: 50

      spacing: 30
      columns: Math.max(1, width / (delegateWidth + spacing))

      anchors.fill: parent
      Repeater {
        id: gridRepeater

        model: homePageController_.homePageModel

        //      moveDisplaced: Transition {
        //        NumberAnimation {
        //          properties: "x,y"
        //          duration: 300
        //        }
        //      }

        //      Behavior on cellHeight {
        //        NumberAnimation {
        //          alwaysRunToEnd: true
        //        }
        //      }

        delegate: FocusScope {
          id: delegateItem

          readonly property int defaultHeight: 50

          focus: true

          height: defaultHeight
          width: gridView.delegateWidth

          onActiveFocusChanged: {
            if (activeFocus) {
              mouseArea.mouseRelease()
            }
          }

          KeyNavigation.left: gridRepeater.itemAt(model.index - 1 < 0 ? gridRepeater.count - 1 : model.index - 1)
          KeyNavigation.right: gridRepeater.itemAt(model.index + 1 >= gridRepeater.count ? 0 : model.index + 1)

          NumberAnimation on height {
            id: delegateItemIncreaseHeightAnim
            running: false
            to: delegateItem.defaultHeight + detailsRect.maxHeight + 20
          }

          NumberAnimation on height {
            id: delegateItemDecreaseHeightAnim
            running: false
            to: delegateItem.defaultHeight
          }

          Rectangle {
            id: delegateRect

            property int index: model.index

            opacity: mouseArea.drag.active ? .4 : 1
            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            color: model.color

            anchors {
              top: parent.top
              left: parent.left
            }

            border {
              color: "black"
              width: mouseArea.checked
            }

            width: delegateItem.width
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

              text: model.name
            }

            MouseArea {
              id: mouseArea
              anchors.fill: parent

              signal mouseRelease()

              property bool checked: false
              property bool ignoreTogglingChecked: false

              Component.onCompleted: {
                exclusiveGroup.bindCheckable(mouseArea)
              }

              Binding on checked {
                when: mouseArea.drag.active
                value: false
              }

              Connections {
                target: gridView
                onDragActive: {
                  mouseArea.checked = false
                }
              }

              onMouseRelease: {
                if (!ignoreTogglingChecked) {
                  checked = !checked
                } else {
                  ignoreTogglingChecked = false
                }
              }

              drag.target: parent
              onReleased: {
                mouseRelease()
              }

              drag.onActiveChanged: {
                if (drag.active) {
                  mouseArea.ignoreTogglingChecked = true
                  gridView.dragActive()
                }
              }
            }

            Rectangle {
              id: arrowrect

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
              id: topLineRectLeft

              anchors {
                top: detailsRect.top
                topMargin: -height
                left: detailsRect.left
                right: arrowrect.left
                rightMargin: (Math.sqrt(2) * arrowrect.width - arrowrect.width) / 2.0
              }

              height: 1
              color: "grey"
              z:1
              visible: detailsRect.visible
            }

            Rectangle {
              id: topLineRectRight

              anchors {
                top: detailsRect.top
                topMargin: -height
                left: arrowrect.right
                leftMargin: (Math.sqrt(2) * arrowrect.width - arrowrect.width) / 2.0
                right: detailsRect.right
              }

              height: 1
              color: "grey"
              z: 1
              visible: detailsRect.visible
            }

            Rectangle {
              id: detailsRect

              anchors {
                top: parent.bottom
                topMargin: 10
              }

              color: "white"

              readonly property int maxHeight: 125
              height: 10//visible ? maxHeight : 0
              width: focusScopeRoot.width - 30
              visible: mouseArea.checked

              NumberAnimation on height {
                id: animIncreaseHeight
                to: detailsRect.maxHeight
                running: false
              }

              NumberAnimation on height {
                id: animDecreaseHeight
                to: 10
                running: false
              }

              property bool created: false
              Component.onCompleted: created = true

              onVisibleChanged: {
                if (created) {
                  animIncreaseHeight.complete()
                  animDecreaseHeight.complete()
                  delegateItemIncreaseHeightAnim.complete()
                  delegateItemDecreaseHeightAnim.complete()
                  if (visible) {
                    x = focusScopeRoot.mapToItem(delegateRect, 15, 0).x

                    animIncreaseHeight.start()
                    delegateItemIncreaseHeightAnim.start()
                  }
                  else {
                    animDecreaseHeight.start()
                    delegateItemDecreaseHeightAnim.start()
                  }
                }
              }

              Connections {
                target: delegateItem
                onXChanged: detailsRect.x = focusScopeRoot.mapToItem(delegateRect, 15, 0).x
              }

              Column {
                id: propCol

                anchors {
                  margins: 3
                  fill: parent
                }

                spacing: 3
                clip: true

                Text {
                  anchors.leftMargin: 10
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  text: model.name
                  color: "blue"
                }
                Text {
                  color: "green"
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.color
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.prop0
                  color: "black"
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.prop1
                  color: "red"
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.prop2
                  color: "orange"
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.prop3
                  color: "steelblue"
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
}
