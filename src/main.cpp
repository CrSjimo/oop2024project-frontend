#include <QQmlApplicationEngine>
#include <QGuiApplication>

int main(int argc, char *argv[]) {
    QGuiApplication a(argc, argv);

    QQmlApplicationEngine engine(":/qt/qml/dev/sjimo/oop2024projectfrontend/main.qml");

    return a.exec();
}
