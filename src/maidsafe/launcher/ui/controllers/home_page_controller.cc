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

#include "maidsafe/launcher/ui/controllers/home_page_controller.h"
#include "maidsafe/launcher/ui/models/app_collection.h"

namespace maidsafe {

namespace launcher {

namespace ui {

HomePageController::HomePageController(MainWindow& main_window, QObject* parent)
    : QObject{parent},
      main_window_{main_window},
      app_collection_{new AppCollection{this}} {
}

HomePageController::~HomePageController() = default;

QObject* HomePageController::homePageModel() const {
  return app_collection_;
}

HomePageController::HomePageViews HomePageController::currentView() const {
  return current_view_;
}

void HomePageController::SetCurrentView(const HomePageViews new_current_view) {
  if (new_current_view != current_view_) {
    current_view_ = new_current_view;
    emit currentViewChanged(current_view_);
  }
}

void HomePageController::move(int index_from, int index_to) {
  app_collection_->MoveData(index_from, index_to);
}

void HomePageController::makeNewGroup(int item_index_0, int item_index_1) {
  app_collection_->MakeNewGroup(item_index_0, item_index_1);
}

void HomePageController::addAppRequested(const QUrl& file_url) {
  app_collection_->AddData(file_url.path(), QColor{130, 80, 255});
}

void HomePageController::Invoke() {
//  home_page_model_->StartRandomAdd();
}

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe
