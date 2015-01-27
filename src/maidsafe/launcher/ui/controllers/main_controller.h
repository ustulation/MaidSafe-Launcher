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

#ifndef MAIDSAFE_LAUNCHER_UI_CONTROLLERS_MAIN_CONTROLLER_H_
#define MAIDSAFE_LAUNCHER_UI_CONTROLLERS_MAIN_CONTROLLER_H_

#include <memory>

#include "maidsafe/launcher/ui/helpers/qt_push_headers.h"
#include "maidsafe/launcher/ui/helpers/qt_pop_headers.h"

#include "maidsafe/common/config.h"

namespace maidsafe {

namespace launcher {

namespace ui {

namespace models {
class APIModel;
}  // namespace models
namespace helpers {
class MainWindow;
}  // namespace helpers

namespace controllers {

class MainController : public QObject {
  Q_OBJECT

  Q_ENUMS(MainViews)
  Q_PROPERTY(MainViews currentView READ currentView NOTIFY currentViewChanged FINAL)

 public:
  enum MainViews { HandleAccount };

  explicit MainController(QObject* parent = 0);
  ~MainController() MAIDSAFE_NOEXCEPT override;

  MainViews currentView() const;
  void SetCurrentView(const MainViews new_current_view);

  MainController(MainController&&) = delete;
  MainController(const MainController&) = delete;
  MainController& operator=(MainController&&) = delete;
  MainController& operator=(const MainController&) = delete;

 protected:
  bool eventFilter(QObject* object, QEvent* event);

 signals: // NOLINT - Viv
  void InvokeAccountHandlerController();
  void currentViewChanged(MainViews arg);

 private slots:  // NOLINT - Viv
  void UnhandledException();
  void EventLoopStarted();
  void LoginCompleted();

 private:
  void RegisterQmlTypes() const;
  void RegisterQtMetaTypes() const;
  void SetupConnections() const;
  void SetContexProperties();

  std::unique_ptr<helpers::MainWindow> main_window_;
  models::APIModel* api_model_{ nullptr };
  QObject* account_handler_controller_{ nullptr };

  MainViews current_view_{ HandleAccount };
};

}  // namespace controllers

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe

#endif  // MAIDSAFE_LAUNCHER_UI_CONTROLLERS_MAIN_CONTROLLER_H_
