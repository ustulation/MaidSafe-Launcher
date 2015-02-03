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

QtObject {
  id: globalProperties
  objectName: "globalProperties"

  readonly property int windowResizerThickness: 5

  readonly property int fontPixelSize: 18
  readonly property int loginTextFieldWidth: 320
  readonly property int loginTextFieldHeight: 35
  readonly property int loginRextFieldRadius: 5
  readonly property int loginTextFieldVerticalSpacing: 15

  readonly property int loginButtonBottomMargin: 130
  readonly property int createAccountNextButtonBottomMargin: 130
  readonly property int accountHandlerClickableTextBottomMargin: 45

  readonly property int loginPageNextButtonWidth: loginTextFieldWidth
  readonly property int loginPageNextButtonHeight: loginTextFieldHeight
  readonly property int loginPageNextButtonRadius: loginRextFieldRadius
}
