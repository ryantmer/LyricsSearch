#include "LyricWikia.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/ListView>
#include <bb/cascades/Container>
#include <bb/data/JsonDataAccess>

using namespace bb::cascades;
using namespace bb::data;

LyricWikia::LyricWikia() : QObject() {
    _netConfigMan = new QNetworkConfigurationManager(this);
    _netAccessMan = new QNetworkAccessManager(this);
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
    qml->setContextProperty("app", this);
    _root = qml->createRootObject<NavigationPane>();
    Application::instance()->setScene(_root);

    QDeclarativeEngine *engine = QmlDocument::defaultDeclarativeEngine();
    QDeclarativeContext *rootContext = engine->rootContext();
    rootContext->setContextProperty("favouritesDataModel", _favourites);

    bool ok;
    ok = connect(_netAccessMan, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(onFinished(QNetworkReply*)));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

LyricWikia::~LyricWikia() {
    JsonDataAccess jda;
    QString path = QDir::currentPath() + "/app/native/assets/resources/favourites.json";
    QVariantList list;
    for (int i = 0; i < _favourites->size(); ++i) {
        list.append(_favourites->value(i));
    }
    jda.save(list, path);
}

void LyricWikia::search(QVariantMap query) {
    Page *page = _root->top();
    Container *container = page->findChild<Container*>("activityContainer");
    if (container) {
        container->setVisible(true);
    } else {
        qDebug() << Q_FUNC_INFO << "No activity container on top page";
    }

    QString artist = query.value("artist").toString();
    QString album = query.value("album").toString();
    QString song = query.value("song").toString();

    QUrl url;
    url.setUrl(QString("http://lyrics.wikia.com/api.php"));

    url.addQueryItem("fmt", "realjson");
    if (!song.isEmpty()) {
        //Search for song
        url.addQueryItem("func", "getSong");
        url.addQueryItem("song", song);
        if (!artist.isEmpty()) {
            url.addQueryItem("artist", artist);
        }
    } else {
        //Search for artist
        url.addQueryItem("func", "getArtist");
        url.addQueryItem("artist", artist);
    }

    qDebug() << Q_FUNC_INFO << url;
    QNetworkRequest req(url);
    _netAccessMan->get(req);
}

void LyricWikia::onFinished(QNetworkReply *reply) {
    Page *page = _root->top();
    Container *container = page->findChild<Container*>("activityContainer");
    if (container) {
        container->setVisible(false);
    } else {
        qDebug() << Q_FUNC_INFO << "No activity container on top page";
    }

    QString response = reply->readAll();
    qDebug() << Q_FUNC_INFO << response;
}
