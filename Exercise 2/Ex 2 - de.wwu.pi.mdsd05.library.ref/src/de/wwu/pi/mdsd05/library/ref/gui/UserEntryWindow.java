package de.wwu.pi.mdsd05.library.ref.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.util.LinkedList;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.JTextField;

import de.wwu.pi.mdsd05.framework.gui.AbstractWindow;
import de.wwu.pi.mdsd05.framework.gui.Util;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Loan;
import de.wwu.pi.mdsd05.library.ref.data.User;
import de.wwu.pi.mdsd05.library.ref.logic.LoanService;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;
import de.wwu.pi.mdsd05.library.ref.logic.UserService;

public class UserEntryWindow extends AbstractWindow implements ILoanListContainingWindow{

	private JButton btnSave;
	private int curGridY = 0;
	private User currentEntity;
	private JList<Loan> li_Loans;
	private UserService service;
	private LoanService loanService;
	private JTextField tf_Address;
	private JTextField tf_Name;

	public UserEntryWindow(AbstractWindow parent, User currentEntity) {
		super(parent);
		this.currentEntity = currentEntity;
		service = ServiceInitializer.getProvider().getUserService();
		loanService=ServiceInitializer.getProvider().getLoanService();
	}

	@Override
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

		JLabel lblAddress = new JLabel("Address*");
		GridBagConstraints gbc_lblAddress = new GridBagConstraints();
		gbc_lblAddress.insets = new Insets(0, 0, 5, 5);
		gbc_lblAddress.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblAddress.gridx = 0;
		gbc_lblAddress.gridy = curGridY;
		getPanel().add(lblAddress, gbc_lblAddress);

		tf_Address = new JTextField(currentEntity.getAddress());
		GridBagConstraints gbc_tf_Address = new GridBagConstraints();
		gbc_tf_Address.gridwidth = 3;
		gbc_tf_Address.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Address.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Address.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Address.gridx = 1;
		gbc_tf_Address.weighty = .2;
		gbc_tf_Address.gridy = curGridY++;
		getPanel().add(tf_Address, gbc_tf_Address);

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
						UserEntryWindow.this.closeWindow();
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

		JLabel lblLoans = new JLabel("Loans");
		GridBagConstraints gbc_lblLoans = new GridBagConstraints();
		gbc_lblLoans.insets = new Insets(0, 0, 5, 5);
		gbc_lblLoans.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblLoans.gridx = 0;
		gbc_lblLoans.gridy = curGridY;
		getPanel().add(lblLoans, gbc_lblLoans);

		li_Loans = new JList<Loan>(new Vector<Loan>(loanService.getAllByUser(currentEntity)));
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
				addLoan();
			}
		});

		btn = new JButton("Edit");
		gbc_btn.gridx = 2;
		btn.setEnabled(!currentEntity.isNew());
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Object selected = UserEntryWindow.this.li_Loans
						.getSelectedValue();
				if (selected == null) {
					Util.showNothingSelected();
				} else {
					editLoan();
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
		return "Edit User Window";
	}

	private boolean saveAction() throws ParseException {
		// Read values from different fields
		String name = tf_Name.getText().isEmpty() ? null : tf_Name.getText();
		String address = tf_Address.getText().isEmpty() ? null : tf_Address
				.getText();

		// validation
		try {
			service.validateUser(name, address);
		} catch (ValidationException e) {
			Util.showUserMessage(
					"Validation error for " + e.getField(),
					"Validation error for " + e.getField() + ": "
							+ e.getMessage());
			return false;
		}

		// persist
		currentEntity = service.saveUser(currentEntity.getOid(), name, address);

		// update user listing in UserListWindow
		((UserListWindow) getParent()).initializeUserListing();

		return true;
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editLoan() {
		Loan loan = li_Loans.getSelectedValue();
		if (loan != null)
			new LoanEntryWindow(this, loan).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a loan.", "No Loan Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addLoan() {
		Loan loan= new Loan();
		loan.setUser(currentEntity);
		new LoanEntryWindow(this, loan).open();
	}
	public void initializeLoanListing() {
		Vector<Loan> loans = new Vector<Loan>(loanService.getAllByUser(currentEntity));
		li_Loans.setListData(loans);
	}
}
