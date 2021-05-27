package com.dat3m.ui.options;

import static java.awt.FlowLayout.LEFT;

import java.awt.FlowLayout;

import javax.swing.JLabel;
import javax.swing.JPanel;

public class GenericPane extends JPanel {

	public GenericPane(String name) {
        super(new FlowLayout(LEFT));
        add(new JLabel(name + ": "));
	}
}
