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

#include "maidsafe/launcher/ui/models/home_page_model.h"

namespace maidsafe {

namespace launcher {

namespace ui {

HomePageModel::HomePageModel(QObject* parent)
    : QAbstractListModel{parent},
      data_collection_ {
        Data{"Zero", QColor{255, 0, 0}},
        Data{"One", QColor{0, 255, 0}},
        Data{"Two", QColor{0, 0, 255}},
        Data{"Three", QColor{255, 150, 100}},
        Data{"Four", QColor{255, 0, 255}},
        Data{"Five", QColor{0, 255, 255}}} {
  roles_[DataRole] = "data";
  timer_.setInterval(3000);
  connect(&timer_, SIGNAL(timeout()), this, SLOT(OnTimeout()));
}

HomePageModel::ModelRoleContainer_t HomePageModel::roleNames() const {
  return roles_;
}

int HomePageModel::rowCount(const QModelIndex&) const {
  return data_collection_.size();
}

QVariant HomePageModel::data(const QModelIndex& index, int role /*= Qt::DisplayRole */) const {
  QVariant return_val;

  if (index.row() >= 0 && index.row() < static_cast<int>(data_collection_.size())) {
    switch (role) {
      case DataRole:
        return_val = QVariant::fromValue(
              const_cast<QObject*>(static_cast<const QObject*>(&data_collection_[index.row()])));
        break;
      default:
        break;
    }
  }

  return return_val;
}

void HomePageModel::AddData(const QString& name, const QColor& color) {
  beginInsertRows(QModelIndex{}, data_collection_.size(), data_collection_.size());
  data_collection_.emplace_back(name, color);
  endInsertRows();
}

void HomePageModel::RemoveData(const QString& name) {
  for (std::size_t index{}; index < data_collection_.size(); ++index) {
    if (data_collection_[index].name() == name) {
      beginRemoveRows(QModelIndex{}, index, index);
      data_collection_.erase(data_collection_.begin() + index);
      endRemoveRows();
      break;
    }
  }
}

void HomePageModel::UpdateData(const QString& name, const Data& new_data) {
  for (std::size_t index{}; index < data_collection_.size(); ++index) {
    if (data_collection_[index].name() == name) {
      data_collection_[index] = new_data;
      break;
    }
  }
}

void HomePageModel::UpdateData(const QString& name, const QString& new_name) {
  for (std::size_t index{}; index < data_collection_.size(); ++index) {
    if (data_collection_[index].name() == name) {
      data_collection_[index].setName(new_name);
      break;
    }
  }
}

void HomePageModel::UpdateData(const QString& name, const QColor& new_color) {
  for (std::size_t index{}; index < data_collection_.size(); ++index) {
    if (data_collection_[index].name() == name) {
      data_collection_[index].setObjColor(new_color);
      break;
    }
  }
}

void HomePageModel::OnTimeout() {
  auto id(qrand() % 256);
  auto r(qrand() % 256);
  auto g(qrand() % 256);
  auto b(qrand() % 256);
  AddData(QString{"Id: %1"}.arg(id), QColor{r, g, b});
}

void HomePageModel::MoveData(int index_from, int index_to) {
  int size = data_collection_.size();
  if (index_from >= 0 && index_from < size &&
      index_to   >= 0 && index_to   < size &&
      index_from != index_to) {
    auto row_parent(QModelIndex{});
    auto temp_data(std::move(data_collection_[index_from]));

    if (index_from > index_to) {
      if(beginMoveRows(row_parent, index_from, index_from, row_parent, index_to)) {
//        for (int i = index_from; i > index_to; --i) {
//          data_collection_[i] = std::move(data_collection_[i - 1]);
//        }
      }
    } else if (beginMoveRows(row_parent, index_from, index_from, row_parent, index_to + 1)) {
//      for (int i = index_from; i < index_to; ++i) {
//        data_collection_[i] = std::move(data_collection_[i + 1]);
//      }
    }
//    data_collection_[index_to] = std::move(temp_data);
    endMoveRows();

//    for (auto& data: data_collection_) {
//      qDebug() << data.name();
//    }
  }
}

void HomePageModel::StartRandomAdd() {
  timer_.start();
}

void HomePageModel::StopRandomAdd() {

}

void HomePageModel::StartRandomDelete() {

}

void HomePageModel::StopRandomDelete() {

}

void HomePageModel::StartRandomUpdate() {

}

void HomePageModel::StopRandomUpdate() {

}

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe
