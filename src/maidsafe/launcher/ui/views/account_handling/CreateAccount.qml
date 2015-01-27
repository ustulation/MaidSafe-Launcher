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

import "./detail"
import "../../custom_components"

FocusScope {
  id: createAccountRoot
  objectName: "createAccountRoot"

  Row {
    id: createAccountTabRow
    objectName: "createAccountTabRow"

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: userInputLoader.top; bottomMargin: globalProperties.textFieldHeight
    }

    spacing: 15

    Repeater {
      id: tabRepeater
      objectName: "tabRepeater"

      property int currentTabIndex: 0

      model: [qsTr("PIN"), qsTr("Keyword"), qsTr("Password")]

      delegate: CustomLabel {
        id: tabLabel
        objectName: "tabLabel"

        text: modelData
        color: model.index === tabRepeater.currentTabIndex ?
                 globalBrushes.labelSelected
               :
                 globalBrushes.labelNotSelected
      }
    }
  }

  Loader {
    id: userInputLoader
    objectName: "userInputLoader"

    property string pin: ""
    property string keyword: ""

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: parent.bottom; bottomMargin: globalProperties.createAccountNextButtonBottomMargin
    }

    focus: true
    sourceComponent: acceptPINComponent
    onLoaded: { item.nextFocusItem = showLoginPageLabel; item.focus = true }
  }

  Component {
    id: acceptPINComponent

    CreateAccountUserInputColumn {
      id: textFieldsAndButtonColumn
      objectName: "textFieldsAndButtonColumn"

      primaryTextField.placeholderText: qsTr("Choose a 4 digit PIN")
      confirmationTextField.placeholderText: qsTr("Confirm PIN")

      onPrimaryFieldTabPressed: {
        if (primaryTextField.text !== "") { primaryTextField.showTickImage = true }
      }
      onConfirmationFieldTabPressed: {
        if (confirmationTextField.text !== "") { confirmationTextField.showTickImage = true }
      }

      primaryTextField.onTextChanged: {
        if (floatingStatus.visible && floatingStatus.pointToItem === primaryTextField) {
          floatingStatus.visible = false
        }
      }
      confirmationTextField.onTextChanged: {
        if (floatingStatus.visible && floatingStatus.pointToItem === confirmationTextField) {
          floatingStatus.visible = false
        }
      }

      nextButton.onClicked: {
        floatingStatus.visible = false
        clearAllStatusImages()
        if (!primaryTextField.text.match(/^\d{4}$/)) {
          primaryTextField.showErrorImage = true
          floatingStatus.infoText.text = qsTr("PIN must be only and exactly 4 digits")
          floatingStatus.infoText.color = "#ff0000"
          floatingStatus.pointToItem = primaryTextField
          floatingStatus.visible = true
        }
        else if (primaryTextField.text !== confirmationTextField.text) {
          confirmationTextField.showErrorImage = true
          floatingStatus.infoText.text = qsTr("Entries don't match")
          floatingStatus.pointToItem = confirmationTextField
          floatingStatus.visible = true
        }
        else {
          userInputLoader.pin = primaryTextField.text
          userInputLoader.sourceComponent = acceptKeywordComponent
          ++tabRepeater.currentTabIndex
        }
      }
    }
  }

  Component {
    id: acceptKeywordComponent

    CreateAccountUserInputColumn {
      id: textFieldsAndButtonColumn
      objectName: "textFieldsAndButtonColumn"

      primaryTextField.placeholderText: qsTr("Choose a Keyword")
      confirmationTextField.placeholderText: qsTr("Confirm Keyword")

      onPrimaryFieldTabPressed: {
        if (primaryTextField.text !== "") { primaryTextField.showTickImage = true }
      }
      onConfirmationFieldTabPressed: {
        if (confirmationTextField.text !== "") { confirmationTextField.showTickImage = true }
      }

      primaryTextField.onTextChanged: {
        if (floatingStatus.visible && floatingStatus.pointToItem === primaryTextField) {
          floatingStatus.visible = false
        }
      }
      confirmationTextField.onTextChanged: {
        if (floatingStatus.visible && floatingStatus.pointToItem === confirmationTextField) {
          floatingStatus.visible = false
        }
      }

      nextButton.onClicked: {
        floatingStatus.visible = false
        clearAllStatusImages()
        if (primaryTextField.text === "") {
          primaryTextField.showErrorImage = true
          floatingStatus.infoText.text = qsTr("Keyword cannot be left blank")
          floatingStatus.infoText.color = "#ff0000"
          floatingStatus.pointToItem = primaryTextField
          floatingStatus.visible = true
        }
        else if (primaryTextField.text !== confirmationTextField.text) {
          confirmationTextField.showErrorImage = true
          floatingStatus.infoText.text = qsTr("Entries don't match")
          floatingStatus.pointToItem = confirmationTextField
          floatingStatus.visible = true
        }
        else {
          userInputLoader.keyword = primaryTextField.text
          userInputLoader.sourceComponent = acceptPasswordComponent
          ++tabRepeater.currentTabIndex
        }
      }
    }
  }

  Component {
    id: acceptPasswordComponent

    CreateAccountUserInputColumn {
      id: textFieldsAndButtonColumn
      objectName: "textFieldsAndButtonColumn"

      primaryTextField.placeholderText: qsTr("Choose a Password")
      confirmationTextField.placeholderText: qsTr("Confirm Password")

      onPrimaryFieldTabPressed: {
        if (primaryTextField.text !== "") { primaryTextField.showTickImage = true }
      }
      onConfirmationFieldTabPressed: {
        if (confirmationTextField.text !== "") { confirmationTextField.showTickImage = true }
      }

      primaryTextField.onTextChanged: {
        if (floatingStatus.visible && floatingStatus.pointToItem === primaryTextField) {
          floatingStatus.visible = false
        }
      }
      confirmationTextField.onTextChanged: {
        if (floatingStatus.visible && floatingStatus.pointToItem === confirmationTextField) {
          floatingStatus.visible = false
        }
      }

      nextButton.onClicked: {
        floatingStatus.visible = false
        clearAllStatusImages()
        if (primaryTextField.text === "") {
          primaryTextField.showErrorImage = true
          floatingStatus.infoText.text = qsTr("Password cannot be left blank")
          floatingStatus.infoText.color = "#ff0000"
          floatingStatus.pointToItem = primaryTextField
          floatingStatus.visible = true
        }
        else if (primaryTextField.text !== confirmationTextField.text) {
          confirmationTextField.showErrorImage = true
          floatingStatus.infoText.text = qsTr("Entries don't match")
          floatingStatus.pointToItem = confirmationTextField
          floatingStatus.visible = true
        }
        else {
          accountHandlerController_.createAccount(userInputLoader.pin, userInputLoader.keyword,
                                                  primaryTextField.text)
        }
      }
    }
  }

  ClickableText {
    id: showLoginPageLabel
    objectName: "showLoginPageLabel"

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: parent.bottom; bottomMargin: globalProperties.accountHandlerClickableTextBottomMargin
    }

    label.text: qsTr("Already have an account? Log In")
    onClicked: accountHandlerController_.showLoginView()
  }
}
