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

DropArea {
  id: homePageGridViewRoot

//  anchors.fill: parent

  Component.onCompleted: {
    mainWindow_.width = 800
    mainWindow_.minimumWidth = 80
    mainWindow_.maximumWidth = 10000

    mainWindow_.height = 600
    mainWindow_.minimumHeight = 60
    mainWindow_.maximumHeight = 10000
  }

  onEntered: {
    if (drag.source.index !== gridRepeater.count - 1) {
      // If it leaves into the wilderness shift everything beyond it to its place
      homePageController_.move(drag.source.index, gridRepeater.count - 1)
    }
  }

  Timer {
    id: queuedConnectionTimer
    interval: 0
  }

  ExclusiveGroup {
    id: exclusiveGroupHomePage
  }

  Grid {
    id: gridViewHomePage

    readonly property int delegateWidth: 50

    signal someDragActive()

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

      width: gridViewHomePage.delegateWidth
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
          if (homePageController_.homePageModel.parentGroup === null) {
            fileDialog.open()
          } else {
            homePageController_.homePageModel = homePageController_.homePageModel.parentGroup
          }
        }
      }
    }

    Repeater {
      id: gridRepeater

      model: homePageController_.homePageModel

      onCountChanged: queuedConnectionTimer.restart()

      delegate: FocusScope {
        id: gridViewHomePageDelegateRoot

        readonly property int defaultHeight: gridViewHomePage.delegateWidth

        property Item leftNeighbour: getLeftNeighbour()
        property Item rightNeighbour: getRightNeighbour()

        signal enterPressed()
        signal returnPressed()

        focus: true

        width: gridViewHomePage.delegateWidth
        height: defaultHeight

        function getLeftNeighbour() {
          return gridRepeater.itemAt(model.index ? model.index - 1 : gridRepeater.count - 1)
        }
        function getRightNeighbour() {
          return gridRepeater.itemAt(model.index + 1 >= gridRepeater.count ? 0 : model.index + 1)
        }

        Connections {
          target: queuedConnectionTimer
          onTriggered: {
            gridViewHomePageDelegateRoot.leftNeighbour = gridViewHomePageDelegateRoot.getLeftNeighbour()
            gridViewHomePageDelegateRoot.rightNeighbour = gridViewHomePageDelegateRoot.getRightNeighbour()
          }
        }

        KeyNavigation.left:  leftNeighbour
        KeyNavigation.right: rightNeighbour
        Keys.onEnterPressed: enterPressed()
        Keys.onReturnPressed: returnPressed()

        DropArea {
          id: displaceDropArea

          property Item sourceObj: null
          property real sourceX: -1

          anchors {
            fill: parent
            topMargin: -gridViewHomePage.spacing
            rightMargin: -gridViewHomePage.spacing
          }

          onEntered: sourceObj = drag.source

          onExited: {
            // PositionChanged() cannot detect exit condition
            displaceTimer.stop()
            sourceObj = null
          }

          onPositionChanged: {
            if (drag.x > gridViewHomePageDelegateRoot.width || drag.y < gridViewHomePage.spacing) {
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
                if (displaceDropArea.sourceX < gridViewHomePageDelegateRoot.width) {
                  homePageController_.move(displaceDropArea.sourceObj.index, model.index)
                } else {
                  homePageController_.move(displaceDropArea.sourceObj.index, model.index + 1)
                }
              }
            }
          }

          DropArea {
            id: grouperDropArea

            property Item sourceObj: null

            anchors {
              fill: parent
              margins: 10
              topMargin: gridViewHomePage.spacing
              rightMargin: gridViewHomePage.spacing
            }

            keys: ['' + CommonEnums.AppItem]

            Timer {
              id: makeGroupTimer

              interval: 1000

              onTriggered: {
                if (grouperDropArea.sourceObj.index !== model.index) {
                  if (model.type === CommonEnums.GroupItem) {
                    // Necessary to call this, else removing and item whose drag is active deactivates
                    // this drop area permanently
                    grouperDropArea.sourceObj.Drag.drop()
                    homePageController_.addToGroup(model.index, grouperDropArea.sourceObj.index)
                  } else {
                    homePageController_.makeNewGroup(model.index, grouperDropArea.sourceObj.index)
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

        Loader {
          id: itemLoader

          anchors.fill: parent

          sourceComponent: {
            if (model.type === CommonEnums.GroupItem) {
              groupItemComponent
            } else if (model.type === CommonEnums.AppItem) {
              appItemComponent
            } else {
              undefined
            }
          }
        }

        Component {
          id: appItemComponent

          Item {
            id: containerItemToEnableChildDrag

            AppItemDelegate {
              id: appItem

              anchors {
                top: parent.top
                left: parent.left
              }

              animationDuration: 50
              maxDropDownHeight: 125
              gridView: gridViewHomePage
              exclusiveGroup: exclusiveGroupHomePage
              gridViewDelegateRoot: gridViewHomePageDelegateRoot
              rootItemForMappingDropDown: homePageGridViewRoot
              gridViewDelegateRootDefaultHeight: gridViewHomePageDelegateRoot.defaultHeight

              onRecalculateNeighbours: queuedConnectionTimer.restart()

              Connections {
                target: gridViewHomePageDelegateRoot
                onEnterPressed: appItem.simulateMouseRelease()
              }
              Connections {
                target: gridViewHomePageDelegateRoot
                onReturnPressed: appItem.simulateMouseRelease()
              }
            }
          }
        }

        Component {
          id: groupItemComponent

          Item {
            id: containerItemToEnableChildDrag

            GroupItemDelegate {
              id: groupItem

              anchors {
                top: parent.top
                left: parent.left
              }

              gridView: gridViewHomePage
              exclusiveGroup: exclusiveGroupHomePage
              gridViewDelegateRoot: gridViewHomePageDelegateRoot

              onRecalculateNeighbours: queuedConnectionTimer.restart()

              Connections {
                target: gridViewHomePageDelegateRoot
                onEnterPressed: groupItem.simulateMouseRelease()
              }
              Connections {
                target: gridViewHomePageDelegateRoot
                onReturnPressed: groupItem.simulateMouseRelease()
              }
            }
          }
        }
      }
    }
  }
}
