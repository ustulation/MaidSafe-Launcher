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
  id: homePageGridViewContainerRoot

  // For efficiently removing empty sub-groups
  // Change this whenever changing current-model
  property var indexOfCurrentGroupInParentGroup: []

  property Loader currentlyFreeLoader: loader1

  // Do not change. Change only the above
  property Loader inUseLoader: currentlyFreeLoader === loader1 ? loader0 : loader1

  signal enterSubGroup(Item itemContainingSubGroup, QtObject subGroup, int indexOfSubGroupInParent)
  signal exitToParentGroup(QtObject parentGroup)

  focus: true

  Component.onCompleted: {
    mainWindow_.width = 800
    mainWindow_.minimumWidth = 80
    mainWindow_.maximumWidth = 10000

    mainWindow_.height = 600
    mainWindow_.minimumHeight = 60
    mainWindow_.maximumHeight = 10000

    loader0.anchors.fill = homePageGridViewContainerRoot
    loader0.sourceComponent = homePageGridViewComponent
    loader0.item.columnConstraint = true
    loader0.item.gridViewRepeater.model = homePageController_.currentHomePageModel
  }

  onEnterSubGroup: {
    currentlyFreeLoader.z = 1
    currentlyFreeLoader.visible = false
    inUseLoader.z = 0
    currentlyFreeLoader.anchors.fill = undefined

    indexOfCurrentGroupInParentGroup.push(indexOfSubGroupInParent)
    currentlyFreeLoader.sourceComponent = homePageGridViewComponent
    currentlyFreeLoader.item.gridViewRepeater.model = subGroup

    currentlyFreeLoader.x = homePageGridViewContainerRoot.mapFromItem(itemContainingSubGroup, 0, 0).x
    currentlyFreeLoader.y = homePageGridViewContainerRoot.mapFromItem(itemContainingSubGroup, 0, 0).y
    currentlyFreeLoader.width = itemContainingSubGroup.width
    currentlyFreeLoader.height = itemContainingSubGroup.height

    parallelAnimation.targetLoader = currentlyFreeLoader
    parallelAnimation.loaderToFreeOnAnimationCompletion = inUseLoader
    parallelAnimation.xFinal = parallelAnimation.yFinal = 0
    parallelAnimation.widthFinal = homePageGridViewContainerRoot.width
    parallelAnimation.heightFinal = homePageGridViewContainerRoot.height

    currentlyFreeLoader.visible = true
    parallelAnimation.start()
  }

  onExitToParentGroup: {
    currentlyFreeLoader.z = 0
    currentlyFreeLoader.visible = false
    inUseLoader.z = 1
    inUseLoader.anchors.fill = undefined
    currentlyFreeLoader.anchors.fill = homePageGridViewContainerRoot

    currentlyFreeLoader.sourceComponent = homePageGridViewComponent
    currentlyFreeLoader.item.columnConstraint = true
    currentlyFreeLoader.item.gridViewRepeater.model = parentGroup
    var itemContainingSubGroup =
        currentlyFreeLoader.item.gridViewRepeater.itemAt(indexOfCurrentGroupInParentGroup.pop())

    parallelAnimation.targetLoader = inUseLoader
    parallelAnimation.loaderToFreeOnAnimationCompletion = inUseLoader
    parallelAnimation.xFinal = homePageGridViewContainerRoot.mapFromItem(itemContainingSubGroup, 0, 0).x
    parallelAnimation.yFinal = homePageGridViewContainerRoot.mapFromItem(itemContainingSubGroup, 0, 0).y
    parallelAnimation.widthFinal = itemContainingSubGroup.width
    parallelAnimation.heightFinal = itemContainingSubGroup.height

    inUseLoader.item.columnConstraint = false

    currentlyFreeLoader.visible = true
    parallelAnimation.start()
  }

  ParallelAnimation {
    id: parallelAnimation

    property Loader targetLoader: null
    property Loader loaderToFreeOnAnimationCompletion: null
    property real xFinal: 0
    property real yFinal: 0
    property real widthFinal: 0
    property real heightFinal: 0

    readonly property int animationDuration: 100

    onStopped: {
      loaderToFreeOnAnimationCompletion.sourceComponent = undefined
      homePageGridViewContainerRoot.currentlyFreeLoader = loaderToFreeOnAnimationCompletion
      homePageController_.currentHomePageModel =
          homePageGridViewContainerRoot.inUseLoader.item.gridViewRepeater.model
      homePageGridViewContainerRoot.inUseLoader.item.columnConstraint = true
      homePageGridViewContainerRoot.inUseLoader.anchors.fill = homePageGridViewContainerRoot
    }

    running: false

    NumberAnimation {
      target: parallelAnimation.targetLoader
      property: "x"
      to: parallelAnimation.xFinal
      duration: parallelAnimation.animationDuration
    }
    NumberAnimation {
      target: parallelAnimation.targetLoader
      property: "y"
      to: parallelAnimation.yFinal
      duration: parallelAnimation.animationDuration
    }
    NumberAnimation {
      target: parallelAnimation.targetLoader
      property: "width"
      to: parallelAnimation.widthFinal
      duration: parallelAnimation.animationDuration
    }
    NumberAnimation {
      target: parallelAnimation.targetLoader
      property: "height"
      to: parallelAnimation.heightFinal
      duration: parallelAnimation.animationDuration
    }
  }

  Loader {
    id: loader0

    sourceComponent: undefined
    onLoaded: item.focus = true
  }

  Loader {
    id: loader1

    sourceComponent: undefined
    onLoaded: item.focus = true
  }

  Component {
    id: homePageGridViewComponent

    HomePageGridView {
      id: homePageGridView
      gridViewContainerRoot: homePageGridViewContainerRoot
    }
  }
}
