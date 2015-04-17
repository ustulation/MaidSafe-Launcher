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

Item {
  id: dropDownRootItem

  property bool animateDropDown: true
  property Item gridViewDelegateRoot: null
  property Item rootItemForMappingDropDown: null
  property Item rootItemForOwningDropDown: null

  property int maxDropDownHeight: -1
  property int animationDuration: 0
  property int gridViewDelegateRootDefaultHeight: 0

  readonly property int lineWidths: 2
  readonly property int horizontalMarginsForDropDown: 15

  Rectangle {
    id: arrowrect

    anchors {
      top: parent.top
      horizontalCenter: parent.horizontalCenter
    }

    width: 15
    height: width

    rotation: 45

    color: "transparent"
    border {
      color: "grey"
      width: dropDownRootItem.lineWidths
    }

    visible: dropDownRect.visible
  }

  Rectangle {
    id: topLineRectLeft

    anchors {
      top: dropDownRect.top
      topMargin: -height
      left: dropDownRect.left
      right: arrowrect.left
      rightMargin: (Math.sqrt(2) * arrowrect.width - arrowrect.width) / 2.0 - dropDownRootItem.lineWidths
    }

    height: dropDownRootItem.lineWidths
    color: "grey"
    z:1
  }

  Rectangle {
    id: topLineRectRight

    anchors {
      top: dropDownRect.top
      topMargin: -height
      left: arrowrect.right
      leftMargin: (Math.sqrt(2) * arrowrect.width - arrowrect.width) / 2.0 - dropDownRootItem.lineWidths
      right: dropDownRect.right
    }

    height: dropDownRootItem.lineWidths
    color: "grey"
    z: 1
  }

  Rectangle {
    id: dropDownRect

    anchors {
      top: arrowrect.top
      topMargin: arrowrect.height / 2
    }

    property bool created: false

    readonly property int minHeight: arrowrect.height / 2

    height: minHeight
    width: rootItemForMappingDropDown.width -
           dropDownRootItem.horizontalMarginsForDropDown * 2

    Component.onCompleted: created = true

    NumberAnimation on height {
      id: animIncreaseHeight

      duration: dropDownRootItem.animationDuration
      running: false
      to: dropDownRootItem.maxDropDownHeight
    }

    NumberAnimation on height {
      id: animDecreaseHeight

      duration: dropDownRootItem.animationDuration
      running: false
      to: dropDownRect.minHeight
    }

    NumberAnimation {
      id: gridViewDelegateRootIncHeightAnim

      target: gridViewDelegateRoot
      property: "height"
      duration: dropDownRootItem.animationDuration

      running: false
      to: gridViewDelegateRootDefaultHeight + dropDownRootItem.maxDropDownHeight + 20
    }

    NumberAnimation {
      id: gridViewDelegateRootDecHeightAnim

      target: gridViewDelegateRoot
      property: "height"
      duration: dropDownRootItem.animationDuration

      running: false
      to: gridViewDelegateRootDefaultHeight
    }

    onVisibleChanged: {
      if (created) {
        animIncreaseHeight.stop()
        animDecreaseHeight.stop()
        gridViewDelegateRootIncHeightAnim.stop()
        gridViewDelegateRootDecHeightAnim.stop()

        if (visible) {
          x = rootItemForMappingDropDown.mapToItem(dropDownRootItem,
                                                   dropDownRootItem.horizontalMarginsForDropDown,
                                                   0).x

          // Let animations handle final heights even if animations are not to be run
          animIncreaseHeight.start()
          gridViewDelegateRootIncHeightAnim.start()

          if (!dropDownRootItem.animateDropDown) {
            animIncreaseHeight.complete()
            gridViewDelegateRootIncHeightAnim.complete()
          }
        }
        else {
          animDecreaseHeight.start()
          gridViewDelegateRootDecHeightAnim.start()
        }
      }
    }

    Connections {
      target: gridViewDelegateRoot
      onXChanged: dropDownRect.x = rootItemForMappingDropDown.mapToItem(dropDownRootItem,
                                                                        dropDownRootItem.horizontalMarginsForDropDown,
                                                                        0).x
    }

    Column {
      id: dropDownCol

      anchors {
        margins: 3
        fill: parent
      }

      spacing: 3
      clip: true

      Text {
        anchors.leftMargin: 10
        anchors.left: dropDownCol.left
        anchors.right: dropDownCol.right
        elide: Text.ElideMiddle
        text: model.name
        color: "blue"
      }
      Text {
        color: "green"
        anchors.left: dropDownCol.left
        anchors.right: dropDownCol.right
        elide: Text.ElideMiddle
        anchors.leftMargin: 10
        text: model.color
      }
      Text {
        anchors.left: dropDownCol.left
        anchors.right: dropDownCol.right
        elide: Text.ElideMiddle
        anchors.leftMargin: 10
        text: model.prop0
        color: "black"
      }
      Text {
        anchors.left: dropDownCol.left
        anchors.right: dropDownCol.right
        elide: Text.ElideMiddle
        anchors.leftMargin: 10
        text: model.prop1
        color: "red"
      }
      Text {
        anchors.left: dropDownCol.left
        anchors.right: dropDownCol.right
        elide: Text.ElideMiddle
        anchors.leftMargin: 10
        text: model.prop2
        color: "orange"
      }
      Text {
        anchors.left: dropDownCol.left
        anchors.right: dropDownCol.right
        elide: Text.ElideMiddle
        anchors.leftMargin: 10
        text: model.prop3
        color: "steelblue"
      }
    }
  }
}
