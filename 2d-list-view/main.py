import os
import sys
import time

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))


class RunnableSignals(qtc.QObject):
    completed = qtc.Signal(list)


class RunnableExample(qtc.QRunnable):

    def __init__(self):
        super(RunnableExample, self).__init__()
        self.signals = RunnableSignals()

    def run(self):

        print 'started long thread calculation..'

        time.sleep(2)

        data_retrieved = [{
            'itemName':
            'asset_010',
            'itemIsChecked':
            True,
            'itemModel': [{
                'passName': 'crypto',
                'path': '/mnt/projects'
            }, {
                'passName': 'position',
                'path': '/mnt/projects'
            }]
        }]

        print 'emitting completed signal'

        self.signals.completed.emit(data_retrieved)


class Backend(qtc.QObject):

    dataRetrieved = qtc.Signal('QVariantList')

    def __init__(self):
        super(Backend, self).__init__()

    # # Register the model as a property that notifies a signal when changes
    # @qtc.Property('QVariant', constant=False, notify=modelChanged)
    # def model(self):
    #     return self._model

    # This slot will be called from QML
    @qtc.Slot()
    def retrieve_data(self):

        print 'This is a long function that will spawn a separate thread'

        separate_thread = RunnableExample()

        qtc.QThreadPool.globalInstance().start(separate_thread)
        # Connect the completed signal of the thread
        separate_thread.signals.completed.connect(self.on_thread_completed)

    def on_thread_completed(self, data):
        print 'thread has finished'
        print data
        self.dataRetrieved.emit(data)


def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    # Bind the backend object in qml
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    engine.load(qtc.QUrl.fromLocalFile(os.path.join(CURRENT_DIR, 'main.qml')))

    if not engine.rootObjects():
        return -1

    return app.exec_()


if __name__ == '__main__':
    sys.exit(main())