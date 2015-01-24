#ifndef LYRICWIKIA_HPP_
#define LYRICWIKIA_HPP_

#include <QObject>
#include <bb/cascades/QListDataModel>
#include <bb/cascades/NavigationPane>

using namespace bb::cascades;

class LyricWikia : public QObject {
    Q_OBJECT;

public:
    LyricWikia();
    virtual ~LyricWikia();
    Q_INVOKABLE void search(QVariantMap query);

private:
    QMapListDataModel *_favourites;
    QMapListDataModel *_searchResults;
    NavigationPane *_root;
    QNetworkConfigurationManager *_netConfigMan;
    QNetworkAccessManager *_netAccessMan;

private slots:
    void onFinished(QNetworkReply *reply);
};

#endif /* LYRICWIKIA_HPP_ */
