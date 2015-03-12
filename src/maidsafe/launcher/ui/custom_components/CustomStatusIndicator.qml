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
  id: customStatusRoot
  objectName: "customStatusRoot"

  property int fps_busy: 30
  property int fps_error: 30

  function showBusy() {
    if (timer.running) {
      timer.callback = dPtr.showBusyImpl
      timer.stopFlag = true
    } else {
      dPtr.showBusyImpl()
    }
  }

  function showSuccess() {
    if (timer.running) {
      timer.callback = dPtr.showSuccessImpl
      timer.stopFlag = true
    } else {
      dPtr.showSuccessImpl()
    }
  }

  function showError() {
    if (timer.running) {
      timer.callback = dPtr.showErrorImpl
      timer.stopFlag = true
    } else {
      dPtr.showErrorImpl()
    }
  }

  QtObject {
    id: dPtr
    objectName: "dPtr"

    function cleanUpPreviousDirt() {
      repeaterError.itemAt(repeaterError.count - 1).visible = false
    }

    function showBusyImpl() {
      cleanUpPreviousDirt()
      timer.interval = 1000 / customStatusRoot.fps_busy
      timer.currentRepeater = repeaterBusy
      timer.repeatAnimation = true
      timer.start()
    }

    function showSuccessImpl() {
      cleanUpPreviousDirt()
    }

    function showErrorImpl() {
      cleanUpPreviousDirt()
      timer.interval = 1000 / customStatusRoot.fps_error
      timer.currentRepeater = repeaterError
      timer.repeatAnimation = false
      timer.start()
    }
  }

  Timer {
    id: timer
    objectName: "timer"

    property bool repeatAnimation: false
    property int currentImageNumber: 0
    property Item currentRepeater: null
    property bool stopFlag: false
    property var callback: null

    repeat: true

    onTriggered: {
      if (!currentImageNumber) {
        if (stopFlag) {
          currentRepeater.itemAt(currentRepeater.count - 1).visible = false
          running = stopFlag = false
          callback()
          return
        } else if (!repeatAnimation && currentRepeater.itemAt(currentRepeater.count - 1).visible) {
          running = false
          return
        }
      }

      currentRepeater.itemAt(currentImageNumber).visible = true
      currentRepeater.itemAt(!currentImageNumber ?
                               currentRepeater.count - 1 : currentImageNumber -1).visible = false
      currentImageNumber = (currentImageNumber + 1) % currentRepeater.count
    }
  }

  Repeater {
    id: repeaterBusy
    objectName: "repeaterBusy"

    model: 29

    delegate: Image {
      id: imageBusy
      objectName: "imageBusy"

      anchors.centerIn: customStatusRoot
      source: "/resources/images/rocket-busy/loading" + model.index + ".png"
      visible: false
    }
  }

  Repeater {
    id: repeaterError
    objectName: "repeaterError"

    model: 120

    delegate: Image {
      id: imageError
      objectName: "imageError"

      anchors.centerIn: customStatusRoot
      source: "/resources/images/rocket-error/error" + model.index + ".png"
      visible: false
    }
  }
}
