package de.wwu.pi.mdsd.framework.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;

import de.wwu.pi.mdsd.framework.data.AbstractDataClass;

public abstract class AbstractListWindow<E extends AbstractDataClass> extends
		AbstractWindow {

	public AbstractListWindow(AbstractWindow parent,int width,int height) {
		super(parent,width,height);
	}

	JList<E> jList;
	JButton btnEdit;

	/**
	 * Initialize the contents of the frame.
	 * @wbp.parser.entryPoint
	 */
	@Override
	protected void createContents() {
		Container panel = getPanel();
		// frame.getContentPane().add(panel, BorderLayout.NORTH);
		GridBagLayout gbl_panel = new GridBagLayout();
		gbl_panel.columnWeights = new double[] { 1.0, 0.0, Double.MIN_VALUE };
		gbl_panel.rowWeights = new double[] { 1.0, 0.0, 0.0 };
		panel.setLayout(gbl_panel);

		jList = new JList<E>();
		GridBagConstraints gbc_list = new GridBagConstraints();
		gbc_list.insets = new Insets(5, 5, 5, 5);
		gbc_list.gridwidth = 0;
		gbc_list.fill = GridBagConstraints.BOTH;
		gbc_list.gridx = 0;
		gbc_list.gridy = 0;
		panel.add(jList, gbc_list);
		
		JButton btnAdd = new JButton("Add");
		btnAdd.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				add();
			}
		});
		GridBagConstraints gbc_btnAdd = new GridBagConstraints();
		gbc_btnAdd.insets = new Insets(0, 0, 5, 5);
		gbc_btnAdd.gridx = 2;
		gbc_btnAdd.gridy = 2;
		panel.add(btnAdd, gbc_btnAdd);

		btnEdit = new JButton("Edit");
		btnEdit.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				edit();
			}
		});
		GridBagConstraints gbc_btnEdit = new GridBagConstraints();
		gbc_btnEdit.insets = new Insets(0, 0, 5, 5);
		gbc_btnEdit.gridx = 3;
		gbc_btnEdit.gridy = 2;
		panel.add(btnEdit, gbc_btnEdit);
		
		JButton btnRemove = new JButton("Remove");
		btnRemove.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				remove();
			}
		});
		btnRemove.setEnabled(false);
		GridBagConstraints gbc_btnRemove = new GridBagConstraints();
		gbc_btnRemove.insets = new Insets(0, 0, 5, 5);
		gbc_btnRemove.gridx = 4;
		gbc_btnRemove.gridy = 2;
		panel.add(btnRemove, gbc_btnRemove);
		
		initializeList();
	}

	public void edit() {
		E selected = jList.getSelectedValue();
		if(selected != null)
			showEntryWindow(selected);
		else
			JOptionPane.showMessageDialog(null,
				    "Please select an element.",
				    "No Element Selected",
				    JOptionPane.ERROR_MESSAGE);
	}

	public void add() {
		showEntryWindow(null);
	}

	public void remove() {
		// Not implemented in current version
	}
	
	public abstract void showEntryWindow(E entity);
	public abstract Vector<E> getElements();

	public String getTitle() {
		if (getElements().size()>0)
			return "List " + getElements().firstElement().getClass().getSimpleName() + " Objects";
		else
			return "List View";
	}
	
	public void initializeList() {
		jList.setListData(getElements());
		if(getElements().isEmpty())
			btnEdit.setEnabled(false);
		else
			btnEdit.setEnabled(true);
	}
}
