#ifndef GRAVATARHELPER_H
#define GRAVATARHELPER_H

#include <qqml.h>

class GravatarHelper : public QObject {
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT
public:
    explicit GravatarHelper(QObject *parent = nullptr);
    ~GravatarHelper() override;

    Q_INVOKABLE QString gravatarUrl(const QString &email) const;
};

#endif //GRAVATARHELPER_H
