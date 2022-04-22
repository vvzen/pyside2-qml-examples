import os
import sys

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))


class MyListModel(qtc.QAbstractListModel):
    # Our custom roles
    NameRole = qtc.Qt.UserRole + 1000
    CheckedRole = qtc.Qt.UserRole + 1001

    def __init__(self, parent=None):
        super(MyListModel, self).__init__(parent)
        self._assets = []

    def rowCount(self, parent=qtc.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._assets)

    def data(self, index, role=qtc.Qt.DisplayRole):

        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._assets[index.row()]

            if role == MyListModel.NameRole:
                return item['assetName']

            elif role == MyListModel.CheckedRole:
                return item['assetIsChecked']

    def roleNames(self):
        roles = dict()
        roles[MyListModel.NameRole] = b'assetName'
        roles[MyListModel.CheckedRole] = b'assetIsChecked'
        return roles

    # This can be called from the QML side
    @qtc.Slot(str, bool)
    def appendRow(self, name, ischecked):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(),
                             self.rowCount())
        self._assets.append({'assetName': name, 'assetIsChecked': ischecked})
        self.endInsertRows()


class Backend(qtc.QObject):

    modelChanged = qtc.Signal()

    def __init__(self, parent=None):
        super(Backend, self).__init__(parent)
        self._model = MyListModel()

    # Expose model as a property of our backend
    @qtc.Property(qtc.QObject, constant=False, notify=modelChanged)
    def model(self):
        return self._model


def test_add_item(model):
    model.appendRow('test_item', True)


def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    # Bind the backend object in qml
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    engine.load(qtc.QUrl.fromLocalFile(os.path.join(CURRENT_DIR, 'main.qml')))

    test_add_item(backend.model)

    if not engine.rootObjects():
        return -1

    return app.exec_()


if __name__ == '__main__':
    sys.exit(main())