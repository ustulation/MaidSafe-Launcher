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

#ifndef HOME_PAGE_MODEL_H
#define HOME_PAGE_MODEL_H

#include "maidsafe/launcher/ui/helpers/qt_push_headers.h"
#include "maidsafe/launcher/ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace launcher {

namespace ui {

class Data : public QObject {
  Q_OBJECT

  Q_PROPERTY(QColor objColor READ objColor WRITE setObjColor NOTIFY objColorChanged FINAL)
  Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)

 public:
  template<typename T, typename U>
  Data(T&& t, U&& u)
      : name_{std::forward<T>(t)},
        color_{std::forward<U>(u)} { }

  Data(const Data& other)
      : name_{other.name_},
        color_{other.color_} { }

  Data& operator=(const Data& other) {
    setObjColor(other.color_);
    setName(other.name_);

    return *this;
  }

  Data() = default;
  Data(Data&& other) = default;
  Data& operator=(Data&& other) = default;
  ~Data() override = default;

  QColor objColor() const { return color_; }
  void setObjColor(const QColor new_color) { if (new_color != color_) { color_ = new_color; emit objColorChanged(color_); } }
  Q_SIGNAL void objColorChanged(QColor new_color);

  QString name() const { return name_; }
  void setName(const QString new_name) { if (new_name != name_) { name_ = new_name; emit nameChanged(name_); } }
  Q_SIGNAL void nameChanged(QString new_name);

 private:
  QString name_{tr("Default")};
  QColor color_{255, 0, 0};
};

class HomePageModel : public QAbstractListModel {
  Q_OBJECT

  using ModelRoleContainer_t = QHash<int, QByteArray>;

  enum {
    DataRole = Qt::UserRole + 1,
  };

 public:
  explicit HomePageModel(QObject* parent = nullptr);

  ModelRoleContainer_t roleNames() const override;
  int rowCount(const QModelIndex& = QModelIndex{}) const override;
  QVariant data(const QModelIndex& index, int role /*= Qt::DisplayRole */) const override;

  void AddData(const QString& name, const QColor& color);
  void RemoveData(const QString& name);

  void UpdateData(const QString& name, const Data& new_data);
  void UpdateData(const QString& name, const QString& new_name);
  void UpdateData(const QString& name, const QColor& new_color);

  void MoveData(int index_from, int index_to);

  void StartRandomAdd();
  void StopRandomAdd();

  void StartRandomDelete();
  void StopRandomDelete();

  void StartRandomUpdate();
  void StopRandomUpdate();

 public slots:
  void OnTimeout();

 private:
  ModelRoleContainer_t roles_;
  std::vector<Data> data_collection_;

  QTimer timer_;
};

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe

#endif // HOME_PAGE_MODEL_H
