package de.wwu.pi.mdsd05.framework.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JSeparator;

public abstract class AbstractStartWindow extends AbstractWindow {

	private int curGridY = 0;

	public int getNextGridY() {
		return curGridY++;
	}

	/**
	 * Create the application.
	 */

	public AbstractStartWindow() {
		super(null, 450, 400);
	}

	/**
	 * Initialize the content of the frame.
	 * 
	 */
	@Override
	public void createContents() {
		Container frame = getPanel();
		frame.setBounds(100, 100, 450, 300);
		GridBagLayout gridBagLayout = new GridBagLayout();
		gridBagLayout.columnWidths = new int[] { 0, 0, 0 };
		frame.setLayout(gridBagLayout);

		JLabel lblNewLabel = new JLabel("Please Select an Option");
		GridBagConstraints gbc_lblNewLabel = new GridBagConstraints();
		gbc_lblNewLabel.gridwidth = 3;
		gbc_lblNewLabel.insets = new Insets(0, 0, 5, 0);
		gbc_lblNewLabel.gridx = 0;
		gbc_lblNewLabel.gridy = getNextGridY();
		frame.add(lblNewLabel, gbc_lblNewLabel);

		// emtpy grid line
		getNextGridY();

		// put choice buttons here
		ListChoices();

		// Separator at the bottom to create empty
		// space at the end of the window
		JSeparator separator = new JSeparator();
		GridBagConstraints gbc_separator = new GridBagConstraints();
		gbc_separator.insets = new Insets(0, 0, 0, 5);
		gbc_separator.gridx = 1;
		gbc_separator.gridy = getNextGridY();
		gbc_separator.weighty = 1;
		frame.add(separator, gbc_separator);
	}

	@Override
	protected String getTitle() {
		return "Application Start Window";
	}
	
	/**
	 * is called to print different choice-Buttons within the Grid.
	 * use getNewGridY to get the next y value.
	 */
	protected abstract void ListChoices();
}
