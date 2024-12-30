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

QColor GravatarHelper::groupAvatarColor(const QString &groupName) const {
    if (groupName.isEmpty()) {
        return {};
    }
    auto ba = QCryptographicHash::hash(groupName.toUtf8(), QCryptographicHash::Sha256);
    auto color = QColor(static_cast<quint8>(ba[0]), static_cast<quint8>(ba[1]), static_cast<quint8>(ba[2]));
    if (color.saturation() < 160) {
        color.setHsv(color.hue(), 160, color.value());
    }
    return color;
}
