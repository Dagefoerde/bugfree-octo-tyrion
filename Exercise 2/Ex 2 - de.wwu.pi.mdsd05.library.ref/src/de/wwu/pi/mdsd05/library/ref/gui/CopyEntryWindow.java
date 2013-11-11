package de.wwu.pi.mdsd05.library.ref.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.JTextField;

import de.wwu.pi.mdsd05.framework.gui.AbstractWindow;
import de.wwu.pi.mdsd05.framework.gui.Util;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.data.Medium;
import de.wwu.pi.mdsd05.library.ref.logic.MediumService;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;
import de.wwu.pi.mdsd05.library.ref.logic.CopyService;

public class CopyEntryWindow extends AbstractWindow {

	private JButton btnSave;
	private int curGridY = 0;
	private Copy currentEntity;
	private JList<Object> li_Loans;
	private CopyService service;
	private MediumService mediumService;
	private JComboBox<Medium> cb_Medium;
	private JTextField tf_InventoryNumber;

	public CopyEntryWindow(AbstractWindow parent, Copy currentEntity) {
		super(parent);
		this.currentEntity = currentEntity;
		service = ServiceInitializer.getProvider().getCopyService();
		mediumService = ServiceInitializer.getProvider().getMediumService();
	}

	@Override
	protected void createContents() {
		Container panel = getPanel();

		GridBagLayout gbl = new GridBagLayout();
		gbl.columnWeights = new double[] { .1, .25, .25, .25, Double.MIN_VALUE };
		panel.setLayout(gbl);

		// set new Line
		curGridY++;

		JLabel lblMedium = new JLabel("Medium*");
		GridBagConstraints gbc_lblMedium = new GridBagConstraints();
		gbc_lblMedium.insets = new Insets(0, 0, 5, 5);
		gbc_lblMedium.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblMedium.gridx = 0;
		gbc_lblMedium.gridy = curGridY;
		getPanel().add(lblMedium, gbc_lblMedium);

		cb_Medium = new JComboBox<Medium>(new Vector<Medium> ( mediumService.getAll() ));
		cb_Medium.setSelectedItem(currentEntity.getMedium());
		GridBagConstraints gbc_cb_Medium = new GridBagConstraints();
		gbc_cb_Medium.gridwidth = 3;
		gbc_cb_Medium.insets = new Insets(0, 0, 5, 5);
		gbc_cb_Medium.anchor = GridBagConstraints.NORTHWEST;
		gbc_cb_Medium.fill = GridBagConstraints.HORIZONTAL;
		gbc_cb_Medium.gridx = 1;
		gbc_cb_Medium.weighty = .2;
		gbc_cb_Medium.gridy = curGridY++;
		getPanel().add(cb_Medium, gbc_cb_Medium);

		JLabel lblInventoryNumber = new JLabel("Inventory number*");
		GridBagConstraints gbc_lblInventoryNumber = new GridBagConstraints();
		gbc_lblInventoryNumber.insets = new Insets(0, 0, 5, 5);
		gbc_lblInventoryNumber.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblInventoryNumber.gridx = 0;
		gbc_lblInventoryNumber.gridy = curGridY;
		getPanel().add(lblInventoryNumber, gbc_lblInventoryNumber);

		tf_InventoryNumber = new JTextField(currentEntity.getInventoryNumber());
		GridBagConstraints gbc_tf_InventoryNumber = new GridBagConstraints();
		gbc_tf_InventoryNumber.gridwidth = 3;
		gbc_tf_InventoryNumber.insets = new Insets(0, 0, 5, 5);
		gbc_tf_InventoryNumber.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_InventoryNumber.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_InventoryNumber.gridx = 1;
		gbc_tf_InventoryNumber.weighty = .2;
		gbc_tf_InventoryNumber.gridy = curGridY++;
		getPanel().add(tf_InventoryNumber, gbc_tf_InventoryNumber);

		btnSave = new JButton(currentEntity.isNew() ? "Create" : "Update");
		GridBagConstraints gbc_btnSave = new GridBagConstraints();
		gbc_btnSave.insets = new Insets(0, 0, 5, 0);
		gbc_btnSave.gridx = 1;
		gbc_btnSave.gridy = curGridY++;
		panel.add(btnSave, gbc_btnSave);
		btnSave.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				try {
					if (saveAction())
						CopyEntryWindow.this.closeWindow();
				} catch (NumberFormatException e) {
					Util.showUserMessage("Wrong number Format", e.getMessage());
				} catch (ParseException e) {
					Util.showUserMessage(
							"Wrong Date Format",
							"Was not able to parse the given Date '"
									+ e.getMessage()
									+ "'. Please format the date as follows: dd.mm.yyyy");
				}
			}
		});

		JPanel fill1 = new JPanel();
		GridBagConstraints gbc_fill1 = new GridBagConstraints();
		gbc_fill1.gridx = 0;
		gbc_fill1.gridy = curGridY++;
		gbc_fill1.fill = GridBagConstraints.REMAINDER;
		panel.add(fill1, gbc_fill1);

		JLabel lblLoans = new JLabel("Copys");
		GridBagConstraints gbc_lblLoans = new GridBagConstraints();
		gbc_lblLoans.insets = new Insets(0, 0, 5, 5);
		gbc_lblLoans.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblLoans.gridx = 0;
		gbc_lblLoans.gridy = curGridY;
		getPanel().add(lblLoans, gbc_lblLoans);

		li_Loans = new JList<Object>();
		GridBagConstraints gbc_li_Loans = new GridBagConstraints();
		gbc_li_Loans.gridwidth = 3;
		gbc_li_Loans.insets = new Insets(0, 0, 5, 5);
		gbc_li_Loans.fill = GridBagConstraints.BOTH;
		gbc_li_Loans.gridx = 1;
		gbc_li_Loans.weighty = .5;
		gbc_li_Loans.gridy = curGridY;
		getPanel().add(li_Loans, gbc_li_Loans);
		
		// Button for List Element
		JButton btn = new JButton("Add");
		btn.setEnabled(!currentEntity.isNew());
		GridBagConstraints gbc_btn = new GridBagConstraints();
		gbc_btn.insets = new Insets(0, 0, 5, 0);
		gbc_btn.gridx = 1;
		gbc_btn.gridy = ++curGridY;
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				// @TODO: trigger an action
				Util.showImplementAction();
			}
		});

		btn = new JButton("Edit");
		gbc_btn.gridx = 2;
		btn.setEnabled(!currentEntity.isNew());
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Object selected = CopyEntryWindow.this.li_Loans
						.getSelectedValue();
				if (selected == null) {
					Util.showNothingSelected();
				} else {
					// @TODO: trigger an action
					Util.showImplementAction();
				}
			}
		});

		btn = new JButton("Delete");
		btn.setEnabled(false);
		gbc_btn.gridx = 3;
		getPanel().add(btn, gbc_btn);

		JSeparator separator = new JSeparator();
		GridBagConstraints gbc_separator = new GridBagConstraints();
		gbc_separator.gridwidth = GridBagConstraints.REMAINDER;
		gbc_separator.insets = new Insets(0, 0, 0, 5);
		gbc_separator.gridx = 0;
		gbc_separator.gridy = curGridY++;
		gbc_separator.weighty = 0.5;
		panel.add(separator, gbc_separator);
	}

	@Override
	protected String getTitle() {
		return "Edit Copy Window";
	}

	private boolean saveAction() throws ParseException {
		// Read values from different fields
		Medium medium = cb_Medium.getSelectedItem() == null ? null : (Medium) cb_Medium.getSelectedItem();
		int inventoryNumber = tf_InventoryNumber.getText().isEmpty() ? 0 : Integer.parseInt(tf_InventoryNumber.getText());

		// validation
		try {
			service.validateCopy(inventoryNumber, medium);
		} catch (ValidationException e) {
			Util.showUserMessage(
					"Validation error for " + e.getField(),
					"Validation error for " + e.getField() + ": "
							+ e.getMessage());
			return false;
		}

		// persist
		currentEntity = service.saveCopy(currentEntity.getOid(), inventoryNumber, medium);

		// update user listing in UserListWindow
		((CopyListWindow) getParent()).initializeCopyListing();

		return true;
	}
}
