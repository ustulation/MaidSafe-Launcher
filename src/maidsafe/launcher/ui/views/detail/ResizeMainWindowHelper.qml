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

Item {
  id: resizeMainWindowItem
  objectName: "resizeMainWindowItem"

  readonly property int resizerSize: 5

  MouseArea {
    id: resizeRightMouseArea
    objectName: "resizeRightMouseArea"

    property real prevMouseX

    anchors {
      right: parent.right; top: parent.top; bottom: parent.bottom
      topMargin: resizeMainWindowItem.resizerSize; bottomMargin: resizeMainWindowItem.resizerSize
    }
    width: resizeMainWindowItem.resizerSize

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onEntered: { cursorShape = Qt.SizeHorCursor }
    onExited:  { cursorShape = Qt.ArrowCursor }
    onPressed: { prevMouseX = mouseX }
    onPositionChanged: {
      if(pressed) {
        mainWindow_.changeWindowSize(mouseX - prevMouseX, 0)
      }
    }
  }

  MouseArea {
    id: resizeAllMouseArea
    objectName: "resizeAllMouseArea"

    property real prevMouseX
    property real prevMouseY

    anchors { right: parent.right; bottom: parent.bottom }
    width: resizeMainWindowItem.resizerSize
    height: resizeMainWindowItem.resizerSize

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onEntered: { cursorShape = Qt.SizeAllCursor }
    onExited:  { cursorShape = Qt.ArrowCursor }
    onPressed: { prevMouseX = mouseX; prevMouseY = mouseY }
    onPositionChanged: {
      if(pressed) {
        mainWindow_.changeWindowSize(mouseX - prevMouseX, mouseY - prevMouseY)
      }
    }
  }

  MouseArea {
    id: resizeDownMouseArea
    objectName: "resizeDownMouseArea"

    property real prevMouseY

    anchors {
      right: parent.right; left: parent.left; bottom: parent.bottom
      leftMargin: resizeMainWindowItem.resizerSize; rightMargin: resizeMainWindowItem.resizerSize
    }
    height: resizeMainWindowItem.resizerSize

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton
    onEntered: { cursorShape = Qt.SizeVerCursor }
    onExited:  { cursorShape = Qt.ArrowCursor }
    onPressed: { prevMouseY = mouseY }
    onPositionChanged: {
      if(pressed) {
        mainWindow_.changeWindowSize(0, mouseY - prevMouseY)
      }
    }
  }
}
