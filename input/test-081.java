import io.tsduck.AbstractAsyncReport;
import io.tsduck.Report;
import io.tsduck.TSProcessor;

public class Test081 {

    private static String tsJsonMarker = "[_TS_JSON_]";
    private static String sdtXmlMarker = "[_SDT_XML_]";

    private static class Logger extends AbstractAsyncReport {
        public Logger() {
            super(Report.Info, false, 512);
        }
        @Override
        public void logMessageHandler(int severity, String message) {
            System.out.printf("%d: %s\n", severity, message);
        }
    }

    public static void main(String[] args) {
        Logger rep = new Logger();
        rep.info("application message");
        TSProcessor tsp = new TSProcessor(rep);
        tsp.addInputStuffingNull = 1;
        tsp.addInputStuffingInput = 10;
        tsp.input = new String[] {"file", args[0]};
        tsp.plugins = new String[][] {
            {"analyze", "--deterministic", "--json-line=" + tsJsonMarker},
            {"tables", "--pid", "0x11", "--tid", "0x42", "--max-tables", "1", "--log-xml-line=" + sdtXmlMarker}
        };
        tsp.output = new String[] {"drop"};
        tsp.start();
        tsp.waitForTermination();
        tsp.delete();
        rep.terminate();
        rep.delete();
    }
}
