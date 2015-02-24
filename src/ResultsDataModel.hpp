#ifndef RESULTSDATAMODEL_CPP_
#define RESULTSDATAMODEL_CPP_

#include <bb/cascades/DataModel>

class ResultsDataModel : public bb::cascades::DataModel {
    Q_OBJECT;
    Q_PROPERTY(bool empty READ empty NOTIFY emptyChanged);

public:
    ResultsDataModel(QObject *parent = 0);

    void clear();
    void addResult(QVariantMap result);
    QVariantList getInternalDB();
    bool empty();

    virtual int childCount(const QVariantList &indexPath);
    virtual bool hasChildren(const QVariantList &indexPath);
    virtual QVariant data(const QVariantList &indexPath);
    virtual QString itemType(const QVariantList &indexPath);

private:
    QVariantList _internalDB;
    bool _empty;

signals:
    void emptyChanged(bool empty);
};

#endif /* RESULTSDATAMODEL_CPP_ */
