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

import "../../../custom_components"

FocusScope {
  id: focusScopeRoot
  objectName: "focusScopeRoot"

  signal primaryFieldTabPressed()
  signal confirmationFieldTabPressed()

  property Item nextFocusItem: null
  property alias primaryTextField: primaryTextField
  property alias confirmationTextField: confirmationTextField
  property alias nextButton: nextButton
  property alias floatingStatus: statusDisplayRect

  function clearAllStatusImages() {
    primaryTextField.clearAllImages()
    confirmationTextField.clearAllImages()
  }

  width: textFieldsAndButtonColumn.implicitWidth
  height: textFieldsAndButtonColumn.implicitHeight

  FloatingStatusBox {
    id: statusDisplayRect
    objectName: "statusDisplayRect"

    anchors { left: textFieldsAndButtonColumn.right; leftMargin: 15 }
    pointToItem: primaryTextField
  }

  Column {
    id: textFieldsAndButtonColumn
    objectName: "textFieldsAndButtonColumn"

    spacing: globalProperties.textFieldVerticalSpacing

    CustomTextField {
      id: primaryTextField
      objectName: "primaryTextField"

      signal tabPressed()
      signal hello()

      anchors.horizontalCenter: parent.horizontalCenter
      echoMode: TextInput.Password
      focus: true
      Keys.onEnterPressed: nextButton.clicked()
      Keys.onReturnPressed: nextButton.clicked()
      Keys.onTabPressed: {
        focusScopeRoot.primaryFieldTabPressed()
        event.accepted = false
      }
      Keys.onBacktabPressed: {
        focusScopeRoot.primaryFieldTabPressed()
        event.accepted = false
      }
    }

    CustomTextField {
      id: confirmationTextField
      objectName: "confirmationTextField"

      signal tabPressed()

      anchors.horizontalCenter: parent.horizontalCenter
      echoMode: TextInput.Password
      Keys.onEnterPressed: nextButton.clicked()
      Keys.onReturnPressed: nextButton.clicked()
      Keys.onTabPressed: {
        focusScopeRoot.confirmationFieldTabPressed()
        event.accepted = false
      }
      Keys.onBacktabPressed: {
        focusScopeRoot.confirmationFieldTabPressed()
        event.accepted = false
      }
    }

    BlueButton {
      id: nextButton
      objectName: "nextButton"

      text: qsTr("Next")
      KeyNavigation.tab: nextFocusItem
    }
  }
}
