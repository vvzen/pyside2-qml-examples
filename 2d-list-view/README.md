# Nested List View
This example is quite complete in the sense that shows how to send data back and forth between QML and python.

The QML frontend will request data to the backend, which will then retrieve it using a long threaded function.
In this way the QML UI will not be blocked.
After the thread has run successfully, a signal will be emitted by the thread and then the backend object will emit a signal on containing all of the data.
I believe this example is a good one since you don't need to subclass any QAbstractListModel at all.
You're basically just sending JSON stuff between QML and python, which in my opinion is just super cool and very fast.
In this way you can easily construct a nested list without writing too much code.
