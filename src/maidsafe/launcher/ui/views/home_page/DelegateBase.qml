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

Rectangle {
  id: delegateBaseRoot

  property int index: model.index
  property int itemType: model.type

  property alias scaleUpAnim: scaleUpAnim
  property alias scaleDownAnim: scaleDownAnim
  property Grid gridView: null
  property Item gridViewDelegateRoot: null
  property ExclusiveGroup exclusiveGroup: null

  signal recalculateNeighbours()

  width: gridViewDelegateRoot.width
  height: width

  opacity: Drag.active ? .4 : 1
  Drag.hotSpot.x: width / 2
  Drag.hotSpot.y: height / 2

  NumberAnimation on scale {
    id: scaleUpAnim
    to: 1
    duration: 80
    running: false
  }

  NumberAnimation on scale {
    id: scaleDownAnim
    to: .8
    duration: 80
    running: false
  }

  border {
    color: "black"
    width: gridViewDelegateRoot.activeFocus ? 2 : 0
  }

  states: State {
    when: delegateBaseRoot.Drag.active
    ParentChange {
      target: delegateBaseRoot
      parent: mainWindowItem
    }
    AnchorChanges {
      target: delegateBaseRoot
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
}
