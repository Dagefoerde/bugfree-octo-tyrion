package de.wwu.pi.mdsd05.library.ref.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JList;
import javax.swing.JOptionPane;

import de.wwu.pi.mdsd05.framework.gui.AbstractWindow;
import de.wwu.pi.mdsd05.library.ref.data.Loan;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;

public class LoanListWindow extends AbstractWindow {

	JList<Loan> jl_loans;
	JButton btnEditLoan;
	
	public LoanListWindow(StartWindowClass parent) {
		super(parent);
	}
	
	@Override
	public String getTitle() {
		return "List Loans";
	}

	/**
	 * Initialize the contents of user list window.
	 */
	@Override
	protected void createContents() {
		Container panel = getPanel();
		// frame.getContentPane().add(panel, BorderLayout.NORTH);
		GridBagLayout gbl_panel = new GridBagLayout();
		gbl_panel.columnWeights = new double[] { 1.0, 0.0, Double.MIN_VALUE };
		gbl_panel.rowWeights = new double[] { 1.0, 0.0, 0.0 };
		panel.setLayout(gbl_panel);

		jl_loans = new JList<Loan>();
		GridBagConstraints gbc_loanList = new GridBagConstraints();
		gbc_loanList.insets = new Insets(5, 5, 5, 5);
		gbc_loanList.gridwidth = 0;
		gbc_loanList.fill = GridBagConstraints.BOTH;
		gbc_loanList.gridx = 0;
		gbc_loanList.gridy = 0;
		panel.add(jl_loans, gbc_loanList);

		JButton btnAddLoan = new JButton("Add");
		btnAddLoan.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				addLoan();
			}
		});
		GridBagConstraints gbc_btnAddLoan = new GridBagConstraints();
		gbc_btnAddLoan.insets = new Insets(0, 0, 5, 5);
		gbc_btnAddLoan.gridx = 2;
		gbc_btnAddLoan.gridy = 2;
		panel.add(btnAddLoan, gbc_btnAddLoan);

		btnEditLoan = new JButton("Edit");
		btnEditLoan.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				editLoan();
			}
		});
		GridBagConstraints gbc_btnEditLoan = new GridBagConstraints();
		gbc_btnEditLoan.insets = new Insets(0, 0, 5, 5);
		gbc_btnEditLoan.gridx = 3;
		gbc_btnEditLoan.gridy = 2;
		panel.add(btnEditLoan, gbc_btnEditLoan);

		JButton btnRemoveLoan = new JButton("Remove");
		btnRemoveLoan.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				removeLoan();
			}
		});
		btnRemoveLoan.setEnabled(false);
		GridBagConstraints gbc_btnRemoveLoan = new GridBagConstraints();
		gbc_btnRemoveLoan.insets = new Insets(0, 0, 5, 5);
		gbc_btnRemoveLoan.gridx = 4;
		gbc_btnRemoveLoan.gridy = 2;
		panel.add(btnRemoveLoan, gbc_btnRemoveLoan);

		initializeLoanListing();
	}

	public void initializeLoanListing() {
		Vector<Loan> loans = new Vector<Loan>(ServiceInitializer.getProvider().getLoanService().getAll());
		jl_loans.setListData(loans);
		
		if (loans.isEmpty())
			btnEditLoan.setEnabled(false);
		else
			btnEditLoan.setEnabled(true);
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editLoan() {
		Loan loan = jl_loans.getSelectedValue();
		if (loan != null)
			new LoanEntryWindow(this, loan).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a loan.", "No Loan Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addLoan() {
		new LoanEntryWindow(this, new Loan()).open();
	}

	public void removeLoan() {
		// XXX Not implemented in current version
	}

}