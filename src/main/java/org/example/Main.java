package org.example;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.antlr.v4.runtime.tree.*;
import org.antlr.v4.gui.TreeViewer;
import javax.swing.*;
import java.util.Arrays;
//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Main {

    public static class ThrowingErrorListener extends BaseErrorListener {
        public static final ThrowingErrorListener INSTANCE = new ThrowingErrorListener();

        @Override
        public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol,
                                int line, int charPositionInLine,
                                String msg, RecognitionException e) {
            // Vyhození výjimky s přesným řádkem, pozicí a popisem chyby
            throw new ParseCancellationException("Error on line: " + line + " (character " + charPositionInLine + "): " + msg);
        }
    }

    static void main() throws Exception {
        // create a stream of the code from our code file
        CharStream input = CharStreams.fromFileName("data/incorectCode5.pel");

        // make a tokes from our input code
        CustomLangLexer lexer = new CustomLangLexer(input);

        // remove error for our error handeling
        lexer.removeErrorListeners();
        lexer.addErrorListener(ThrowingErrorListener.INSTANCE);

        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CustomLangParser parser = new CustomLangParser(tokens);

        // remove error for our error handeling
        parser.removeErrorListeners();
        parser.addErrorListener(ThrowingErrorListener.INSTANCE);

        try {
            System.out.println("Starting to parse...");
            // cretate the tree from our code
            ParseTree tree = parser.program();
            // print the tree
            System.out.println("Parsing finised!");
            System.out.println(tree.toStringTree());

            // === grafic showing of the tree ===
            JFrame frame = new JFrame("Syntaktický strom - CustomLang");
            JPanel panel = new JPanel();
            TreeViewer viewer = new TreeViewer(Arrays.asList(parser.getRuleNames()), tree);
            viewer.setScale(1.2);
            panel.add(viewer);
            frame.add(new JScrollPane(panel));
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(800, 600);
            frame.setVisible(true);
        } catch (ParseCancellationException e) {
            System.out.println("Compilation failed: " + e.getMessage());
        }
    }
}
