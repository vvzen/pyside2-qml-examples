# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import sys

from PySide6 import QtCore as qtc
from PySide6 import QtGui as qtg
from PySide6 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

# This just mimics whatever database you might have
class MyDB(object):

    shows = {
        'the_witcher_season_2': {
            'sc010': ['sc010_0010', 'sc010_0010'],
            'sc020': ['sc020_0040', 'sc020_0050'],
        },
        'lotr_season_1': {
            'sc030': ['sc030_0020', 'sc030_0030'],
            'sc040': ['sc040_0040', 'sc040_0050'],
        },
        'the_crown_season_5': {
            'sc050': ['sc050_0010', 'sc050_0020'],
            'sc060': ['sc060_0040', 'sc060_0050'],
        },
        'an_awfully_long_show_name_that_you_should_avoid': {
            'sc090': ['sc090_0010', 'sc090_0020'],
        },
    }

    dccs = {
        "maya": ["2021", "2022"],
        "houdini": ["18.5", "19.0", "19.5"],
        "nuke": ["11.2v3", "11.3v4", "12.3v2"],
    }


# This class will be accessible within the QML context
class Backend(qtc.QObject):

    db = MyDB()

    def __init__(self):
        super(Backend, self).__init__()

    @qtc.Slot(result='QVariantList')
    def get_shows(self):
        shows = sorted(list(self.db.shows.keys()))
        return shows

    @qtc.Slot(str, result='QVariantList')
    def get_sequences_for_show(self, show_name):
        sequences = sorted(list(self.db.shows[show_name].keys()))
        return sequences

    @qtc.Slot(str, str, result='QVariantList')
    def get_shots_for_sequence(self, show_name, sequence_name):
        shots = self.db.shows[show_name][sequence_name]
        return sorted(list(shots))

    @qtc.Slot(result='QVariantList')
    def get_dccs(self):
        return sorted(list(self.db.dccs.keys()))

    @qtc.Slot(str, result='QVariantList')
    def get_dcc_versions(self, dcc_name):
        return sorted(list(self.db.dccs[dcc_name]))

    # A QVariantMap can be used to pass a POJO(1) to Python and interpret them
    # as native python dictionaries
    # (1) -> Plain Old Javascript Object
    @qtc.Slot('QVariantMap')
    def launch(self, context):
        print(context)
        context = dict(context)
        print(("Running {show}/{sequence}/{shot} "
               "in {dcc} {dcc_version}").format(**context))


def main():

    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    # Make the backend object accessible in QML via the 'backend' keyword
    # See https://doc.qt.io/qt-5/qqmlcontext.html
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    # Load the qml file
    engine.load(qtc.QUrl(os.path.join(CURRENT_DIR, 'main.qml')))

    if not engine.rootObjects:
        sys.exit(-1)

    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
