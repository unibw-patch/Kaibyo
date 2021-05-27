package com.dat3m.ui.options;

import com.dat3m.dartagnan.utils.Settings;
import com.dat3m.dartagnan.wmm.utils.alias.Alias;
import com.dat3m.dartagnan.wmm.utils.Mode;
import com.dat3m.ui.button.ClearButton;
import com.dat3m.ui.button.TestButton;
import com.dat3m.ui.icon.IconCode;
import com.dat3m.ui.icon.IconHelper;
import com.dat3m.ui.utils.UiOptions;

import javax.swing.*;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Arrays;
import java.util.Iterator;

import static java.lang.Math.min;
import static java.lang.Math.round;
import static javax.swing.BorderFactory.createTitledBorder;
import static javax.swing.border.TitledBorder.CENTER;

public class OptionsPane extends JPanel implements ActionListener {

	public final static int OPTWIDTH = 300;
	
    private final JLabel iconPane;

    private final BoundField boundField;
    private final GenericField entryField;
    private final GenericField secretField;
    
    private final JButton testButton;
    private final JButton clearButton;

    private final JTextPane consolePane;

    public OptionsPane(){
        super(new GridLayout(1,0));

        int height = Math.min(getIconHeight(), (int) Math.round(Toolkit.getDefaultToolkit().getScreenSize().getHeight()) * 7 / 18);
        iconPane = new JLabel(IconHelper.getIcon(IconCode.ZOMBMC, height), JLabel.CENTER);

        boundField = new BoundField();
        entryField = new GenericField("main");
        secretField = new GenericField("secret");
        
        testButton = new TestButton();
        clearButton = new ClearButton();

        consolePane = new JTextPane();
        consolePane.setEditable(false);

        bindListeners();
        mkGrid();
    }

    private void bindListeners(){
		boundField.addActionListener(this);
		entryField.addActionListener(this);
		secretField.addActionListener(this);
		clearButton.addActionListener(this);
    }

    public JButton getTestButton(){
        return testButton;
    }

    public JTextPane getConsolePane(){
        return consolePane;
    }

    public UiOptions getOptions(){
        Settings settings = new Settings(
        		Mode.KNASTER,
        		Alias.NONE,
                Integer.parseInt(boundField.getText())
        );

        String entry = entryField.getText();
        String secret = secretField.getText();

        return new UiOptions(settings, entry, secret);
    }

    private int getIconHeight(){
        return min(500, (int) round((Toolkit.getDefaultToolkit().getScreenSize().getHeight() / 2)));
    }

    private void mkGrid(){

        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setMaximumSize(new Dimension(OPTWIDTH, 120));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        JPanel boundPane = new GenericPane("Bound");
        boundPane.add(boundField);
        JPanel entryPane = new GenericPane("Entry Method");
        entryPane.add(entryField);
        JPanel secretPane = new GenericPane("Secret");
        secretPane.add(secretField);

        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        JSplitPane graphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        graphPane.setDividerSize(0);
        JComponent[] panes = { boundPane, entryPane, secretPane, testButton, clearButton, graphPane, scrollConsole };
        Iterator<JComponent> it = Arrays.asList(panes).iterator();
        JComponent current = iconPane;
        current.setBorder(emptyBorder);
        while(it.hasNext()) {
        	JComponent next = it.next();
        	current = new JSplitPane(JSplitPane.VERTICAL_SPLIT, current, next);
        	((JSplitPane)current).setDividerSize(2);
        	current.setBorder(emptyBorder);
        	if(!(next instanceof JButton)) {
            	next.setBorder(emptyBorder);
        	}
        }
        add(current);

        // Outer border
        TitledBorder titledBorder = createTitledBorder("Options");
        titledBorder.setTitleJustification(CENTER);
        setBorder(titledBorder);
    }

	@Override
	public void actionPerformed(ActionEvent e) {
		// Any change in the (relevant) options clears the console
		getConsolePane().setText("");
	}
}
