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

FocusScope {
  id: focusScopeRoot
  objectName: "focusScopeRoot"

  property bool closeVisble: true
  property bool closeEnabled: true

  property bool minimiseVisble: true
  property bool minimiseEnabled: true

  property bool maximiseRestorVisble: true
  property bool maximiseRestorEnabled: true

  readonly property real buttonLoaderwidth: buttonLoader.implicitWidth

  height: childrenRect.height

  Loader {
    id: buttonLoader
    objectName: "buttonLoader"

    anchors {
      top: parent.top
      left: Qt.platform.os === "linux" || Qt.platform.os === "osx" ? parent.left : undefined
      right: Qt.platform.os === "windows" ? parent.right : undefined
    }

    sourceComponent: Qt.platform.os === "linux" ?
                       linuxButtonsComponent
                     :
                       Qt.platform.os === "windows" ?
                         windowsButtonsComponent
                       :
                         null
  }

  Component {
    id: windowsButtonsComponent

    Row {
      id: windowsButtonsRow
      objectName: "windowsButtonsRow"

      spacing: 3

      Rectangle {
        id: minimiseHighlighter
        objectName: "minimiseHighlighter"

        implicitWidth: minimiseImage.implicitWidth
        implicitHeight: minimiseImage.implicitHeight

        color: minimiseMouseArea.containsMouse ? "#2020ff" : "#00000000"

        visible: focusScopeRoot.minimiseVisble
        enabled: focusScopeRoot.minimiseEnabled

        MouseArea {
          id: minimiseMouseArea
          objectName: "minimiseMouseArea"

          anchors.fill: parent
          hoverEnabled: true

          onClicked: mainWindow_.showMinimized()
        }

        Image {
          id: minimiseImage
          objectName: "minimiseImage"

          source: "/resources/icons/window_details/minimise.png"
        }
      }

      Rectangle {
        id: maximiseHighlighter
        objectName: "maximiseHighlighter"

        implicitWidth: maximiseImage.implicitWidth
        implicitHeight: maximiseImage.implicitHeight

        color: maximiseMouseArea.containsMouse ? "#2020ff" : "#00000000"

        visible: focusScopeRoot.maximiseRestorVisble
        enabled: focusScopeRoot.maximiseRestorEnabled

        MouseArea {
          id: maximiseMouseArea
          objectName: "maximiseMouseArea"

          property bool maximise: true

          anchors.fill: parent
          hoverEnabled: true

          onClicked: {
            if (maximise) { mainWindow_.showMaximized() }
            else { mainWindow_.showNormal() }
            maximise = !maximise
          }
        }

        Image {
          id: maximiseImage
          objectName: "maximiseImage"

          source: maximiseMouseArea.maximise ?
                    "/resources/icons/window_details/maximise.png"
                  :
                    "/resources/icons/window_details/restore.png"
        }
      }

      Rectangle {
        id: closeHighlighter
        objectName: "closeeHighlighter"

        implicitWidth: closeImage.implicitWidth
        implicitHeight: closeImage.implicitHeight

        color: closeMouseArea.containsMouse ? "#ff2020" : "#00000000"

        visible: focusScopeRoot.closeVisble
        enabled: focusScopeRoot.closeEnabled

        MouseArea {
          id: closeMouseArea
          objectName: "closeMouseArea"

          anchors.fill: parent
          hoverEnabled: true

          onClicked: Qt.quit()
        }

        Image {
          id: closeImage
          objectName: "minimiseImage"

          source: "/resources/icons/window_details/close.png"
        }
      }
    }
  }

  Component {
    id: linuxButtonsComponent

    Row {
      id: linuxButtonsRow
      objectName: "linuxButtonsRow"

      spacing: 3

      Rectangle {
        id: closeHighlighter
        objectName: "closeeHighlighter"

        implicitWidth: closeImage.implicitWidth
        implicitHeight: closeImage.implicitHeight

        color: closeMouseArea.containsMouse ? "#ff2020" : "#00000000"

        visible: focusScopeRoot.closeVisble
        enabled: focusScopeRoot.closeEnabled

        MouseArea {
          id: closeMouseArea
          objectName: "closeMouseArea"

          anchors.fill: parent
          hoverEnabled: true

          onClicked: Qt.quit()
        }

        Image {
          id: closeImage
          objectName: "minimiseImage"

          source: "/resources/icons/window_details/close.png"
        }
      }

      Rectangle {
        id: minimiseHighlighter
        objectName: "minimiseHighlighter"

        implicitWidth: minimiseImage.implicitWidth
        implicitHeight: minimiseImage.implicitHeight

        color: minimiseMouseArea.containsMouse ? "#2020ff" : "#00000000"

        visible: focusScopeRoot.minimiseVisble
        enabled: focusScopeRoot.minimiseEnabled

        MouseArea {
          id: minimiseMouseArea
          objectName: "minimiseMouseArea"

          anchors.fill: parent
          hoverEnabled: true

          onClicked: mainWindow_.showMinimized()
        }

        Image {
          id: minimiseImage
          objectName: "minimiseImage"

          source: "/resources/icons/window_details/minimise.png"
        }
      }

      Rectangle {
        id: maximiseHighlighter
        objectName: "maximiseHighlighter"

        implicitWidth: maximiseImage.implicitWidth
        implicitHeight: maximiseImage.implicitHeight

        color: maximiseMouseArea.containsMouse ? "#2020ff" : "#00000000"

        visible: focusScopeRoot.maximiseRestorVisble
        enabled: focusScopeRoot.maximiseRestorEnabled

        MouseArea {
          id: maximiseMouseArea
          objectName: "maximiseMouseArea"

          property bool maximise: true

          anchors.fill: parent
          hoverEnabled: true

          onClicked: {
            if (maximise) { mainWindow_.showMaximized() }
            else { mainWindow_.showNormal() }
            maximise = !maximise
          }
        }

        Image {
          id: maximiseImage
          objectName: "maximiseImage"

          source: maximiseMouseArea.maximise ?
                    "/resources/icons/window_details/maximise.png"
                  :
                    "/resources/icons/window_details/restore.png"
        }
      }
    }
  }
}
