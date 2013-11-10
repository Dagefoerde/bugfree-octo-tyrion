package de.wwu.pi.mdsd05.library.ref.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.text.ParsePosition;
import java.util.Date;
import java.util.Vector;

import javax.swing.ComboBoxModel;
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
import de.wwu.pi.mdsd05.library.ref.data.Loan;
import de.wwu.pi.mdsd05.library.ref.data.User;
import de.wwu.pi.mdsd05.library.ref.logic.CopyService;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;
import de.wwu.pi.mdsd05.library.ref.logic.LoanService;
import de.wwu.pi.mdsd05.library.ref.logic.UserService;

public class LoanEntryWindow extends AbstractWindow {

	private JButton btnSave;
	private int curGridY = 0;
	private Loan currentEntity;
	private JList<Object> li_Loans;
	private LoanService service;
	private CopyService copyService;
	private UserService userService;
	private JTextField tf_ReturnDate;
	private JTextField tf_IssueDate;
	private JComboBox<User> cb_User;
	private JComboBox<Copy> cb_Copy;

	public LoanEntryWindow(AbstractWindow parent, Loan currentEntity) {
		super(parent);
		this.currentEntity = currentEntity;
		service = ServiceInitializer.getProvider().getLoanService();
		userService = ServiceInitializer.getProvider().getUserService();
		copyService = ServiceInitializer.getProvider().getCopyService();
	}

	@Override
	protected void createContents() {
		Container panel = getPanel();

		GridBagLayout gbl = new GridBagLayout();
		gbl.columnWeights = new double[] { .1, .25, .25, .25, Double.MIN_VALUE };
		panel.setLayout(gbl);

		// set new Line
		curGridY++;

		JLabel lblName = new JLabel("Issue date*");
		GridBagConstraints gbc_lblName = new GridBagConstraints();
		gbc_lblName.insets = new Insets(0, 0, 5, 5);
		gbc_lblName.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblName.gridx = 0;
		gbc_lblName.gridy = curGridY;
		getPanel().add(lblName, gbc_lblName);
		

		
		tf_IssueDate = new JTextField(Util.DATE_TIME_FORMATTER.format(currentEntity.getIssueDate()));
		GridBagConstraints gbc_tf_IssueDate = new GridBagConstraints();
		gbc_tf_IssueDate.gridwidth = 3;
		gbc_tf_IssueDate.insets = new Insets(0, 0, 5, 5);
		gbc_tf_IssueDate.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_IssueDate.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_IssueDate.gridx = 1;
		gbc_tf_IssueDate.weighty = .2;
		gbc_tf_IssueDate.gridy = curGridY++;
		getPanel().add(tf_IssueDate, gbc_tf_IssueDate);

		JLabel lblAddress = new JLabel("Return date");
		GridBagConstraints gbc_lblAddress = new GridBagConstraints();
		gbc_lblAddress.insets = new Insets(0, 0, 5, 5);
		gbc_lblAddress.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblAddress.gridx = 0;
		gbc_lblAddress.gridy = curGridY;
		getPanel().add(lblAddress, gbc_lblAddress);

		tf_ReturnDate = new JTextField(Util.DATE_TIME_FORMATTER.format(currentEntity.getReturnDate()));
		GridBagConstraints gbc_tf_ReturnDate = new GridBagConstraints();
		gbc_tf_ReturnDate.gridwidth = 3;
		gbc_tf_ReturnDate.insets = new Insets(0, 0, 5, 5);
		gbc_tf_ReturnDate.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_ReturnDate.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_ReturnDate.gridx = 1;
		gbc_tf_ReturnDate.weighty = .2;
		gbc_tf_ReturnDate.gridy = curGridY++;
		getPanel().add(tf_ReturnDate, gbc_tf_ReturnDate);

		JLabel lblUser = new JLabel("User");
		GridBagConstraints gbc_lblUser = new GridBagConstraints();
		gbc_lblUser.insets = new Insets(0, 0, 5, 5);
		gbc_lblUser.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblUser.gridx = 0;
		gbc_lblUser.gridy = curGridY;
		getPanel().add(lblUser, gbc_lblUser);

		cb_User = new JComboBox<User>(new Vector<User>( userService.getAll() ));
		
		GridBagConstraints gbc_tf_User = new GridBagConstraints();
		gbc_tf_User.gridwidth = 3;
		gbc_tf_User.insets = new Insets(0, 0, 5, 5);
		gbc_tf_User.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_User.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_User.gridx = 1;
		gbc_tf_User.weighty = .2;
		gbc_tf_User.gridy = curGridY++;
		getPanel().add(cb_User, gbc_tf_User);

		JLabel lblCopy = new JLabel("Copy");
		GridBagConstraints gbc_lblCopy = new GridBagConstraints();
		gbc_lblCopy.insets = new Insets(0, 0, 5, 5);
		gbc_lblCopy.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblCopy.gridx = 0;
		gbc_lblCopy.gridy = curGridY;
		getPanel().add(lblCopy, gbc_lblCopy);

		cb_Copy = new JComboBox<Copy>(new Vector<Copy>( copyService.getAll() ));
		
		GridBagConstraints gbc_tf_Copy= new GridBagConstraints();
		gbc_tf_Copy.gridwidth = 3;
		gbc_tf_Copy.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Copy.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Copy.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Copy.gridx = 1;
		gbc_tf_Copy.weighty = .2;
		gbc_tf_Copy.gridy = curGridY++;
		getPanel().add(cb_Copy, gbc_tf_Copy);

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
						LoanEntryWindow.this.closeWindow();
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
		return "Edit Loan Window";
	}

	private boolean saveAction() throws ParseException {
		// Read values from different fields
		String strIssueDate = tf_IssueDate.getText().isEmpty() ? null : tf_IssueDate.getText();
		String strReturnDate = tf_ReturnDate.getText().isEmpty() ? null : tf_ReturnDate
				.getText();
		Copy copy = (Copy)cb_Copy.getSelectedItem();
		User user = (User)cb_User.getSelectedItem();

		
		Date issueDate = Util.DATE_TIME_FORMATTER.parse(strIssueDate, new ParsePosition(0));
		Date returnDate = Util.DATE_TIME_FORMATTER.parse(strReturnDate, new ParsePosition(0));
		
		// validation
		try {
			service.validateLoan(copy, user, issueDate);
		} catch (ValidationException e) {
			Util.showUserMessage(
					"Validation error for " + e.getField(),
					"Validation error for " + e.getField() + ": "
							+ e.getMessage());
			return false;
		}

		// persist
		currentEntity = service.saveLoan(currentEntity.getOid(), copy, user, issueDate, returnDate);

		// update user listing in UserListWindow
		((LoanListWindow) getParent()).initializeLoanListing();

		return true;
	}
}
