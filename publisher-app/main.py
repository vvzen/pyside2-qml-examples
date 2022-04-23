# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import re
import sys
import math
import time
import pprint

from PySide2 import QtCore as qtc
from PySide2 import QtGui as qtg
from PySide2 import QtQml as qml

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))

# Some example regex used to filter the files
ACCEPTED_EXTENSIONS_REGEX = re.compile(r'(\w+)\.(\w+)\.(exr|tiff|png|dpx)')
RENDER_LAYER_REGEX = re.compile(r'\w+_\w+_v\d{3}')

pp = pprint.PrettyPrinter(indent=4)


def fit_range(x, inmin, inmax, outmin, outmax):
    """Maps a value from an interval to another

    Args:
        x (int or float): the input value
        inmin (int or float): The minimum of the input range
        inmax (int or float): The maximum of the input range
        outmin (int or float): The minimum of the desired range
        outmax (int or float): The maximum of the desired range
    Returns:
        int or float: the computed value
    """
    # Avoid division by 0
    if math.floor((inmax-inmin) + outmin) == 0.0:
        return 0.0
    return (x-inmin) * (outmax-outmin) / (inmax-inmin) + outmin


class PublishComponentsSignals(qtc.QObject):
    completed = qtc.Signal(list)
    error = qtc.Signal(str)
    progress = qtc.Signal(float)


class PublishComponentsThread(qtc.QRunnable):

    def __init__(self, assetsdata):
        super(PublishComponentsThread, self).__init__()
        self.signals = PublishComponentsSignals()
        self.assets_data = assetsdata

    def run(self):
        published_assets = []
        for i, asset in enumerate(self.assets_data):
            progress = fit_range(i, 0.0, float(len(self.assets_data) - 1), 0.15, 1.0)
            self.signals.progress.emit(progress)
            print('progress: ', progress)
            time.sleep(1)
            published_assets.append(asset['assetName'])

        self.signals.completed.emit(published_assets)


class Backend(qtc.QObject):

    dataRetrieved = qtc.Signal('QVariantList')
    publishProgress = qtc.Signal(float)
    publishCompleted = qtc.Signal('QVariantList')

    def __init__(self):
        super(Backend, self).__init__()

    @qtc.Slot(str, 'QVariantList')
    def publish(self, dept, assetsdata):
        print('publish()')
        print('dept:')
        print(dept)
        print('data:')
        pp.pprint(assetsdata)

        print(fit_range(5.0, 0.0, 10.0, 0.0, 1.0))
        print(fit_range(1.0, 0.0, 10.0, 0.0, 1.0))
        print(fit_range(9.0, 0.0, 10.0, 0.0, 1.0))
        print(fit_range(100.0, 0.0, 100.0, 0.0, 1.0))
        print(fit_range(33.0, 0.0, 50.0, 0.0, 1.0))

        publish_thread = PublishComponentsThread(assetsdata)
        publish_thread.signals.completed.connect(self.on_publish_completed)
        publish_thread.signals.progress.connect(self.on_publish_progress)
        qtc.QThreadPool.globalInstance().start(publish_thread)

    def on_publish_progress(self, value):
        self.publishProgress.emit(value)

    def on_publish_completed(self, assets):
        self.publishCompleted.emit(assets)

    # Use whatever business logic you want to process the list of paths
    @qtc.Slot('QVariant')
    def parseDraggedFiles(self, urllist):
        print('parseDraggedFile()')
        print(urllist)

        render_layers = {}

        for url in urllist:
            print(url.path())

            current_asset = None

            for root, dirnames, filenames in os.walk(url.path()):

                # Workaround for a MacOS bug of os.path.basename
                current_root = root[:-1] if root.endswith('/') else root
                dir_name = os.path.basename(current_root)

                if RENDER_LAYER_REGEX.match(dir_name):
                    current_asset = dir_name

                print('current_asset: ', current_asset)
                if current_asset not in render_layers and current_asset is not None:
                    render_layers[current_asset] = {}
                    render_layers[current_asset]['assetName'] = current_asset
                    render_layers[current_asset]['assetIsChecked'] = True
                    render_layers[current_asset]['assetComponents'] = []

                frames = sorted(
                    filter(lambda f: ACCEPTED_EXTENSIONS_REGEX.match(f),
                           filenames))

                if frames:
                    first_frame_num = re.findall(r'\d+',
                                             os.path.basename(frames[0]))[0]
                    end_frame_num = re.findall(r'\d+',
                                           os.path.basename(frames[-1]))[0]

                    pass_name = os.path.basename(root)

                    frame_name = frames[0].split('.')[0]
                    frame_ext = frames[0].split('.')[-1]
                    print('frame name: ', frame_name)
                    padding = '#' * len(first_frame_num.split('.')[-1])

                    render_layers[current_asset]['assetComponents'].append({
                        'passName': pass_name,
                        'startFrame': first_frame_num,
                        'endFrame': end_frame_num,
                        'path': '%s.%s.%s' % (frame_name, padding, frame_ext),
                        'passIsChecked': True
                    })

        returned_layers = []
        for asset_name, asset_dict in render_layers.items():
            returned_layers.append(asset_dict)

        # Emit a signal to communicate with the frontend
        self.dataRetrieved.emit(
            sorted(returned_layers, key=lambda e: e['assetName']))


def main():

    # sys.argv += ['--style', 'material']
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()
    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    engine.load(qtc.QUrl(os.path.join(CURRENT_DIR, 'main.qml')))

    if not engine.rootObjects:
        sys.exit(-1)

    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
