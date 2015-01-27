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
import AccountHandler 1.0

import "../../custom_components"

FocusScope {
  id: accountHandlerviewRoot
  objectName: ""

  width: childrenRect.width
  height: childrenRect.height

  Image {
    id: accountHandlerView
    objectName: "accountHandlerView"

    Component.onCompleted: {
      globalWindowResizeHelper.enabled = false
      mainWindow_.setWindowSize(implicitWidth, implicitHeight)
    }

    Component.onDestruction: globalWindowResizeHelper.enabled = true

    source: "/resources/images/login_bg.png"

    CustomText {
      id: placeHolderTextFirstLine
      objectName: "placeHolderTextFirstLine"

      anchors {
        horizontalCenter: parent.horizontalCenter; bottom: placeHolderTextSecondLine.top;
        bottomMargin: 5
      }

      font { pixelSize: 45 }
      text: qsTr("SAFE")
      z: 1
    }

    CustomText {
      id: placeHolderTextSecondLine
      objectName: "placeHolderTextSecondLine"

      anchors {
        horizontalCenter: parent.horizontalCenter; bottom: parent.bottom;
        bottomMargin: 375
      }

      font { pixelSize: 45; family: globalFontFamily.name }
      text: qsTr("App Launcher")
      z: 1
    }

    Loader {
      id: accountHandlerLoader
      objectName: "accountHandlerLoader"

      anchors.fill: parent
      source: accountHandlerController_.currentView === AccountHandlerController.CreateAccountView ?
                "CreateAccount.qml"
              :
                accountHandlerController_.currentView === AccountHandlerController.LoginView ?
                  "Login.qml"
                :
                  ""
      focus: true
      onLoaded: item.focus = true
    }
  }
}
