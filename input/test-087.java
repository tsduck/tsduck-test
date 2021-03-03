import java.io.*;
import java.util.*;
import io.tsduck.*;

public class Test087 {

    private static class Logger extends AbstractAsyncReport {
        public Logger() {
            super(Report.Info, false, 512);
        }
        @Override
        public void logMessageHandler(int severity, String message) {
            System.out.println(Report.header(severity) + message);
        }
    }

    private static class InputHandler extends AbstractPluginEventHandler {
        InputStream file = null;
        public InputHandler(String fileName) throws Exception {
            file = new FileInputStream(fileName);
        }
        @Override
        public boolean handlePluginEvent(PluginEventContext context, byte[] data) {
            try {
                byte[] input = new byte[context.maxDataSize()];
                int size = file.read(input);
                if (size > 0) {
                    int rd = 0;
                    while (size % TS.PKT_SIZE != 0 && (rd = file.read(input, size, TS.PKT_SIZE - size % TS.PKT_SIZE)) > 0) {
                        size += rd;
                    }
                    if (size == input.length) {
                        context.setOutputData(input);
                    }
                    else {
                        context.setOutputData(Arrays.copyOfRange(input, 0, size));
                    }
                }
            }
            catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
        @Override
        public void delete() {
            try {
                file.close();
            }
            catch (Exception e) {
                e.printStackTrace();
            }
            super.delete();
        }
    }

    private static class OutputHandler extends AbstractPluginEventHandler {
        OutputStream file = null;
        public OutputHandler(String fileName) throws Exception {
            file = new FileOutputStream(fileName);
        }
        @Override
        public boolean handlePluginEvent(PluginEventContext context, byte[] data) {
            try {
                file.write(data);
            }
            catch (Exception e) {
                e.printStackTrace();
            }
            return true;
        }
        @Override
        public void delete() {
            try {
                file.close();
            }
            catch (Exception e) {
                e.printStackTrace();
            }
            super.delete();
        }
    }

    public static void main(String[] args) throws Exception {
        Logger report = new Logger();
        InputHandler input = new InputHandler(args[0]);
        OutputHandler output = new OutputHandler(args[1]);

        TSProcessor tsp = new TSProcessor(report);
        tsp.registerInputEventHandler(input);
        tsp.registerOutputEventHandler(output);

        tsp.input = new String[] {"memory"};
        tsp.plugins = new String[][] {{"count"}};
        tsp.output = new String[] {"memory"};

        tsp.start();
        tsp.waitForTermination();
        tsp.delete();

        input.delete();
        output.delete();
        report.terminate();
        report.delete();
    }
}
