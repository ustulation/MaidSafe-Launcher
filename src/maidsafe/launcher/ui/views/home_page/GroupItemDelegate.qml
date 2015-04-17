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
  id: groupItemDelegateRoot

  function simulateMouseRelease() {
    clickableMouseArea.simulateMouseRelease()
  }

  // Otherwise DropArea will not recognize this drag
  Drag.active: clickableMouseArea.drag.active
  Drag.keys: ['' + CommonEnums.GroupItem]

  color: "#000000"

  MouseArea {
    id: clickableMouseArea

    anchors.fill: parent

    property int index: model.index
    property bool wasDragged: false

    drag.target: parent

    function simulateMouseRelease() {
      gridViewDelegateRoot.focus = true

      if (!wasDragged) {
        checked = true
        gridView.indexOfCurrentGroupInParentGroup.push(model.index)
        homePageController_.currentHomePageModel = model.item
      } else {
        gridView.move.enabled = false
        groupItemDelegateRoot.recalculateNeighbours()
        wasDragged = false
      }
    }

    // Only reason of this combo is to close drop-down elsewhere in app-item
    property bool checked: false
    Component.onCompleted: exclusiveGroup.bindCheckable(clickableMouseArea)

    Component.onDestruction: {
      // To cater for informing that this drag is no longer active
      if (drag.active) {
        gridView.someDragActive = false
        gridView.queuedDisableMoveTransition.start()
      }
    }

    onPressed: {
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
}
