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
import QtGraphicalEffects 1.0

import "./detail"
import "../../custom_components"

FocusScope {
  id: focusScopeRoot
  objectName: "focusScopeRoot"

  Component.onCompleted: {
    mainWindow_.width = 800
    mainWindow_.minimumWidth = 0
    mainWindow_.maximumWidth = 10000

    mainWindow_.height = 600
    mainWindow_.minimumHeight = 0
    mainWindow_.maximumHeight = 10000
  }

  Rectangle {
    id: backgroundRect
    objectName: "backgroundRect"

    anchors.fill: parent
    color: globalBrushes.addAppPageBackground
  }

  Item {
    id: contentArea
    objectName: "contentArea"

    anchors{
      fill: parent
      topMargin: 37
      margins: 17
    }

    SearchField {
      id: searchField
      objectName: "searchField"

      textField { placeholderText: qsTr("Search") }

      focus: true

      anchors {
        top: parent.top
        left: parent.left
      }
    }

    Rectangle {
      id: centerDisplayAreaRect
      objectName: "centerDisplayAreaRect"

      anchors {
        top: searchField.bottom
        topMargin: 17
        left: parent.left
        right: parent.right
        bottom: parent.bottom
      }

      radius: 15

      Rectangle {
        id: topBlueBarRect
        objectName: "topBlueBarRect"

        anchors {
          left: parent.left
          right: parent.right
          top: parent.top
        }

        radius: parent.radius
        height: 35
        color: "#6060ff"
      }

      Rectangle {
        id: cover
        objectName: "cover"

        anchors {
          top: parent.top
          topMargin: 20
          left: parent.left
          right: parent.right
        }

        color: parent.color
        height: 15
      }

      BlueButton {
        id: blueButton
        anchors {
          right: parent.right
          rightMargin: 33
          bottom: parent.bottom
          bottomMargin: 23
        }

        text: qsTr("Add")
      }

      GreyButton {
        anchors {
          right: blueButton.left
          rightMargin: 17
          bottom: blueButton.bottom
        }
        text: qsTr("Cancel")
      }
    }
  }
}
