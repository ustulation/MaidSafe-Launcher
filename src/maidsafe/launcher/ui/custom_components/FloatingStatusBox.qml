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

Rectangle {
  id: statusDisplayRect
  objectName: "statusDisplayRect"

  property Item pointToItem: null
  property alias metaText: metaInformationText
  property alias infoText: informationText
  property real yOffset: 0

  y: pointToItem ? pointToItem.y + pointToItem.height / 2 - height / 2 + yOffset : 0

  width: Math.min(180,
                  metaInformationText.implicitWidth   +
                  informationText.implicitWidth       +
                  metaInformationText.anchors.margins +
                  informationText.anchors.margins)

  height: Math.max(informationText.implicitHeight, metaInformationText.implicitHeight,
                   globalProperties.textFieldHeight)

  radius: globalProperties.textFieldRadius
  visible: false

  Rectangle {
    id: pointerRect
    objectName: "pointerRect"

    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: -width / 2 }
    width: 8
    height: width
    rotation: 45
  }

  CustomText {
    id: metaInformationText
    objectName: "metaInformationText"

    anchors { left: parent.left; verticalCenter: parent.verticalCenter; margins: 3 }
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: globalBrushes.textGrey
    font { pixelSize: 12; bold: true }
  }

  CustomText {
    id: informationText
    objectName: "informationText"

    anchors {
      left: metaInformationText.right; right: parent.right;
      verticalCenter: parent.verticalCenter; margins: 3
    }

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    color: "green"
    font { pixelSize: 12; bold: true }
  }
}
