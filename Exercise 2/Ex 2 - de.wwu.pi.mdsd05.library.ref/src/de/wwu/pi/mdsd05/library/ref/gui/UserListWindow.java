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
import de.wwu.pi.mdsd05.library.ref.data.User;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;

public class UserListWindow extends AbstractWindow {

	JList<User> jl_users;
	JButton btnEditUser;
	
	public UserListWindow(StartWindowClass parent) {
		super(parent);
	}
	
	@Override
	public String getTitle() {
		return "List Users";
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

		jl_users = new JList<User>();
		GridBagConstraints gbc_userList = new GridBagConstraints();
		gbc_userList.insets = new Insets(5, 5, 5, 5);
		gbc_userList.gridwidth = 0;
		gbc_userList.fill = GridBagConstraints.BOTH;
		gbc_userList.gridx = 0;
		gbc_userList.gridy = 0;
		panel.add(jl_users, gbc_userList);

		JButton btnAddUser = new JButton("Add");
		btnAddUser.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				addUser();
			}
		});
		GridBagConstraints gbc_btnAddUser = new GridBagConstraints();
		gbc_btnAddUser.insets = new Insets(0, 0, 5, 5);
		gbc_btnAddUser.gridx = 2;
		gbc_btnAddUser.gridy = 2;
		panel.add(btnAddUser, gbc_btnAddUser);

		btnEditUser = new JButton("Edit");
		btnEditUser.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				editUser();
			}
		});
		GridBagConstraints gbc_btnEditUser = new GridBagConstraints();
		gbc_btnEditUser.insets = new Insets(0, 0, 5, 5);
		gbc_btnEditUser.gridx = 3;
		gbc_btnEditUser.gridy = 2;
		panel.add(btnEditUser, gbc_btnEditUser);

		JButton btnRemoveUser = new JButton("Remove");
		btnRemoveUser.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				removeUser();
			}
		});
		btnRemoveUser.setEnabled(false);
		GridBagConstraints gbc_btnRemoveUser = new GridBagConstraints();
		gbc_btnRemoveUser.insets = new Insets(0, 0, 5, 5);
		gbc_btnRemoveUser.gridx = 4;
		gbc_btnRemoveUser.gridy = 2;
		panel.add(btnRemoveUser, gbc_btnRemoveUser);

		initializeUserListing();
	}

	public void initializeUserListing() {
		Vector<User> users = new Vector<User>(ServiceInitializer.getProvider().getUserService().getAll());
		jl_users.setListData(users);
		
		if (users.isEmpty())
			btnEditUser.setEnabled(false);
		else
			btnEditUser.setEnabled(true);
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editUser() {
		User user = jl_users.getSelectedValue();
		if (user != null)
			new UserEntryWindow(this, user).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a user.", "No User Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addUser() {
		new UserEntryWindow(this, new User()).open();
	}

	public void removeUser() {
		// XXX Not implemented in current version
	}

}