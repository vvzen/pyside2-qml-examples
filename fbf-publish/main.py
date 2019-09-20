# -*- coding: utf-8 -*-
import sys

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtWidgets as qtw
from PySide2 import QtQml as qml


class Backend(qtc.QObject):

    def __init__(self):
        super(Backend, self).__init__()

    @Slot()
    def parseInputs(self):
        pass


def main():

    # sys.argv += ['--style', 'material']
    app = qtw.QApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    engine.load(qtc.QUrl('main.qml'))

    if not engine.rootObjects:
        sys.exit(-1)

    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
