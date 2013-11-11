package de.wwu.pi.mdsd05.library.ref.gui;

import de.wwu.pi.mdsd05.framework.gui.AbstractWindow;
import de.wwu.pi.mdsd05.framework.gui.Util;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.CD;
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.data.Loan;
import de.wwu.pi.mdsd05.library.ref.logic.BookService;
import de.wwu.pi.mdsd05.library.ref.logic.CopyService;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;
import de.wwu.pi.mdsd05.library.ref.logic.CDService;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.JTextField;

public class CDEntryWindow extends AbstractWindow implements ICopyListContainingWindow{

	private JButton btnSave;
	private int curGridY = 0;
	private CD currentEntity;
	private JList<Copy> li_Copys;
	private CDService service;
	private CopyService copyService;
	private JTextField tf_Interpreter;
	private JTextField tf_Name;
	private JTextField tf_ASIN;

		
	public CDEntryWindow(AbstractWindow parent, CD currentEntity) {
		super(parent);
		this.currentEntity = currentEntity;
		service = ServiceInitializer.getProvider().getCDService();
		copyService=ServiceInitializer.getProvider().getCopyService();
	}
	
	
	protected void createContents() {
		Container panel = getPanel();

		GridBagLayout gbl = new GridBagLayout();
		gbl.columnWeights = new double[] { .1, .25, .25, .25, Double.MIN_VALUE };
		panel.setLayout(gbl);

		// set new Line
		curGridY++;

		JLabel lblName = new JLabel("Name*");
		GridBagConstraints gbc_lblName = new GridBagConstraints();
		gbc_lblName.insets = new Insets(0, 0, 5, 5);
		gbc_lblName.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblName.gridx = 0;
		gbc_lblName.gridy = curGridY;
		getPanel().add(lblName, gbc_lblName);

		tf_Name = new JTextField(currentEntity.getName());
		GridBagConstraints gbc_tf_Name = new GridBagConstraints();
		gbc_tf_Name.gridwidth = 3;
		gbc_tf_Name.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Name.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Name.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Name.gridx = 1;
		gbc_tf_Name.weighty = .2;
		gbc_tf_Name.gridy = curGridY++;
		getPanel().add(tf_Name, gbc_tf_Name);

		JLabel lblASIN = new JLabel("ASIN*");
		GridBagConstraints gbc_lblASIN = new GridBagConstraints();
		gbc_lblASIN.insets = new Insets(0, 0, 5, 5);
		gbc_lblASIN.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblASIN.gridx = 0;
		gbc_lblASIN.gridy = curGridY;
		getPanel().add(lblASIN, gbc_lblASIN);

		String strASIN = currentEntity.isNew() ? "" : currentEntity.getASIN()+""; 
		tf_ASIN = new JTextField(strASIN);
		GridBagConstraints gbc_tf_ASIN = new GridBagConstraints();
		gbc_tf_ASIN.gridwidth = 3;
		gbc_tf_ASIN.insets = new Insets(0, 0, 5, 5);
		gbc_tf_ASIN.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_ASIN.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_ASIN.gridx = 1;
		gbc_tf_ASIN.weighty = .2;
		gbc_tf_ASIN.gridy = curGridY++;
		getPanel().add(tf_ASIN, gbc_tf_ASIN);
		
		JLabel lblInterpreter = new JLabel("Interpreter*");
		GridBagConstraints gbc_lblInterpreter = new GridBagConstraints();
		gbc_lblInterpreter.insets = new Insets(0, 0, 5, 5);
		gbc_lblInterpreter.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblInterpreter.gridx = 0;
		gbc_lblInterpreter.gridy = curGridY;
		getPanel().add(lblInterpreter, gbc_lblInterpreter);

		tf_Interpreter = new JTextField(currentEntity.getInterpreter());
		GridBagConstraints gbc_tf_Interpreter = new GridBagConstraints();
		gbc_tf_Interpreter.gridwidth = 3;
		gbc_tf_Interpreter.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Interpreter.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Interpreter.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Interpreter.gridx = 1;
		gbc_tf_Interpreter.weighty = .2;
		gbc_tf_Interpreter.gridy = curGridY++;
		getPanel().add(tf_Interpreter, gbc_tf_Interpreter);
		
		//Save Button
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
						CDEntryWindow.this.closeWindow();
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

		JLabel lblCopies = new JLabel("Copies");
		GridBagConstraints gbc_lblCopies = new GridBagConstraints();
		gbc_lblCopies.insets = new Insets(0, 0, 5, 5);
		gbc_lblCopies.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblCopies.gridx = 0;
		gbc_lblCopies.gridy = curGridY;
		getPanel().add(lblCopies, gbc_lblCopies);

		li_Copys = new JList<Copy>(new Vector<Copy>(copyService.getAllByMedium(currentEntity)));
		GridBagConstraints gbc_li_Copies = new GridBagConstraints();
		gbc_li_Copies.gridwidth = 3;
		gbc_li_Copies.insets = new Insets(0, 0, 5, 5);
		gbc_li_Copies.fill = GridBagConstraints.BOTH;
		gbc_li_Copies.gridx = 1;
		gbc_li_Copies.weighty = .5;
		gbc_li_Copies.gridy = curGridY;
		getPanel().add(li_Copys, gbc_li_Copies);
		
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
				addCopy();
			}
		});
		
				
		btn = new JButton("Edit");
		gbc_btn.gridx = 2;
		btn.setEnabled(!currentEntity.isNew());
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Object selected = CDEntryWindow.this.li_Copys
						.getSelectedValue();
				if (selected == null) {
					Util.showNothingSelected();
				} else {
					// @TODO: trigger an action
					editCopy();
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
		return "Edit CD Window";
	}

	private boolean saveAction() throws ParseException {
		// Read values from different fields
		String name = tf_Name.getText().isEmpty() ? null : tf_Name.getText();
		int ASIN = tf_ASIN.getText().isEmpty() ? 0 : Integer.parseInt(tf_ASIN.getText());
		String interpreter = tf_Interpreter.getText().isEmpty() ? null : tf_Interpreter.getText();

		// validation
		try {
			service.validateCD(name, ASIN, interpreter);
		} catch (ValidationException e) {
			Util.showUserMessage(
					"Validation error for " + e.getField(),
					"Validation error for " + e.getField() + ": "
							+ e.getMessage());
			return false;
		}

		// persist
		currentEntity = service.saveCD(currentEntity.getOid(), name, ASIN, interpreter);

		// update user listing in UserListWindow
		((CDListWindow) getParent()).initializeCDListing();

		return true;
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editCopy() {
		Copy copy = li_Copys.getSelectedValue();
		if (copy != null)
			new CopyEntryWindow(this, copy).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a loan.", "No Loan Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addCopy() {
		Copy copy= new Copy();
		copy.setMedium(currentEntity);
		new CopyEntryWindow(this, copy).open();
	}
	public void initializeCopyListing() {
		Vector<Copy> copys = new Vector<Copy>(copyService.getAllByMedium(currentEntity));
		li_Copys.setListData(copys);
	}
}
