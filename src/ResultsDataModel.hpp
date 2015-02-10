#ifndef RESULTSDATAMODEL_CPP_
#define RESULTSDATAMODEL_CPP_

#include <bb/cascades/GroupDataModel>

class ResultsDataModel : public bb::cascades::GroupDataModel {
public:
    ResultsDataModel();
    virtual ~ResultsDataModel();

    virtual QString itemType(const QVariantList &indexPath);
};

#endif /* RESULTSDATAMODEL_CPP_ */
