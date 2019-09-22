# Nested List View
This example shows how to send a nested data structure (list of lists) from Python to QML.

When the button is pressed, the QML frontend will request data to the backend, which will then retrieve it using a thread.
This guarantees that the QML UI will not freeze (since you're not blocking its UI thread).

After the thread on the backend has completed successfully, it will emit a signal and then the backend object will emit a signal himself containing all of the retrieved data.

I think this example is a good one since you don't need to subclass any QAbstractListModel or other models at all.

You're basically just sending JSON stuff between QML and python, which in my opinion is just super cool and very effective.
In this way you can easily construct a nested list without writing too much code.

For more simple scenarios, I would still refer to the list-view example, which exposes the model as a property of the backend and listens to its changes.
