#ifndef LYRICWIKIA_HPP_
#define LYRICWIKIA_HPP_

#include <QObject>
#include <bb/cascades/QListDataModel>
#include <bb/cascades/NavigationPane>

using namespace bb::cascades;

class LyricWikia : public QObject {
    Q_OBJECT
    Q_PROPERTY(QMapListDataModel *favourites READ favourites CONSTANT);

public:
    LyricWikia();
    virtual ~LyricWikia();
    QMapListDataModel *favourites();

private:
    QMapListDataModel *_favourites;
    NavigationPane *_root;
};

#endif /* LYRICWIKIA_HPP_ */
