package de.wwu.pi.mdsd05.framework.gui;

import java.awt.Container;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;



import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

public abstract class AbstractEntryWindow<E extends AbstractDataClass> extends AbstractWindow {
	
	protected E currentEntity;
	protected int curGridY = 0;
	//protected JButton btnSave;
	protected ActionListener saveBtnActionListener = new ActionListener() {
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
	};
	
	public AbstractEntryWindow(AbstractWindow parent, E currentEntity,int width,int height) {
		super(parent,width,height);
		this.currentEntity = currentEntity;
	}
	@Override
	protected void createContents() {
		Container panel = getPanel();

		panel.setLayout(null);
		
		createUIElements();
		createLists();
		
		/*btnSave = new JButton(currentEntity.isNew() ? "Create" : "Update");
		GridBagConstraints gbc_btnSave = new GridBagConstraints();
		gbc_btnSave.insets = new Insets(0, 0, 5, 0);
		gbc_btnSave.gridx = 1;
		gbc_btnSave.gridy = getNextGridYValue();
		panel.add(btnSave, gbc_btnSave);
		
		
		btnSave.addActionListener(saveBtnActionListener);*/
		
		/*
		createLists() might be obsolete
		 
		JPanel fill1 = new JPanel();
		GridBagConstraints gbc_fill1 = new GridBagConstraints();
		gbc_fill1.gridx = 0;
		gbc_fill1.gridy = getNextGridYValue();
		gbc_fill1.fill = GridBagConstraints.REMAINDER;
		panel.add(fill1,gbc_fill1);
		
		createLists();
		
		JSeparator separator = new JSeparator();
		GridBagConstraints gbc_separator = new GridBagConstraints();
		gbc_separator.gridwidth = GridBagConstraints.REMAINDER;
		gbc_separator.insets = new Insets(0, 0, 0, 5);
		gbc_separator.gridx = 0;
		gbc_separator.gridy = getNextGridYValue();
		gbc_separator.weighty = 0.5;
		panel.add(separator, gbc_separator);*/
	}
	
	@Override
	protected String getTitle() {
		return "Edit " + currentEntity.getClass().getSimpleName() + " Window";
	}
		
	protected abstract void createUIElements();
	protected abstract void createLists();
	protected abstract boolean saveAction() throws ParseException, NumberFormatException;
}
