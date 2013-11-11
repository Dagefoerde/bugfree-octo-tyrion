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
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;

public class CopyListWindow extends AbstractWindow implements ICopyListContainingWindow{

	JList<Copy> jl_copys;
	JButton btnEditCopy;
	
	public CopyListWindow(StartWindowClass parent) {
		super(parent);
	}
	
	@Override
	public String getTitle() {
		return "List Copys";
	}

	/**
	 * Initialize the contents of copy list window.
	 */
	@Override
	protected void createContents() {
		Container panel = getPanel();
		// frame.getContentPane().add(panel, BorderLayout.NORTH);
		GridBagLayout gbl_panel = new GridBagLayout();
		gbl_panel.columnWeights = new double[] { 1.0, 0.0, Double.MIN_VALUE };
		gbl_panel.rowWeights = new double[] { 1.0, 0.0, 0.0 };
		panel.setLayout(gbl_panel);

		jl_copys = new JList<Copy>();
		GridBagConstraints gbc_copyList = new GridBagConstraints();
		gbc_copyList.insets = new Insets(5, 5, 5, 5);
		gbc_copyList.gridwidth = 0;
		gbc_copyList.fill = GridBagConstraints.BOTH;
		gbc_copyList.gridx = 0;
		gbc_copyList.gridy = 0;
		panel.add(jl_copys, gbc_copyList);

		JButton btnAddCopy = new JButton("Add");
		btnAddCopy.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				addCopy();
			}
		});
		GridBagConstraints gbc_btnAddCopy = new GridBagConstraints();
		gbc_btnAddCopy.insets = new Insets(0, 0, 5, 5);
		gbc_btnAddCopy.gridx = 2;
		gbc_btnAddCopy.gridy = 2;
		panel.add(btnAddCopy, gbc_btnAddCopy);

		btnEditCopy = new JButton("Edit");
		btnEditCopy.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				editCopy();
			}
		});
		GridBagConstraints gbc_btnEditCopy = new GridBagConstraints();
		gbc_btnEditCopy.insets = new Insets(0, 0, 5, 5);
		gbc_btnEditCopy.gridx = 3;
		gbc_btnEditCopy.gridy = 2;
		panel.add(btnEditCopy, gbc_btnEditCopy);

		JButton btnRemoveCopy = new JButton("Remove");
		btnRemoveCopy.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				removeCopy();
			}
		});
		btnRemoveCopy.setEnabled(false);
		GridBagConstraints gbc_btnRemoveCopy = new GridBagConstraints();
		gbc_btnRemoveCopy.insets = new Insets(0, 0, 5, 5);
		gbc_btnRemoveCopy.gridx = 4;
		gbc_btnRemoveCopy.gridy = 2;
		panel.add(btnRemoveCopy, gbc_btnRemoveCopy);

		initializeCopyListing();
	}

	public void initializeCopyListing() {
		Vector<Copy> copys = new Vector<Copy>(ServiceInitializer.getProvider().getCopyService().getAll());
		jl_copys.setListData(copys);
		
		if (copys.isEmpty())
			btnEditCopy.setEnabled(false);
		else
			btnEditCopy.setEnabled(true);
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editCopy() {
		Copy copy = jl_copys.getSelectedValue();
		if (copy != null)
			new CopyEntryWindow(this, copy).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a copy.", "No Copy Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addCopy() {
		new CopyEntryWindow(this, new Copy()).open();
	}

	public void removeCopy() {
		// XXX Not implemented in current version
	}

}