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
import QtQuick.Dialogs 1.2
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

  Timer {
    id: queuedConnectionTimer
    interval: 0
  }

  FileDialog {
    id: fileDialog

    title: qsTr("Choose an App to add to Launcher")
    onAccepted: homePageController_.addAppRequested(fileUrl)
  }

  DropArea {
    anchors.fill: parent

    onEntered: {
      if (drag.source.index !== gridRepeater.count - 1) {
        // If it leaves into the wilderness shift everything beyond it to its place
        homePageController_.move(drag.source.index, gridRepeater.count - 1)
      }
    }

    ExclusiveGroup {
      id: exclusiveGroup
    }

    Grid {
      id: gridView

      signal dragActive()
      readonly property int delegateWidth: 50

      anchors {
        fill: parent
        topMargin: 100
        margins: 20
      }

      spacing: 50
      columns: Math.max(1, width / (delegateWidth + spacing))

      move: Transition {
        id: moveTransition

        enabled: false

        NumberAnimation {
          properties: "x,y"
          duration: 200
        }
      }

      Rectangle {
        id: addAppRect

        width: gridView.delegateWidth
        height: width
        radius: 5

        color: "#80808080"

        Rectangle {
          anchors.centerIn: parent

          width: parent.width - 10
          height: 2
          color: "grey"
        }
        Rectangle {
          anchors.centerIn: parent

          width: parent.width - 10
          height: 2
          color: "grey"
          rotation: 90
        }

        MouseArea {
          anchors.fill: parent
          onClicked: {
            fileDialog.open()
          }
        }
      }


      Repeater {
        id: gridRepeater

        model: homePageController_.homePageModel

        onCountChanged: queuedConnectionTimer.restart()

        delegate: FocusScope {
          id: delegateRoot

          readonly property int dropDownAnimationDuration: 50
          readonly property int defaultHeight: 50

          focus: true

          height: defaultHeight
          width: gridView.delegateWidth

          function getLeftNeighbour() {
            return gridRepeater.itemAt(model.index ? model.index - 1 : gridRepeater.count - 1)
          }
          function getRightNeighbour() {
            return gridRepeater.itemAt(model.index + 1 >= gridRepeater.count ? 0 : model.index + 1)
          }

          property Item leftNeighbour: getLeftNeighbour()
          property Item rightNeighbour: getRightNeighbour()

          Connections {
            target: queuedConnectionTimer
            onTriggered: {
              delegateRoot.leftNeighbour = delegateRoot.getLeftNeighbour()
              delegateRoot.rightNeighbour = delegateRoot.getRightNeighbour()
            }
          }

          KeyNavigation.left:  leftNeighbour
          KeyNavigation.right: rightNeighbour
          Keys.onEnterPressed: mouseArea.simulateMouseRelease()
          Keys.onReturnPressed: mouseArea.simulateMouseRelease()

          NumberAnimation on height {
            id: delegateRootIncreaseHeightAnim
            running: false
            to: delegateRoot.defaultHeight + detailsRect.maxHeight + 20
            duration: delegateRoot.dropDownAnimationDuration
          }

          NumberAnimation on height {
            id: delegateRootDecreaseHeightAnim
            running: false
            to: delegateRoot.defaultHeight
            duration: delegateRoot.dropDownAnimationDuration
          }

          DropArea {
            id: displaceDropArea

            property Item sourceObj: null
            property real sourceX: -1

            anchors {
              fill: parent
              topMargin: -50
              rightMargin: -50
            }

            onEntered: sourceObj = drag.source

            onExited: {
              displaceTimer.stop() // PositionChanged() cannot detect exit condition
              sourceObj = null
            }

            onPositionChanged: {
              if (drag.x > 50 || drag.y < 50) {
                sourceX = drag.x
                displaceTimer.start()
              } else {
                displaceTimer.stop()
              }
            }

            Timer {
              id: displaceTimer

              interval: 1000

              onTriggered: {
                if (model.index > displaceDropArea.sourceObj.index) {
                  homePageController_.move(displaceDropArea.sourceObj.index, model.index)
                } else if (model.index < displaceDropArea.sourceObj.index) {
                  if (displaceDropArea.sourceX < 50) {
                    homePageController_.move(displaceDropArea.sourceObj.index, model.index)
                  } else {
                    homePageController_.move(displaceDropArea.sourceObj.index, model.index + 1)
                  }
                }
              }
            }

            DropArea {
              id: dropArea

              anchors {
                fill: parent
                margins: 10
                topMargin: 60
                rightMargin: 60
              }

              property Item sourceObj: null

              Timer {
                id: makeGroupTimer
                interval: 1000
                onTriggered: {
                  if (dropArea.sourceObj.index !== model.index) {
                    if (model.type === CommonEnums.GroupItem) {
                      homePageController_.addToGroup(model.index, dropArea.sourceObj.index)
                    } else {
                      homePageController_.makeNewGroup(model.index, dropArea.sourceObj.index)
                    }
                  }
                }
              }

              onEntered: {
                sourceObj = drag.source
                makeGroupTimer.restart()
              }
              onExited: {
                makeGroupTimer.stop()
                sourceObj = null
              }
            }
          }

          Rectangle {
            id: delegateRect

            property int index: model.index

            opacity: mouseArea.drag.active ? .4 : 1
            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            NumberAnimation on scale {
              id: scaleUpAnim
              to: 1
              duration: 80
              running: false
              onStopped: mouseArea.simulateMouseRelease()
            }

            NumberAnimation on scale {
              id: scaleDownAnim
              to: .8
              duration: 80
              running: false
            }

            color: model.type === CommonEnums.GroupItem ? "#000000" : model.color

            anchors {
              top: parent.top
              left: parent.left
            }

            border {
              color: "black"
              width: delegateRoot.activeFocus ? 2 : 0
            }

            width: delegateRoot.width
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

              function simulateMouseRelease() {
                if (!wasDragged) {
                  if (model.type === CommonEnums.AppItem) {
                    if (!checkedAlreadyToggledByPress) {
                      // Make sure not to animate if in the same row
                      if (!checked && exclusiveGroup.current) {
                        if (Math.floor((mouseArea.index + 1) / gridView.columns) === Math.floor((exclusiveGroup.current.index + 1) / gridView.columns)) {
                          mouseArea.animateDropDown = false
                        }
                      }

                      checked = !checked
                      mouseArea.animateDropDown = true
                    } else {
                      checkedAlreadyToggledByPress = false
                    }

                    // ExclusiveGroup is lazy. Will keep the last one that was true even if all are currently false
                    if (!checked) {
                      exclusiveGroup.current = null
                    }
                  } else {
                    homePageController_.homePageModel = model.item
                  }
                } else {
                  moveTransition.enabled = false
                  queuedConnectionTimer.restart()
                  wasDragged = false
                }

                delegateRoot.focus = true
              }

              property bool checked: false
              property bool wasDragged: false
              property bool animateDropDown: true
              property bool checkedAlreadyToggledByPress: false

              property int index: model.index

              Component.onCompleted: {
                exclusiveGroup.bindCheckable(mouseArea)
              }

              // When others are dragged
              Connections {
                target: gridView
                onDragActive: {
                  mouseArea.checked = false
                }
              }

              drag.target: parent
              onPressed: {
                // Close drop-down immediately and not on mouse-release
                if (checked) {
                  checked = false
                  checkedAlreadyToggledByPress = true
                }

                scaleUpAnim.stop()
                scaleDownAnim.start()
              }
              onReleased: {
                scaleDownAnim.stop()
                scaleUpAnim.start()
              }

              drag.onActiveChanged: {
                if (drag.active) {
                  moveTransition.enabled = true
                  mouseArea.wasDragged = true
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
                duration: delegateRoot.dropDownAnimationDuration
              }

              NumberAnimation on height {
                id: animDecreaseHeight
                to: 10
                running: false
                duration: delegateRoot.dropDownAnimationDuration
              }

              property bool created: false
              Component.onCompleted: created = true

              onVisibleChanged: {
                if (created) {
                  animIncreaseHeight.complete()
                  animDecreaseHeight.complete()
                  delegateRootIncreaseHeightAnim.complete()
                  delegateRootDecreaseHeightAnim.complete()
                  if (visible) {
                    x = focusScopeRoot.mapToItem(delegateRect, 15, 0).x

                    animIncreaseHeight.start()
                    delegateRootIncreaseHeightAnim.start()

                    if (!mouseArea.animateDropDown) {
                      animIncreaseHeight.complete()
                      delegateRootIncreaseHeightAnim.complete()
                    }
                  }
                  else {
                    animDecreaseHeight.start()
                    delegateRootDecreaseHeightAnim.start()
                  }
                }
              }

              Connections {
                target: delegateRoot
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
                  text: model.type === CommonEnums.GroupItem ? "Group" : model.color
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.type === CommonEnums.GroupItem ? "Group" : model.prop0
                  color: "black"
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.type === CommonEnums.GroupItem ? "Group" : model.prop1
                  color: "red"
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.type === CommonEnums.GroupItem ? "Group" : model.prop2
                  color: "orange"
                }
                Text {
                  anchors.left: propCol.left
                  anchors.right: propCol.right
                  elide: Text.ElideMiddle
                  anchors.leftMargin: 10
                  text: model.type === CommonEnums.GroupItem ? "Group" : model.prop3
                  color: "steelblue"
                }
              }
            }
          }
        }
      }
    }
  }
}
