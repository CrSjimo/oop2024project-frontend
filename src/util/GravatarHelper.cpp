#include "GravatarHelper.h"
#include <QCryptographicHash>

GravatarHelper::GravatarHelper(QObject* parent) : QObject(parent) {
}

GravatarHelper::~GravatarHelper() {
}

QString GravatarHelper::gravatarUrl(const QString &email) const {
    if (email.isEmpty()) {
        return {};
    }
    return "https://www.gravatar.com/avatar/" + QCryptographicHash::hash(email.toUtf8(), QCryptographicHash::Sha256).toHex() + "?s=320&d=mp";
}
