#include "ResultsDataModel.hpp"

ResultsDataModel::ResultsDataModel(QObject *parent) : DataModel(parent) {}

void ResultsDataModel::clear() {
    _internalDB.clear();
    emit itemsChanged(bb::cascades::DataModelChangeType::AddRemove);
}

void ResultsDataModel::addResult(QVariantMap result) {
    _internalDB.append(result);
    emit itemsChanged(bb::cascades::DataModelChangeType::AddRemove);
}

QVariantList ResultsDataModel::getInternalDB() {
    return _internalDB;
}

int ResultsDataModel::childCount(const QVariantList &indexPath) {
    int retVal = 0;
    if (indexPath.length() == 0) {
        retVal = _internalDB.length();
    } else {
        //No map in list has children; each just represents a song or album
        retVal = 0;
    }
    return retVal;
}

bool ResultsDataModel::hasChildren(const QVariantList &indexPath) {
    return childCount(indexPath) > 0;
}

QVariant ResultsDataModel::data(const QVariantList &indexPath) {
    //Model is just a list of maps, so return map at given indexPath
    //(will be either a song or an album)
    return QVariant(_internalDB.value(indexPath.value(0).toInt(NULL)).toMap());
}

QString ResultsDataModel::itemType(const QVariantList &indexPath) {
    QString retVal;
    QVariantMap d = data(indexPath).toMap();
    if (d.value("type").toString() == "album") {
        retVal =  "header";
    } else if (d.value("type").toString() == "song") {
        retVal = "item";
    } else {
        qDebug() << Q_FUNC_INFO << "Unknown type";
        qDebug() << Q_FUNC_INFO << d << indexPath;
    }
    return retVal;
}
