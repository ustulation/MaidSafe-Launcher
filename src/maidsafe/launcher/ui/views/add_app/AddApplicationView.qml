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
import QtGraphicalEffects 1.0
import QtQuick.Controls.Styles 1.3

import "./detail"
import "../../custom_components"

FocusScope {
  id: focusScopeRoot
  objectName: "focusScopeRoot"

  Brushes { id: globalBrushes;    objectName: "globalBrushes"    }

  Component.onCompleted: {
    mainWindow_.width = 800
    mainWindow_.minimumWidth = 800
    mainWindow_.maximumWidth = 10000

    mainWindow_.height = 600
    mainWindow_.minimumHeight = 600
    mainWindow_.maximumHeight = 10000
  }

  Rectangle {
    id: backgroundRect
    objectName: "backgroundRect"

    anchors.fill: parent
    color: globalBrushes.addAppPageBackground

    CustomText {
      id: pageTitle
      objectName: "pageTitle"

      anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        topMargin: 7
      }

      text: qsTr("SAFE App Launcher")
      color: "white"
      font.pixelSize: 13
    }
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
  }

  Rectangle {
    id: centerDisplayAreaRect
    objectName: "centerDisplayAreaRect"

    anchors{
      fill: parent
      topMargin: 73
      margins: 17
    }

    radius: 15
    antialiasing: true

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
      color: globalBrushes.buttonAddPageDefaultBlue

      CustomText {
        id: title
        objectName: "title"

        anchors {
          centerIn: parent
          verticalCenterOffset: -parent.height / 4
        }
        text: qsTr("Add")
        color: globalBrushes.addAppPageTitleTextColor
        font.pixelSize: globalProperties.addAppTitleTextSize
      }
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

    Loader {
      id: toggleAdvancedLoader
      objectName: "toggleAdvancedLoader"

      anchors.fill: parent
      sourceComponent: simpleViewComponent
    }

    Component {
      id: advancedViewComponent

      FocusScope {

        Rectangle {
          id: bottomLine

          anchors {
            left: parent.left
            right: parent.right
            leftMargin: 17
            rightMargin: 17
            bottom: parent.bottom
            bottomMargin: 92 - centerDisplayAreaRect.anchors.margins
          }

          color: "#b3b3b3"
          height: 1
        }

        BlueButton {
          id: blueButton

          anchors {
            right: parent.right
            rightMargin: 33
            bottom: parent.bottom
            bottomMargin: 23
          }

          text: qsTr("Save")
        }

        GreyButton {
          anchors {
            right: blueButton.left
            rightMargin: 17
            bottom: blueButton.bottom
          }
          text: qsTr("Cancel")
        }

        CustomText {
          anchors {
            top: textArea0.top
            topMargin: 10
            right: textArea0.left
            rightMargin: 10
          }

          text: qsTr("Command Line Arguments :")
          font.pixelSize: 13
          color:  "#4d4d4d"
        }

        TextArea {
          id: textArea0
          anchors {
            bottom: bottomLine.top
            bottomMargin: 20
            right: blueButton.right
          }

          width: 510
          height: 85

          backgroundVisible: false
          style: TextAreaStyle {
            transientScrollBars: true
            textColor: "black"
            font {pixelSize: 30}
            frame: Rectangle {
              radius: 5
              border {
                color: "#b3b3b3"
                width: 1
              }

              implicitHeight: 35
              color: "transparent"
            }
          }
        }

        CustomText {
          anchors {
            top: textArea1.top
            topMargin: 10
            right: textArea1.left
            rightMargin: 10
          }

          text: qsTr("App Name :")
          font.pixelSize: 13
          color:  "#4d4d4d"
        }

        TextArea {
          id: textArea1
          anchors {
            bottom: textArea0.top
            bottomMargin: 20
            right: textArea0.right
            left: textArea0.left
          }

          height: 35

          backgroundVisible: false
          style: TextAreaStyle {
            transientScrollBars: true
            textColor: "black"
            font {pixelSize: 13}
            frame: Rectangle {
              radius: 5
              border {
                color: "#b3b3b3"
                width: 1
              }

              implicitHeight: 35
              color: "transparent"
            }
          }
        }

        Rectangle {
          id: topLine

          anchors {
            left: parent.left
            right: parent.right
            leftMargin: 17
            rightMargin: 17
            bottom: textArea1.top
            bottomMargin: 20
          }

          color: "#b3b3b3"
          height: 1
        }

      }
    }

    Component {
      id: simpleViewComponent

      FocusScope {

        CustomText {
          id: informationText
          objectName: "informationText"

          anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: questionText.top
          }

          color: globalBrushes.addAppPageCenterAreaTextColor
          font.pixelSize: globalProperties.addAppCenterAreaTextSize
          text: qsTr("This app will have access to its own private data on the network.")
        }

        CustomText {
          id: questionText
          objectName: "questionText"

          anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 220 - centerDisplayAreaRect.anchors.margins
          }

          color: globalBrushes.addAppPageCenterAreaTextColor
          font.pixelSize: globalProperties.addAppCenterAreaTextSize
          text: qsTr("Would you also like to give it access to all your data in your SAFE Drive?")
        }

        Row {
          id: radioButtonrow
          objectName: "radioButtonrow"

          anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 174 - centerDisplayAreaRect.anchors.margins
          }

          spacing: 50

          ExclusiveGroup {
            id: yesNoExclusiveGroup
            objectName: "yesNoExclusiveGroup"
          }

          RadioButton {
            id: yesRadioButton
            objectName: "yesRadioButton"

            text: qsTr("Yes")
            exclusiveGroup: yesNoExclusiveGroup

            style: RadioButtonStyle {
              indicator: Rectangle {
                //           id: indicatorBackgroundRect
                //           objectName: "indicatorBackgroundRect"

                implicitWidth: 15
                implicitHeight: 15
                radius: implicitWidth / 2

                border {
                  width: 2
                  color: globalBrushes.addAppPageCenterAreaTextColor
                }
                color: "transparent"
                antialiasing: true

                Rectangle {
                  //             id: selectedIndicatorRect
                  //             objectName: "selectedIndicatorRect"

                  anchors {
                    fill: parent
                    margins: 4
                  }

                  visible: control.checked
                  color: globalBrushes.addAppPageCenterAreaTextColor
                  radius: width / 2
                  antialiasing: true
                }
              }

              label: CustomLabel {
                color: globalBrushes.addAppPageCenterAreaTextColor
                font.pixelSize: globalProperties.addAppCenterAreaTextSize
                text: qsTr("Yes")
              }
            }
          }

          RadioButton {
            id: noRadioButton
            objectName: "noRadioButton"

            text: qsTr("No")
            checked: true
            exclusiveGroup: yesNoExclusiveGroup

            style: RadioButtonStyle {
              indicator: Rectangle {
                //           id: indicatorBackgroundRect
                //           objectName: "indicatorBackgroundRect"

                implicitWidth: 15
                implicitHeight: 15
                radius: implicitWidth / 2

                border {
                  width: 2
                  color: globalBrushes.addAppPageCenterAreaTextColor
                }
                color: "transparent"
                antialiasing: true

                Rectangle {
                  //             id: selectedIndicatorRect
                  //             objectName: "selectedIndicatorRect"

                  anchors {
                    fill: parent
                    margins: 4
                  }

                  visible: control.checked
                  color: globalBrushes.addAppPageCenterAreaTextColor
                  radius: width / 2
                  antialiasing: true
                }
              }

              label: CustomLabel {
                color: globalBrushes.addAppPageCenterAreaTextColor
                font.pixelSize: globalProperties.addAppCenterAreaTextSize
                text: qsTr("No")
              }

              spacing: 10
            }
          }
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

        ClickableText {
          id: advancedOptionsLabel
          objectName: "advancedOptionsLabel"

          anchors {
            left: parent.left
            leftMargin: 43 - centerDisplayAreaRect.anchors.margins
            bottom: parent.bottom
            bottomMargin: 43 - centerDisplayAreaRect.anchors.margins
          }

          label {
            text: qsTr("Advanced options")
            color: globalBrushes.addAppPageCenterAreaTextColor
            font.pixelSize: globalProperties.addAppCenterAreaTextSize
          }

          onClicked: {
            toggleAdvancedLoader.sourceComponent = advancedViewComponent
            title.text = qsTr("Advanced Options")
          }
        }
      }
    }
  }
}
