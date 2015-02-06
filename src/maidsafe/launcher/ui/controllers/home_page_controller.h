#ifndef HOME_PAGE_CONTROLLER_H
#define HOME_PAGE_CONTROLLER_H

#include "maidsafe/launcher/ui/helpers/qt_push_headers.h"
#include "maidsafe/launcher/ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace launcher {

namespace ui {

class HomePageModel;

class HomePageController : public QObject {
  Q_OBJECT

  Q_PROPERTY(QObject* homePageModel READ homePageModel CONSTANT FINAL)

 public:
  explicit HomePageController(QObject* parent = nullptr);

  QObject* homePageModel() const{return nullptr;}

 signals:

 public slots:

 private:
  HomePageModel* home_page_model_{nullptr};
};

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe

#endif // HOME_PAGE_CONTROLLER_H
