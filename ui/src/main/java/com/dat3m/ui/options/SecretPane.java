package com.dat3m.ui.options;

import static java.awt.FlowLayout.LEFT;

import java.awt.FlowLayout;

import javax.swing.JLabel;
import javax.swing.JPanel;

public class SecretPane extends JPanel {

	public SecretPane() {
        super(new FlowLayout(LEFT));
        add(new JLabel("Secret: "));
	}
}
