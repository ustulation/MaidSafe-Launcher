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
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

import "../../custom_components"

Item {
  id: createAccountItem
  objectName: "createAccountItem"

  QtObject {
    id: dPtr
    objectName: "dPtr"

    readonly property var tabModel: [qsTr("PIN"), qsTr("Keyword"), qsTr("Password")]

    property int currentTabIndex: 0
    property string pin: ""
    property string keyword: ""
    property string password: ""

    onCurrentTabIndexChanged: {
      if(currentTabIndex >= tabModel.length) {
        currentTabIndex = currentTabIndex % tabModel.length
        accountHandlerController_.login(pin, keyword, password)
      }
    }
  }

  Row {
    id: createAccountTabRow
    objectName: "createAccountTabRow"

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: textFieldsAndButtonColumn.top; bottomMargin: globalProperties.textFieldHeight
    }

    spacing: 15

    Repeater {
      id: tabRepeater
      objectName: "tabRepeater"

      model: dPtr.tabModel

      delegate: CustomLabel {
        id: tabLabel
        objectName: "tabLabel"

        text: modelData
        color: model.index === dPtr.currentTabIndex ?
                 globalBrushes.labelSelected
               :
                 globalBrushes.labelNotSelected
      }
    }
  }

  Column {
    id: textFieldsAndButtonColumn
    objectName: "textFieldsAndButtonColumn"

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: parent.bottom; bottomMargin: globalProperties.createAccountBottomMargin
    }

    spacing: globalProperties.textFieldVerticalSpacing

    CustomTextField {
      id: textFld0
      objectName: "textFld0"

      anchors.horizontalCenter: parent.horizontalCenter
      placeholderText: "Place holder text"
      echoMode: TextInput.Password
    }

    CustomTextField {
      id: textFld1
      objectName: "textFld1"

      anchors.horizontalCenter: parent.horizontalCenter
      placeholderText: "Place holder text"
    }

    BlueButton {
      id: nextButton
      objectName: "nextButton"

      text: qsTr("Next")
      onClicked: ++dPtr.currentTabIndex
    }
  }

  ClickableText {
    id: showLoginPageLabel
    objectName: "showLoginPageLabel"

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: parent.bottom; bottomMargin: globalProperties.bottomMargin
    }

    label.text: qsTr("Already have an account? Log In")
    onClicked: accountHandlerController_.showLoginView()
  }
}
