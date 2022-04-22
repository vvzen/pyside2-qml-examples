# -*- coding: utf-8 -*-
from __future__ import print_function
import sys
import os

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtWidgets as qtw
from PySide2 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

# This just mimics whatever database you might have
class MyDB(object):

    data = {
        'the_witcher_season_2': {
            'sc010': ['sc010_0010', 'sc010_0010'],
            'sc020': ['sc020_0040', 'sc020_0050'],
        },
        'lotr_season_1': {
            'sc030': ['sc030_0020', 'sc030_0030'],
            'sc040': ['sc040_0040', 'sc040_0050'],
        },
        'the_crown_season_5': {
            'sc050': ['sc050_0010', 'sc050_0010'],
            'sc060': ['sc060_0040', 'sc060_0050'],
        },
        'an_awfully_long_show_name_that_you_should_avoid': {
            'sc090': ['sc090_0010', 'sc090_0020'],
        },
    }



class CurrentContext(object):
    pass


# This class will be accessible within the QML context
class Backend(qtc.QObject):

    db = MyDB()

    showsChanged = qtc.Signal('QVariantList')

    def __init__(self):
        super(Backend, self).__init__()

    @qtc.Slot(result='QVariantList')
    def get_shows(self):
        shows = sorted(list(self.db.data.keys()))
        print(shows)
        return shows
        #self.showsRetrieved.emit(shows)

    @qtc.Slot(str)
    def get_sequences_for_show(self, show_name):
        return self.db.data[show_name].keys()

    @qtc.Slot(str)
    def get_shots_for_sequence(self, show_name, sequence_name):
        sequences = self.get_sequences_for_show(show_name)
        return sequences[sequence_name]

    # --------------------------------------------------------------------------
    @qtc.Slot(str)
    def showUpdatedSlot(self, name):
        print('New show name:', name)
        return self.db.get_sequences_for_show(name)

    @qtc.Slot(str)
    def sequenceUpdatedSlot(self, name):
        print('New sequence name:', name)
        return self.db.get_shots_for_sequence(name)

    @qtc.Slot(str)
    def shotUpdatedSlot(self, name):
        print('New shot name', name)



def main():

    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    # Here we make the backend object accessible in QML via the 'backed' keyword
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    engine.load(qtc.QUrl(os.path.join(CURRENT_DIR, 'main.qml')))

    if not engine.rootObjects:
        sys.exit(-1)

    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
