#include "LyricsSearch.hpp"
#include <QUrl>
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/ListView>
#include <bb/cascades/Container>
#include <bb/data/JsonDataAccess>
#include <bb/system/SystemToast>
#include <bb/system/SystemUiPosition>
#include <bb/PackageInfo>

using namespace bb::cascades;
using namespace bb::data;
using namespace bb::system;

QString favouritesPath = QDir::currentPath() + "/data/favourites.json";

LyricsSearch::LyricsSearch() : QObject() {
    _netConfigMan = new QNetworkConfigurationManager(this);
    _netAccessMan = new QNetworkAccessManager(this);
    _favourites = new QMapListDataModel();
    _results = new ResultsDataModel();

    //Try loading favourites from local file
    QFile file(favouritesPath);
    qDebug() << Q_FUNC_INFO << "Reading favourites from" << file.fileName();
    JsonDataAccess jda(&file);
    QVariantList list = jda.load(&file).value<QVariantList>();
    if (jda.hasError()) {
        qWarning() << Q_FUNC_INFO << "Could not read favourites" << jda.error();
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
    rootContext->setContextProperty("app", this);
    rootContext->setContextProperty("favouritesModel", _favourites);
    rootContext->setContextProperty("resultsModel", _results);

    bool ok;
    ok = connect(_netAccessMan, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(onFinished(QNetworkReply*)));
    Q_ASSERT(ok);
    Q_UNUSED(ok);
}

LyricsSearch::~LyricsSearch() {
    QFile file(favouritesPath);
    qDebug() << Q_FUNC_INFO << "Saving favourites to" << file.fileName();
    JsonDataAccess jda(&file);
    QVariantList list;
    for (int i = 0; i < _favourites->size(); ++i) {
        list.append(_favourites->value(i));
    }
    jda.save(list, &file);
    if (jda.hasError()) {
        qDebug() << Q_FUNC_INFO << "Couldn't save favourites!";
        qDebug() << Q_FUNC_INFO << jda.error();
    } else {
        file.close();
    }
}

QString LyricsSearch::getVersionNumber() {
    bb::PackageInfo pi;
    return pi.version();
}

void LyricsSearch::addFavourite(QVariantMap fav) {
    qDebug() << Q_FUNC_INFO << "Adding favourite:" << fav;
    fav.remove("lyrics");
    fav.remove("isOnTakedownList");
    fav.remove("page_id");
    fav.remove("page_namespace");
    _favourites->append(fav);
    toast("Favourite Added");
}

void LyricsSearch::removeFavourite(QVariantMap fav) {
    qDebug() << Q_FUNC_INFO << "Remove favourite:" << fav;

    for (int i = 0; i < _favourites->size(); ++i) {
        QVariantMap m = _favourites->value(i);
        if (fav.value("artist").toString() == m.value("artist").toString() &&
                fav.value("song").toString() == m.value("song").toString()) {
            _favourites->removeAt(i);
            qDebug() << Q_FUNC_INFO << "Favourite removed.";
            toast("Favourite Removed");
            return;
        }
    }
}

void LyricsSearch::toast(QString message) {
    SystemToast *toast = new SystemToast(this);
    toast->setBody(message);
    toast->setPosition(SystemUiPosition::BottomCenter);
    toast->show();
}

void LyricsSearch::search(QVariantMap query) {
    Page *page = _root->top();
    Container *container = page->findChild<Container*>("activityContainer");
    if (container) {
        container->setVisible(true);
    } else {
        qDebug() << Q_FUNC_INFO << "No activity container on top page";
    }

    QString artist = query.value("artist").toString();
    QString song = query.value("song").toString();
    QString album = query.value("album").toString();

    QUrl url;
    url.setUrl(QString("http://lyrics.wikia.com/api.php"));

    url.addQueryItem("fmt", "realjson");
    url.addQueryItem("artist", artist);
    if (!song.isEmpty()) {
        url.addQueryItem("song", song);
    }
    if (!artist.isEmpty()) {
        //This doesn't do anything in the request, but is used when the reply
        //is received to isolate the album the user searched for.
        url.addQueryItem("album", album);
    }

    QNetworkRequest req(url);
    if (!song.isEmpty()) {
        req.setAttribute(QNetworkRequest::User, QVariant(Song));
    } else if (!album.isEmpty()) {
        req.setAttribute(QNetworkRequest::User, QVariant(Album));
    } else {
        req.setAttribute(QNetworkRequest::User, QVariant(Artist));
    }

    qDebug() << Q_FUNC_INFO << url;
    _netAccessMan->get(req);
}

void LyricsSearch::onFinished(QNetworkReply *reply) {
    QString response = reply->readAll();
    qDebug() << Q_FUNC_INFO << response;

    _results->clear();

    if (reply->error() == QNetworkReply::NoError) {
        JsonDataAccess jda;
        QVariantMap map = jda.loadFromBuffer(response).value<QVariantMap>();
        if (jda.hasError()) {
            qWarning() << Q_FUNC_INFO << "Couldn't read response into JSON:" << jda.error();
            qWarning() << Q_FUNC_INFO << response;
            return;
        }
        //Should just end up with a list of songs in all cases
        //User searched for artist
        if (reply->request().attribute(QNetworkRequest::User) == Artist) {
            QString artist = map.value("artist").toString();

            QVariantList albums = map.value("albums").toList();
            foreach (QVariant a, albums) {
                QString album = a.toMap().value("album").toString();
                QString year = a.toMap().value("year").toString();
                QVariantList songs = a.toMap().value("songs").toList();

                QVariantMap newAlbum = QVariantMap();
                newAlbum.insert("type", "album");
                newAlbum.insert("artist", artist);
                newAlbum.insert("album", album);
                newAlbum.insert("year", year);
//                qDebug() << "Adding album:" << newAlbum;
                _results->addResult(newAlbum);

                QVariantList newSongs = QVariantList();
                foreach (QVariant s, songs) {
                    QString song = s.toString();

                    QVariantMap newSong = QVariantMap();
                    newSong.insert("type", "song");
                    newSong.insert("artist", artist);
                    newSong.insert("album", album);
                    newSong.insert("year", year);
                    newSong.insert("song", song);
                    newSong.insert("lyrics", "");
                    QString baseUrl = "http://lyrics.wikia.com/";
                    newSong.insert("url", baseUrl + artist + ":" + song.replace(" ", "_"));
//                    qDebug() << "Adding song:" << newSong;
                    _results->addResult(newSong);
                }
            }
        }
        //User searched for artist + song
        else if (reply->request().attribute(QNetworkRequest::User) == Song) {
            map.insert("type", "song");
            if (map.value("lyrics").toString() == "Not found") {
                map.remove("url");
            } else {
                //Fix special characters in URL
                QString url = QUrl::fromPercentEncoding(map.value("url").toUrl().toString().toUtf8());
                map.insert("url", url);
                //Song and artist come back wacky with special characters, so take them from URL
                QString info = url.split("http://lyrics.wikia.com/", QString::SkipEmptyParts)[0];
                map.insert("artist", info.split(":")[0].replace("_", " "));
                map.insert("song", info.split(":")[1].replace("_", " "));
            }
//            qDebug() << "Adding single song:" << map;
            _results->addResult(map);
        }
        //User searched for artist + album
        else if (reply->request().attribute(QNetworkRequest::User) == Album) {
            //Results are the same as just artist; have to extract specific album
            QString searchedAlbum = reply->request().url().queryItemValue("album").trimmed();
            qDebug() << Q_FUNC_INFO << searchedAlbum;
            QString artist = map.value("artist").toString();

            QVariantList albums = map.value("albums").toList();
            foreach (QVariant a, albums) {
                QString album = a.toMap().value("album").toString();

                if (album.contains(searchedAlbum)) {
                    //We've found the album the user searched for
                    QString year = a.toMap().value("year").toString();
                    QVariantList songs = a.toMap().value("songs").toList();

                    QVariantMap newAlbum = QVariantMap();
                    newAlbum.insert("type", "album");
                    newAlbum.insert("artist", artist);
                    newAlbum.insert("album", album);
                    newAlbum.insert("year", year);
    //                qDebug() << "Adding album:" << newAlbum;
                    _results->addResult(newAlbum);

                    QVariantList newSongs = QVariantList();
                    foreach (QVariant s, songs) {
                        QString song = s.toString();

                        QVariantMap newSong = QVariantMap();
                        newSong.insert("type", "song");
                        newSong.insert("artist", artist);
                        newSong.insert("album", album);
                        newSong.insert("year", year);
                        newSong.insert("song", song);
                        newSong.insert("lyrics", "");
                        QString baseUrl = "http://lyrics.wikia.com/";
                        newSong.insert("url", baseUrl + artist + ":" + song.replace(" ", "_"));
    //                    qDebug() << "Adding song:" << newSong;
                        _results->addResult(newSong);
                    }
                }
            }
        }
    } else {
        qWarning() << Q_FUNC_INFO << "Reply from" << reply->url() << "contains error" << reply->errorString();
        qWarning() << Q_FUNC_INFO << response;
    }

    reply->deleteLater();
    qDebug() << _results->getInternalDB();

    Page *page = _root->top();
    Container *container = page->findChild<Container*>("activityContainer");
    if (container) {
        container->setVisible(false);
    } else {
        qDebug() << Q_FUNC_INFO << "No activity container on top page";
    }
}
