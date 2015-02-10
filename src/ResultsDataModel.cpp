#include "ResultsDataModel.hpp"

ResultsDataModel::ResultsDataModel() : GroupDataModel() {
}

ResultsDataModel::~ResultsDataModel() {
}

QString ResultsDataModel::itemType(const QVariantList &indexPath) {
    QVariantMap d = data(indexPath).toMap();
    if (d.value("type").toString() == "album") {
        return "header";
    } else if (d.value("type").toString() == "song") {
        return "item";
    } else {
        qDebug() << Q_FUNC_INFO << "Unknown type";
        return GroupDataModel::itemType(indexPath);
    }
}
