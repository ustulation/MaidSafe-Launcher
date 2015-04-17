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
  id: addAppRoot

  property Grid gridView: null

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  FileDialog {
    id: fileDialog
    onAccepted: homePageController_.addAppFromUrl(fileUrl)
  }

  Rectangle {
    id: addAppImage

    width: gridView.delegateWidth
    height: width
    radius: width / 2

    gradient: Gradient {
      GradientStop { position: 0.0; color: "#606060" }
      GradientStop { position: 1.0; color: "#303030" }
    }

    border {
      color: "green"
      width: addAppRoot.activeFocus ? 2 : 0
    }

    Text {
      anchors.centerIn: parent
      text: qsTr("ADD")
      color: "white"
    }

    MouseArea {
      id: addAppMouseArea

      anchors.fill: parent
      onClicked: fileDialog.open()
    }
  }

//  Image {
//    id: addAppImage

//    source: ""

//    MouseArea {
//      id: addAppMouseArea
//      addAppRoot.focus = true
//      anchors.fill: parent
//      onClicked: fileDialog.open()
//    }
//  }
}
