import os
import sys
from functools import partial

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))


class MySubListModel(qtc.QAbstractListModel):
    # Our custom roles
    PassNameRole = qtc.Qt.UserRole + 1003

    def __init__(self, parent=None):
        super(MySubListModel, self).__init__(parent)
        self._items = []

    def rowCount(self, parent=qtc.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._items)

    def data(self, index, role=qtc.Qt.DisplayRole):

        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._items[index.row()]

            if role == MyListModel.PassNameRole:
                return item['passName']

    def appendRow(self, passname):
        # args are parent, first, last
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(),
                             self.rowCount())
        self._items.append({'passName': passname})
        self.endInsertRows()


class MyListModel(qtc.QAbstractListModel):
    # Our custom roles
    NameRole = qtc.Qt.UserRole + 1000
    CheckedRole = qtc.Qt.UserRole + 1001
    ListRole = qtc.Qt.UserRole + 1002

    def __init__(self, parent=None):
        super(MyListModel, self).__init__(parent)
        self._items = []

    def rowCount(self, parent=qtc.QModelIndex()):
        if parent.isValid():
            return 0
        return len(self._items)

    def data(self, index, role=qtc.Qt.DisplayRole):

        if 0 <= index.row() < self.rowCount() and index.isValid():
            item = self._items[index.row()]

            if role == MyListModel.NameRole:
                return item['itemName']

            elif role == MyListModel.CheckedRole:
                return item['itemIsChecked']

            elif role == MyListModel.ListRole:
                return item['itemModel']

    def roleNames(self):
        roles = dict()
        roles[MyListModel.NameRole] = b'itemName'
        roles[MyListModel.CheckedRole] = b'itemIsChecked'
        roles[MyListModel.ListRole] = b'itemModel'
        return roles

    # This can be called from the QML side
    @qtc.Slot(str, bool, list)
    def appendRow(self, name, ischecked, itemlist):
        # args are parent, first, last
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(),
                             self.rowCount())

        submodel = MySubListModel()
        for item in itemlist:
            if 'passName' in item:
                submodel.appendRow(item['passName'])

        print 'submodel: '
        print submodel._items

        self._items.append({
            'itemName': name,
            'itemIsChecked': ischecked,
            'itemModel': submodel
        })
        self.endInsertRows()

    # @qtc.Property(qtc.QObject, constant=False, notify=subModelChanged)
    # def submodel(self):
    #     return self._submodel


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
    model.appendRow('test_item', True, [{
        'passName': 'crypto'
    }, {
        'passName': 'specular'
    }])


def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    # Bind the backend object in qml
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    engine.load(qtc.QUrl.fromLocalFile(os.path.join(CURRENT_DIR, 'main.qml')))

    # test_add_item(backend.model)

    if not engine.rootObjects():
        return -1

    return app.exec_()


if __name__ == '__main__':
    sys.exit(main())