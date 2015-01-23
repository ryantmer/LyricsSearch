#include "LyricWikia.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/ListView>
#include <bb/data/JsonDataAccess>

using namespace bb::cascades;
using namespace bb::data;

LyricWikia::LyricWikia() : QObject() {
    _favourites = new QMapListDataModel();

    //Try loading favourites from local file
    JsonDataAccess jda;
    QString path = QDir::currentPath() + "/app/native/assets/resources/favourites.json";
    QVariantList list = jda.load(path).value<QVariantList>();
    if (jda.hasError()) {
        qWarning() << Q_FUNC_INFO << "Could not read favourites" << jda.error();
        return;
    }
    foreach (QVariant v, list) {
        QVariantMap data = v.toMap();
        _favourites->append(data);
        qDebug() << Q_FUNC_INFO << "New favourite added:" << data;
    }

    QmlDocument *qml = QmlDocument::create("asset:///Search.qml").parent(this);
    _root = qml->createRootObject<NavigationPane>();
    Application::instance()->setScene(_root);

    QDeclarativeEngine *engine = QmlDocument::defaultDeclarativeEngine();
    QDeclarativeContext *rootContext = engine->rootContext();
    rootContext->setContextProperty("favouritesDataModel", _favourites);
}

LyricWikia::~LyricWikia() {
    JsonDataAccess jda;
    QString path = QDir::currentPath() + "/app/native/assets/resources/favourites.json";
    QVariantList list;
    for (int i = 0; i < this->_favourites->size(); ++i) {
        list.append(this->_favourites->value(i));
    }
    jda.save(list, path);
}

QMapListDataModel *LyricWikia::favourites() {
    return _favourites;
}
