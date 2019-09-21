import os
import sys
from functools import partial

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))


class AssetModel(qtc.QAbstractListModel):
    NameRole = qtc.Qt.UserRole + 1000
    CheckedRole = qtc.Qt.UserRole + 1001

    # TypeRole = qtc.Qt.UserRole + 1001

    def __init__(self, parent=None):
        super(AssetModel, self).__init__(parent)
        self._assets = []

    def rowCount(self, parent=qtc.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._assets)

    def data(self, index, role=qtc.Qt.DisplayRole):

        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._assets[index.row()]

            if role == AssetModel.NameRole:
                return item['assetName']

            # elif role == AssetModel.CheckedRole:
            #     return item['assetIsChecked']

    def roleNames(self):
        roles = dict()
        roles[AssetModel.NameRole] = b'assetName'
        roles[AssetModel.CheckedRole] = b'assetIsChecked'
        return roles

    @qtc.Slot(str)
    def appendRow(self, name):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(),
                             self.rowCount())
        self._assets.append({'assetName': name})
        self.endInsertRows()


class Backend(qtc.QObject):

    modelChanged = qtc.Signal()

    def __init__(self, parent=None):
        super(Backend, self).__init__(parent)
        self._model = AssetModel()

    @qtc.Property(qtc.QObject, constant=False, notify=modelChanged)
    def model(self):
        return self._model


def test(model):
    # n = "name{}".format(model.rowCount())
    # t = "type{}".format(model.rowCount())
    model.appendRow('env_building_010')


def main():
    app = qtg.QGuiApplication(sys.argv)

    backend = Backend()
    engine = qml.QQmlApplicationEngine()
    engine.rootContext().setContextProperty("provider", backend)

    engine.load(qtc.QUrl.fromLocalFile(os.path.join(CURRENT_DIR, 'main.qml')))

    if not engine.rootObjects():
        return -1

    # timer = qtc.QTimer(interval=500)
    # timer.timeout.connect(partial(test, backend.model))
    # timer.start()

    return app.exec_()


if __name__ == '__main__':
    sys.exit(main())