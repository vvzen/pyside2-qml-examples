from __future__ import print_function
import os
import sys
import time
import random

from PySide6 import QtCore as qtc
from PySide6 import QtGui as qtg
from PySide6 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))


class RunnableSignals(qtc.QObject):
    completed = qtc.Signal(list)


class RunnableExample(qtc.QRunnable):

    def __init__(self):
        super(RunnableExample, self).__init__()
        self.signals = RunnableSignals()

    def run(self):

        print('started long thread calculation..')
        time.sleep(1)

        # This is the moment where we might interrogate our backend
        item_name = "sc010_{r}".format(r=str(random.randint(0, 100)).zfill(4))

        data_retrieved = [{
            'itemName': item_name,
            'itemIsChecked': True,
            'itemModel': [
            {
                'passName': 'beauty',
                'path': '/mnt/projects/{name}/rgba.%04d.exr'.format(name=item_name)
            },
            {
                'passName': 'crypto',
                'path': '/mnt/projects/{name}/crypto.%04d.exr'.format(name=item_name)
            },
            {
                'passName': 'position',
                'path': '/mnt/projects/{name}/position.%04d.exr'.format(name=item_name)
            }]
        }]

        self.signals.completed.emit(data_retrieved)


class Backend(qtc.QObject):

    dataRetrieved = qtc.Signal('QVariantList')

    def __init__(self):
        super(Backend, self).__init__()

    # This slot will be called from QML
    @qtc.Slot()
    def retrieve_data(self):

        print('This is a long function that will spawn a separate thread')

        separate_thread = RunnableExample()

        qtc.QThreadPool.globalInstance().start(separate_thread)
        # Connect the completed signal of the thread
        separate_thread.signals.completed.connect(self.on_thread_completed)

    def on_thread_completed(self, data):
        print('thread has finished')
        print(data)
        self.dataRetrieved.emit(data)


def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    # Bind the backend object in qml
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    # Load the target .qml file
    engine.load(qtc.QUrl.fromLocalFile(os.path.join(CURRENT_DIR, 'main.qml')))

    if not engine.rootObjects():
        return -1

    return app.exec_()


if __name__ == '__main__':
    sys.exit(main())