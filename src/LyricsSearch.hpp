#ifndef LYRICSSEARCH_HPP_
#define LYRICSSEARCH_HPP_

#include "ResultsDataModel.hpp"
#include <QObject>
#include <bb/cascades/QListDataModel>
#include <bb/cascades/NavigationPane>
#include <bb/cascades/Dialog>

using namespace bb::cascades;

class LyricsSearch : public QObject {
    Q_OBJECT;

public:
    enum RequestType {
        Undefined,
        Artist,
        Song,
        Album
    };
    LyricsSearch();
    virtual ~LyricsSearch();
    Q_INVOKABLE void search(QVariantMap query);
    Q_INVOKABLE void addFavourite(QVariantMap fav);
    Q_INVOKABLE void removeFavourite(QVariantMap fav);
    Q_INVOKABLE QString getVersionNumber();
    void toast(QString message);

private:
    QMapListDataModel *_favourites;
    ResultsDataModel *_results;
    NavigationPane *_root;
    Dialog *_activityDialog;
    QNetworkConfigurationManager *_netConfigMan;
    QNetworkAccessManager *_netAccessMan;

signals:
    void activityStarted(QString message="Searching...");
    void activityEnded();

private slots:
    void onActivityStarted(QString message="Searching...");
    void onActivityEnded();
    void onFinished(QNetworkReply *reply);
};

#endif /* LYRICSSEARCH_HPP_ */
