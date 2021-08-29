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

    private final TimeoutField timeoutField;
    private final BoundField boundField;
    private final GenericField entryField;
    private final GenericField secretField;
    private final JRadioButton seButton;
    private final JRadioButton onlySpecLeak;
    private final JRadioButton aliasButton;
    
    private final JButton testButton;
    private final JButton clearButton;

    private final JTextPane consolePane;

    public OptionsPane(){
        super(new GridLayout(1,0));

        int height = Math.min(getIconHeight(), (int) Math.round(Toolkit.getDefaultToolkit().getScreenSize().getHeight()) * 7 / 18);
//        iconPane = new JLabel(IconHelper.getIcon(IconCode.ZOMBMC, height), JLabel.CENTER);
        iconPane = new JLabel();
        
        timeoutField = new TimeoutField();
        boundField = new BoundField();
        entryField = new GenericField("main");
        secretField = new GenericField("secretarray");
        seButton = new JRadioButton();
        onlySpecLeak = new JRadioButton();
        aliasButton = new JRadioButton();
        
        testButton = new TestButton();
        clearButton = new ClearButton();

        consolePane = new JTextPane();
        consolePane.setEditable(false);

        bindListeners();
        mkGrid();
    }

    private void bindListeners(){
    	timeoutField.addActionListener(this);
		boundField.addActionListener(this);
		entryField.addActionListener(this);
		secretField.addActionListener(this);
		seButton.addActionListener(this);
		onlySpecLeak.addActionListener(this);
		aliasButton.addActionListener(this);
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

        return new UiOptions(settings, Integer.valueOf(timeoutField.getText()), entryField.getText(), secretField.getText(), seButton.isSelected(), onlySpecLeak.isSelected(), aliasButton.isSelected());
    }

    private int getIconHeight(){
        return min(500, (int) round((Toolkit.getDefaultToolkit().getScreenSize().getHeight() / 2)));
    }

    private void mkGrid(){

        JScrollPane scrollConsole = new JScrollPane(consolePane);
        scrollConsole.setMaximumSize(new Dimension(OPTWIDTH, 120));
        scrollConsole.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);

        JPanel timeoutPane = new GenericPane("Timeout (secs):");
        timeoutPane.add(timeoutField);
        JPanel boundPane = new GenericPane("Bound:");
        boundPane.add(boundField);
        JPanel entryPane = new GenericPane("Entry Method:");
        entryPane.add(entryField);
        JPanel secretPane = new GenericPane("Secret:");
        secretPane.add(secretField);
        JPanel specExecPane = new GenericPane("Enable branch speculation");
        specExecPane.add(seButton);
        JPanel specLeakPane = new GenericPane("Only branch speculation leak");
        specLeakPane.add(onlySpecLeak);
        JPanel specAliasPane = new GenericPane("Enable alias speculation");
        specAliasPane.add(aliasButton);
        
        // Inner borders
        Border emptyBorder = BorderFactory.createEmptyBorder();

        JSplitPane graphPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
        graphPane.setDividerSize(0);
        JComponent[] panes = { timeoutPane, boundPane, entryPane, secretPane, specExecPane, specLeakPane, specAliasPane, testButton, clearButton, graphPane, scrollConsole };
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
