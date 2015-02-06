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

#ifndef HOME_PAGE_CONTROLLER_H
#define HOME_PAGE_CONTROLLER_H

#include "maidsafe/launcher/ui/helpers/qt_push_headers.h"
#include "maidsafe/launcher/ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace launcher {

namespace ui {

class MainWindow;
class HomePageModel;

class HomePageController : public QObject {
  Q_OBJECT

  Q_PROPERTY(QObject* homePageModel READ homePageModel CONSTANT FINAL)
  Q_PROPERTY(HomePageViews currentView READ currentView NOTIFY currentViewChanged FINAL)

 public:
  enum HomePageViews {
    HomePageView,
  };

  HomePageController(MainWindow& main_window, QObject* parent);
  ~HomePageController() override;
  HomePageController(HomePageController&&) = delete;
  HomePageController(const HomePageController&) = delete;
  HomePageController& operator=(HomePageController&&) = delete;
  HomePageController& operator=(const HomePageController&) = delete;

  QObject* homePageModel() const;

  HomePageViews currentView() const;
  void SetCurrentView(const HomePageViews new_current_view);

  Q_INVOKABLE void move(int index_from, int index_to);

 signals: // NOLINT - Spandan
  void currentViewChanged(HomePageViews new_view);

 private slots: // NOLINT - Spandan
  void Invoke();

 private:
  MainWindow& main_window_;
  HomePageModel* home_page_model_{nullptr};

  HomePageViews current_view_{HomePageView};
};

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe

#endif // HOME_PAGE_CONTROLLER_H
