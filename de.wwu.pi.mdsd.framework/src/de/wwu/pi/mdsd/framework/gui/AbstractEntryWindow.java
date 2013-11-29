package de.wwu.pi.mdsd.framework.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;

import javax.swing.JButton;
import javax.swing.JPanel;
import javax.swing.JSeparator;

import de.wwu.pi.mdsd.framework.data.AbstractDataClass;

public abstract class AbstractEntryWindow<E extends AbstractDataClass> extends AbstractWindow {
	
	protected E currentEntity;
	protected int curGridY = 0;
	protected JButton btnSave;
	
	public AbstractEntryWindow(AbstractWindow parent, E currentEntity) {
		super(parent);
		this.currentEntity = currentEntity;
	}
	@Override
	protected void createContents() {
		Container panel = getPanel();

		GridBagLayout gbl = new GridBagLayout();
		gbl.columnWeights = new double[]{.1, .25, .25,.25,Double.MIN_VALUE};
		panel.setLayout(gbl);
		
		//set Current Y-Value
		curGridY = 0;
		createFields();
		
		btnSave = new JButton(currentEntity.isNew() ? "Create" : "Update");
		GridBagConstraints gbc_btnSave = new GridBagConstraints();
		gbc_btnSave.insets = new Insets(0, 0, 5, 0);
		gbc_btnSave.gridx = 1;
		gbc_btnSave.gridy = getNextGridYValue();
		panel.add(btnSave, gbc_btnSave);
		btnSave.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				try {
					if (saveAction())
						AbstractEntryWindow.this.closeWindow();
				} catch (NumberFormatException e) {
					Util.showUserMessage("Wrong number Format", e.getMessage());
				} catch (ParseException e) {
					Util.showUserMessage("Wrong Date Format", "Was not able to parse the given Date '" + e.getMessage() + "'. Please format the date as follows: dd.mm.yyyy");
				}
			}
		});
		
		JSeparator separator = new JSeparator();
		GridBagConstraints gbc_separator = new GridBagConstraints();
		gbc_separator.gridwidth = GridBagConstraints.REMAINDER;
		gbc_separator.insets = new Insets(0, 0, 0, 5);
		gbc_separator.gridx = 0;
		gbc_separator.gridy = getNextGridYValue();
		gbc_separator.weighty = 0.5;
		panel.add(separator, gbc_separator);
		
		createLists();
		
		separator = new JSeparator();
		gbc_separator.gridy = getNextGridYValue();
		panel.add(separator, gbc_separator);
	}
	
	@Override
	protected String getTitle() {
		return "Edit " + currentEntity.getClass().getSimpleName() + " Window";
	}
		
	protected int getNextGridYValue() {
		return curGridY++;
	}
	
	protected abstract void createFields();
	protected abstract void createLists();
	protected abstract boolean saveAction() throws ParseException, NumberFormatException;
}
