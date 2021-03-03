# test-086.py

import ts, sys

# A Python class which handles TSDuck log messages.
class Logger(ts.AbstractAsyncReport):
    # This method is invoked each time a message is logged by TSDuck.
    def log(self, severity, message):
        print(ts.Report.header(severity) + message)

# A Python class which handles input streaam.
class InputHandler(ts.AbstractPluginEventHandler):
    # Constructor.
    def __init__(self, file_name):
        super().__init__()
        self.file = open(file_name, "rb")

    # This event handler is called each time the memory plugin needs input packets.
    def handlePluginEvent(self, context, data):
        return self.file.read(context.max_data_size)

    # Close input file and delete object.
    def delete(self):
        self.file.close()
        super().delete()

# A Python class which handles input streaam.
class OutputHandler(ts.AbstractPluginEventHandler):
    # Constructor.
    def __init__(self, file_name):
        super().__init__()
        self.file = open(file_name, "wb")

    # This event handler is called each time the memory plugin sends output packets.
    def handlePluginEvent(self, context, data):
        self.file.write(data)
        return True

    # Close output file and delete object.
    def delete(self):
        self.file.close()
        super().delete()

# Main program:
report = Logger()
input = InputHandler(sys.argv[1])
output = OutputHandler(sys.argv[2])

tsp = ts.TSProcessor(report)
tsp.registerInputEventHandler(input)
tsp.registerOutputEventHandler(output)

tsp.input = ['memory']
tsp.plugins = [ ['count'] ]
tsp.output = ['memory']

tsp.start()
tsp.waitForTermination()
tsp.delete()

input.delete()
output.delete()
report.terminate()
report.delete()
