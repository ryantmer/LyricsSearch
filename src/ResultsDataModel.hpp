#ifndef RESULTSDATAMODEL_CPP_
#define RESULTSDATAMODEL_CPP_

#include <bb/cascades/DataModel>

class ResultsDataModel : public bb::cascades::DataModel {
    Q_OBJECT
public:
    ResultsDataModel(QObject *parent = 0);

    void clear();
    void addResult(QVariantMap result);
    QVariantList getInternalDB();

    virtual int childCount(const QVariantList &indexPath);
    virtual bool hasChildren(const QVariantList &indexPath);
    virtual QVariant data(const QVariantList &indexPath);
    virtual QString itemType(const QVariantList &indexPath);

private:
    QVariantList _internalDB;
};

#endif /* RESULTSDATAMODEL_CPP_ */
