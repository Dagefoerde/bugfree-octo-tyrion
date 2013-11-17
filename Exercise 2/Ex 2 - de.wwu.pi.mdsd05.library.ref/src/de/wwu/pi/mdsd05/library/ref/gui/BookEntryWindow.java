package de.wwu.pi.mdsd05.library.ref.gui;

import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.util.Collection;
import java.util.Vector;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.JTextField;

import de.wwu.pi.mdsd05.framework.gui.AbstractWindow;
import de.wwu.pi.mdsd05.framework.gui.Util;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Book;
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.logic.CopyService;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;
import de.wwu.pi.mdsd05.library.ref.logic.BookService;

public class BookEntryWindow extends AbstractWindow implements ICopyListContainingWindow{

	private JButton btnSave;
	private JButton btnCopyEdit;
	private int curGridY = 0;
	private Book currentEntity;
	private JList<Copy> li_Copys;
	private BookService service;
	private CopyService copyService;
	private JTextField tf_ISBN;
	private JTextField tf_Name;
	private JTextField tf_Author;

	public BookEntryWindow(AbstractWindow parent, Book currentEntity) {
		super(parent);
		this.currentEntity = currentEntity;
		service = ServiceInitializer.getProvider().getBookService();
		copyService= ServiceInitializer.getProvider().getCopyService();
	}

	@Override
	protected void createContents() {
		Container panel = getPanel();

		GridBagLayout gbl = new GridBagLayout();
		gbl.columnWeights = new double[] { .1, .25, .25, .25, Double.MIN_VALUE };
		panel.setLayout(gbl);

		// set new Line
		curGridY++;

		//Name
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

		//ISBN
		JLabel lblISBN = new JLabel("ISBN*");
		GridBagConstraints gbc_lblISBN = new GridBagConstraints();
		gbc_lblISBN.insets = new Insets(0, 0, 5, 5);
		gbc_lblISBN.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblISBN.gridx = 0;
		gbc_lblISBN.gridy = curGridY;
		getPanel().add(lblISBN, gbc_lblISBN);

		tf_ISBN = new JTextField(currentEntity.isNew() ? "" : currentEntity.getISBN()+"");
		GridBagConstraints gbc_tf_ISBN = new GridBagConstraints();
		gbc_tf_ISBN.gridwidth = 3;
		gbc_tf_ISBN.insets = new Insets(0, 0, 5, 5);
		gbc_tf_ISBN.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_ISBN.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_ISBN.gridx = 1;
		gbc_tf_ISBN.weighty = .2;
		gbc_tf_ISBN.gridy = curGridY++;
		getPanel().add(tf_ISBN, gbc_tf_ISBN);
		
		//Author
		JLabel lblAuthor = new JLabel("Author*");
		GridBagConstraints gbc_lblAuthor = new GridBagConstraints();
		gbc_lblAuthor.insets = new Insets(0, 0, 5, 5);
		gbc_lblAuthor.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblAuthor.gridx = 0;
		gbc_lblAuthor.gridy = curGridY;
		getPanel().add(lblAuthor, gbc_lblAuthor);

		tf_Author = new JTextField(currentEntity.getAuthor());
		GridBagConstraints gbc_tf_Author = new GridBagConstraints();
		gbc_tf_Author.gridwidth = 3;
		gbc_tf_Author.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Author.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Author.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Author.gridx = 1;
		gbc_tf_Author.weighty = .2;
		gbc_tf_Author.gridy = curGridY++;
		getPanel().add(tf_Author, gbc_tf_Author);

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
						BookEntryWindow.this.closeWindow();
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

		Collection<Copy> allByMedium = copyService.getAllByMedium(currentEntity);
		li_Copys = new JList<Copy>(new Vector<Copy>(allByMedium));
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
				addCopy();			
			}
		});

		btnCopyEdit = new JButton("Edit");
		gbc_btn.gridx = 2;
		btnCopyEdit.setEnabled(!currentEntity.isNew() && !allByMedium.isEmpty());
		getPanel().add(btnCopyEdit, gbc_btn);
		btnCopyEdit.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Object selected = BookEntryWindow.this.li_Copys
						.getSelectedValue();
				if (selected == null) {
					Util.showNothingSelected();
				} else {
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
		return "Edit Book Window";
	}

	private boolean saveAction() throws ParseException {
		// Read values from different fields
		String name = tf_Name.getText().isEmpty() ? null : tf_Name.getText();
		int ISBN = tf_ISBN.getText().isEmpty() ? 0 : Integer.parseInt(tf_ISBN.getText());
		String author = tf_Author.getText().isEmpty() ? null : tf_Author
				.getText();

		// validation
		try {
			service.validateBook(name, ISBN, author);
		} catch (ValidationException e) {
			Util.showUserMessage(
					"Validation error for " + e.getField(),
					"Validation error for " + e.getField() + ": "
							+ e.getMessage());
			return false;
		}

		// persist
		currentEntity = service.saveBook(currentEntity.getOid(), name, ISBN, author);

		// update user listing in UserListWindow
		((BookListWindow) getParent()).initializeBookListing();

		return true;
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editCopy() {
		Copy copy = li_Copys.getSelectedValue();
		// assume copy != null, as editLoan() is called by Edit button, which contains check.
		new CopyEntryWindow(this, copy).open();
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
		Collection<Copy> allByMedium = copyService.getAllByMedium(currentEntity);
		Vector<Copy> copys = new Vector<Copy>(allByMedium);
		li_Copys.setListData(copys);
		btnCopyEdit.setEnabled(!currentEntity.isNew() && !allByMedium.isEmpty());
	}
}
