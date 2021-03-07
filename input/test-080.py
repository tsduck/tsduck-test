# test-080.py

import tsduck
import sys
import json
import xml.etree.ElementTree as xmlet

input_file = sys.argv[1]
ts_json_marker = "[_TS_JSON_]"
sdt_xml_marker = "[_SDT_XML_]"

# Process the parsed JSON data from the TS analysis.
def process_ts_json(data):
    print('Services from TS analysis:')
    for srv in data['services']:
        print('Name: "%s", provider: "%s", bitrate: %d b/s' % (srv['name'], srv['provider'], srv['bitrate']))

# Process the parsed XML data from the SDT.
def process_sdt_xml(root):
    sdt = root.find('./SDT')
    if sdt != None:
        version = int(sdt.attrib['version'], base=0)
        ts_id = int(sdt.attrib['transport_stream_id'], base=0)
        nw_id = int(sdt.attrib['original_network_id'], base=0)
        print('SDT version: %d, TS id: %d, original network id: %d' % (version, ts_id, nw_id))
        for srv in sdt.findall('./service'):
            id = int(srv.attrib['service_id'], base=0)
            sdesc = srv.find('./service_descriptor')
            if sdesc == None:
                name = '(unknown)'
                provider = '(unknown)'
            else:
                name = sdesc.attrib['service_name']
                provider = sdesc.attrib['service_provider_name']
            print('Service id: %d, name: "%s", provider: "%s"' % (id, name, provider))

# A Python class which handles TSDuck log messages.
class Logger(tsduck.AbstractAsyncReport):
    # This method is invoked each time a message is logged by TSDuck.
    def log(self, severity, message):
        # Filter, locate, extract and parse the JSON output from plugin "analyze".
        pos = message.find(ts_json_marker)
        if pos >= 0:
            process_ts_json(json.loads(message[pos+len(ts_json_marker):]))
        else:
            pos = message.find(sdt_xml_marker)
            if pos >= 0:
                process_sdt_xml(xmlet.fromstring(message[pos+len(sdt_xml_marker):]))

# Main program:
rep = Logger()
tsp = tsduck.TSProcessor(rep)
tsp.input = ['file', input_file]
tsp.plugins = [
    ['analyze', '--json-line=' + ts_json_marker],
    ['tables', '--pid', '0x11', '--tid', '0x42', '--max-tables', '1', '--log-xml-line=' + sdt_xml_marker]
]
tsp.output = ['drop']
tsp.start()
tsp.waitForTermination()
tsp.delete()
rep.terminate()
rep.delete()
