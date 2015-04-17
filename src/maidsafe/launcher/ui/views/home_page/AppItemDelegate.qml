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

DelegateBase {
  id: appItemDelegateRoot

  property alias rootItemForMappingDropDown: dropDown.rootItemForMappingDropDown
  property alias maxDropDownHeight: dropDown.maxDropDownHeight
  property alias animationDuration: dropDown.animationDuration
  property alias gridViewDelegateRootDefaultHeight: dropDown.gridViewDelegateRootDefaultHeight

  function simulateMouseRelease() {
    clickableMouseArea.simulateMouseRelease()
  }

  // Otherwise DropArea will not recognize this drag
  Drag.active: clickableMouseArea.drag.active
  Drag.keys: ['' + CommonEnums.AppItem]

  color: model.color

  MouseArea {
    id: clickableMouseArea

    anchors.fill: parent

    property int index: model.index
    property bool checked: false
    property bool wasDragged: false
    property bool checkedAlreadyToggledByPress: false

    drag.target: parent

    function simulateMouseRelease() {
      if (!wasDragged) {
        if (!checkedAlreadyToggledByPress) {
          // Make sure not to animate if in the same row and opening drop-down (ie., checked = true)
          dropDown.animateDropDown =
              checked ||
              exclusiveGroup.current === null ||
              Math.floor((clickableMouseArea.index + 1) / gridView.columns) !==
              Math.floor((exclusiveGroup.current.index + 1) / gridView.columns)

          checked = !checked
          dropDown.animateDropDown = true
        } else {
          checkedAlreadyToggledByPress = false
        }

        // ExclusiveGroup is lazy. Will keep the last one that was true even if all are currently false
        if (!checked) {
          exclusiveGroup.current = null
        }
      } else {
        gridView.move.enabled = false
        appItemDelegateRoot.recalculateNeighbours()
        wasDragged = false
      }

      gridViewDelegateRoot.focus = true
    }

    Component.onCompleted: exclusiveGroup.bindCheckable(clickableMouseArea)
    Component.onDestruction: {
      // To cater for informing that this drag is no longer active
      if (drag.active) {
        gridView.someDragActive = false
        gridView.queuedDisableMoveTransition.restart()
      }
    }

    // When others are dragged
    Connections {
      target: gridView
      onSomeDragActiveChanged: {
        if (gridView.someDragActive) {
          clickableMouseArea.checked = false
        }
      }
    }

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

    Connections {
      target: scaleUpAnim
      onStopped: clickableMouseArea.simulateMouseRelease()
    }

    drag.onActiveChanged: {
      if (drag.active) {
        gridView.move.enabled = true
        clickableMouseArea.wasDragged = true
      }
      gridView.someDragActive = drag.active
    }
  }

  AppItemDropDown {
    id: dropDown

    anchors {
      top: parent.bottom
      topMargin: 10
      horizontalCenter: parent.horizontalCenter
    }

    visible: clickableMouseArea.checked
    gridViewDelegateRoot: appItemDelegateRoot.gridViewDelegateRoot
    rootItemForOwningDropDown: parent
  }
}
