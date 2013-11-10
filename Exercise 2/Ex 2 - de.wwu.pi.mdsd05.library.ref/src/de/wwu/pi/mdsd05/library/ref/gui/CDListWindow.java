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
import de.wwu.pi.mdsd05.library.ref.data.CD;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;

public class CDListWindow extends AbstractWindow {


	JList<CD> jl_cds;
	JButton btnEditCD;
	
	public CDListWindow(StartWindowClass parent) {
		super(parent);
	}
	
	@Override
	public String getTitle() {
		return "List CDs";
	}

	/**
	 * Initialize the contents of cd list window.
	 */
	@Override
	protected void createContents() {
		Container panel = getPanel();
		// frame.getContentPane().add(panel, BorderLayout.NORTH);
		GridBagLayout gbl_panel = new GridBagLayout();
		gbl_panel.columnWeights = new double[] { 1.0, 0.0, Double.MIN_VALUE };
		gbl_panel.rowWeights = new double[] { 1.0, 0.0, 0.0 };
		panel.setLayout(gbl_panel);

		jl_cds = new JList<CD>();
		GridBagConstraints gbc_CDList = new GridBagConstraints();
		gbc_CDList.insets = new Insets(5, 5, 5, 5);
		gbc_CDList.gridwidth = 0;
		gbc_CDList.fill = GridBagConstraints.BOTH;
		gbc_CDList.gridx = 0;
		gbc_CDList.gridy = 0;
		panel.add(jl_cds, gbc_CDList);

		JButton btnAddCD = new JButton("Add");
		btnAddCD.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				addCD();
			}
		});
		GridBagConstraints gbc_btnAddCD = new GridBagConstraints();
		gbc_btnAddCD.insets = new Insets(0, 0, 5, 5);
		gbc_btnAddCD.gridx = 2;
		gbc_btnAddCD.gridy = 2;
		panel.add(btnAddCD, gbc_btnAddCD);

		btnEditCD = new JButton("Edit");
		btnEditCD.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				editCD();
			}
		});
		GridBagConstraints gbc_btnEditCD = new GridBagConstraints();
		gbc_btnEditCD.insets = new Insets(0, 0, 5, 5);
		gbc_btnEditCD.gridx = 3;
		gbc_btnEditCD.gridy = 2;
		panel.add(btnEditCD, gbc_btnEditCD);

		JButton btnRemoveCD = new JButton("Remove");
		btnRemoveCD.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				removeCD();
			}
		});
		btnRemoveCD.setEnabled(false);
		GridBagConstraints gbc_btnRemoveCD = new GridBagConstraints();
		gbc_btnRemoveCD.insets = new Insets(0, 0, 5, 5);
		gbc_btnRemoveCD.gridx = 4;
		gbc_btnRemoveCD.gridy = 2;
		panel.add(btnRemoveCD, gbc_btnRemoveCD);

		initializeCDListing();
	}

	public void initializeCDListing() {
		Vector<CD> cds = new Vector<CD>(ServiceInitializer.getProvider().getCDService().getAll());
		jl_cds.setListData(cds);
		
		if (cds.isEmpty())
			btnEditCD.setEnabled(false);
		else
			btnEditCD.setEnabled(true);
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editCD() {
		CD cd = jl_cds.getSelectedValue();
		if (cd != null)
			new CDEntryWindow(this, cd).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a CD.", "No CD Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addCD() {
		new CDEntryWindow(this, new CD()).open();
	}

	public void removeCD() {
		// XXX Not implemented in current version
	}
	
	
	
	
	
}
