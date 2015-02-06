#include "maidsafe/launcher/ui/models/home_page_model.h"

#include "maidsafe/launcher/ui/helpers/qt_push_headers.h"
#include "maidsafe/launcher/ui/helpers/qt_pop_headers.h"

namespace maidsafe {

namespace launcher {

namespace ui {

HomePageModel::HomePageModel(QObject* parent)
    : QAbstractListModel{parent} {
  roles_[DataRole] = "data";
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
        return_val = QVariant::fromValue(const_cast<QObject*>(static_cast<const QObject*>(&data_collection_[index.row()])));
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


}  // namespace ui

}  // namespace launcher

}  // namespace maidsafe
