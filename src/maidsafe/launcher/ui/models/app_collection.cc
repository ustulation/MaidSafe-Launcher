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

#include "maidsafe/launcher/ui/models/app_collection.h"

namespace maidsafe {

namespace launcher {

namespace ui {

AppCollection::AppCollection(const bool fill, QObject* parent)
    : QAbstractListModel{parent} {
  if (fill) {
    collection_.emplace_back(new AppItem{"Zero", QColor{255, 0, 0}});
    collection_.emplace_back(new AppItem{"One", QColor{0, 255, 0}});
    collection_.emplace_back(new AppItem{"Two", QColor{0, 0, 255}});
    collection_.emplace_back(new AppItem{"Three", QColor{255, 150, 100}});
    collection_.emplace_back(new AppItem{"Four", QColor{255, 0, 255}});
    collection_.emplace_back(new AppItem{"Five", QColor{0, 255, 255}});
  }

  roles_[ItemRole] = "item";
  roles_[TypeRole] = "type";
  roles_[ParentGroupRole] = "parentGroup";
  roles_[NameRole] = "name";
  roles_[ColorRole] = "color";
  roles_[Prop0Role] = "prop0";
  roles_[Prop1Role] = "prop1";
  roles_[Prop2Role] = "prop2";
  roles_[Prop3Role] = "prop3";

  timer_.setInterval(3000);
  connect(&timer_, SIGNAL(timeout()), this, SLOT(OnTimeout()));
//  timer_.start();
}

AppCollection::ModelRoleContainer_t AppCollection::roleNames() const {
  return roles_;
}

int AppCollection::rowCount(const QModelIndex&) const {
  return collection_.size();
}

QVariant AppCollection::data(const QModelIndex& index, int role /*= Qt::DisplayRole */) const {
  QVariant return_val;

  if (index.row() >= 0 && index.row() < static_cast<int>(collection_.size())) {
    switch (role) {
      case ItemRole:
        return_val = QVariant::fromValue(&*collection_[index.row()]);
        break;
      case TypeRole:
        return_val = collection_[index.row()]->property("itemType");
        break;
      case ParentGroupRole:
        return_val = collection_[index.row()]->property("parentGroup");
        break;
      case NameRole:
        return_val = collection_[index.row()]->property("name");
        break;
      case ColorRole:
        return_val = collection_[index.row()]->property("objColor");
        break;
      case Prop0Role:
        return_val = collection_[index.row()]->property("prop0");
        break;
      case Prop1Role:
        return_val = collection_[index.row()]->property("prop1");
        break;
      case Prop2Role:
        return_val = collection_[index.row()]->property("prop2");
        break;
      case Prop3Role:
        return_val = collection_[index.row()]->property("prop3");
        break;
      default:
        break;
    }
  }

  return return_val;
}

void AppCollection::AddData(const QString& name, const QColor& color) {
  beginInsertRows(QModelIndex{}, collection_.size(), collection_.size());
  collection_.emplace_back(new AppItem(name, color));
  endInsertRows();
}

void AppCollection::AddData(std::unique_ptr<QObject> new_data) {
  qDebug() << this;
  this->beginInsertRows(QModelIndex{}, collection_.size(), collection_.size());
  this->collection_.emplace_back(std::move(new_data));
  this->endInsertRows();
}

void AppCollection::RemoveData(const QString& name) {
  for (std::size_t index{}; index < collection_.size(); ++index) {
    if (collection_[index]->property("name").toString() == name) {
      beginRemoveRows(QModelIndex{}, index, index);
      collection_.erase(collection_.begin() + index);
      endRemoveRows();
      break;
    }
  }
}

void AppCollection::UpdateData(const QString& name, std::unique_ptr<QObject> new_data) {
  for (std::size_t index{}; index < collection_.size(); ++index) {
    if (collection_[index]->property("name").toString() == name) {
      collection_[index] = std::move(new_data);
      break;
    }
  }
}

void AppCollection::UpdateData(const QString& name, const QString& new_name) {
  for (std::size_t index{}; index < collection_.size(); ++index) {
    if (collection_[index]->property("name").toString() == name) {
      collection_[index]->setProperty("name", QVariant::fromValue(new_name));
      break;
    }
  }
}

void AppCollection::UpdateData(const QString& name, const QColor& new_color) {
  for (std::size_t index{}; index < collection_.size(); ++index) {
    if (collection_[index]->property("name").toString() == name) {
      collection_[index]->setProperty("objColor", QVariant::fromValue(new_color));
      break;
    }
  }
}

void AppCollection::OnTimeout() {
  auto id(qrand() % 256);
  auto r(qrand() % 256);
  auto g(qrand() % 256);
  auto b(qrand() % 256);
  AddData(QString{"Id: %1"}.arg(id), QColor{r, g, b});
}

void AppCollection::MoveData(int index_from, int index_to) {
  int size = collection_.size();
  if (index_from >= 0 && index_from < size &&
      index_to   >= 0 && index_to   < size &&
      index_from != index_to) {
    auto row_parent(QModelIndex{});
    auto temp_data(std::move(collection_[index_from]));

    if (index_from > index_to) {
      if(beginMoveRows(row_parent, index_from, index_from, row_parent, index_to)) {
        for (int i = index_from; i > index_to; --i) {
          collection_[i] = std::move(collection_[i - 1]);
        }
      }
    } else if (beginMoveRows(row_parent, index_from, index_from, row_parent, index_to + 1)) {
      for (int i = index_from; i < index_to; ++i) {
        collection_[i] = std::move(collection_[i + 1]);
      }
    }
    collection_[index_to] = std::move(temp_data);
    endMoveRows();
  }
}

void AppCollection::MakeNewGroup(const int item_index_0, const int item_index_1) {
  if (item_index_0 != item_index_1 &&
      item_index_0 >= 0 && item_index_0 < static_cast<int>(collection_.size()) &&
      item_index_1 >= 0 && item_index_1 < static_cast<int>(collection_.size())) {
    auto item_0(std::move(collection_[item_index_0]));
    auto item_1(std::move(collection_[item_index_1]));

    auto app_collection(new AppCollection{false});
    app_collection->AddData(std::move(item_0));
    app_collection->AddData(std::move(item_1));

    std::unique_ptr<QObject> new_group{app_collection};
    app_collection = nullptr;

    beginRemoveRows(QModelIndex{}, item_index_0, item_index_0);
    collection_.erase(collection_.begin() + item_index_0);
    endRemoveRows();

    beginInsertRows(QModelIndex{}, item_index_0, item_index_0);
    collection_.insert(collection_.begin() + item_index_0, std::move(new_group));
    endInsertRows();

    beginRemoveRows(QModelIndex{}, item_index_1, item_index_1);
    collection_.erase(collection_.begin() + item_index_1);
    endRemoveRows();
  }
}

void AppCollection::AddToGroup(const int group_index, const int source_index) {
  if (group_index != source_index &&
      group_index >= 0 && group_index < static_cast<int>(collection_.size()) &&
      source_index >= 0 && source_index < static_cast<int>(collection_.size())) {
    if (auto group = dynamic_cast<AppCollection*>(&*collection_[group_index])) {
      auto item(std::move(collection_[source_index]));
      qDebug() << this << group;
      group->AddData(std::move(item));

      beginRemoveRows(QModelIndex{}, source_index, source_index);
      collection_.erase(collection_.begin() + source_index);
      endRemoveRows();
    } else {
      qDebug() << "PANIC";
    }
  }
}

void AppCollection::StartRandomAdd() {
  timer_.start();
}

void AppCollection::StopRandomAdd() {

}

void AppCollection::StartRandomDelete() {

}

void AppCollection::StopRandomDelete() {

}

void AppCollection::StartRandomUpdate() {

}

void AppCollection::StopRandomUpdate() {

}

}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe
