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
import de.wwu.pi.mdsd05.library.ref.data.Book;
import de.wwu.pi.mdsd05.library.ref.logic.ServiceInitializer;

public class BookListWindow extends AbstractWindow {

	JList<Book> jl_books;
	JButton btnEditBook;
	
	public BookListWindow(StartWindowClass parent) {
		super(parent);
	}
	
	@Override
	public String getTitle() {
		return "List Books";
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

		jl_books = new JList<Book>();
		GridBagConstraints gbc_bookList = new GridBagConstraints();
		gbc_bookList.insets = new Insets(5, 5, 5, 5);
		gbc_bookList.gridwidth = 0;
		gbc_bookList.fill = GridBagConstraints.BOTH;
		gbc_bookList.gridx = 0;
		gbc_bookList.gridy = 0;
		panel.add(jl_books, gbc_bookList);

		JButton btnAddBook = new JButton("Add");
		btnAddBook.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				addBook();
			}
		});
		GridBagConstraints gbc_btnAddBook = new GridBagConstraints();
		gbc_btnAddBook.insets = new Insets(0, 0, 5, 5);
		gbc_btnAddBook.gridx = 2;
		gbc_btnAddBook.gridy = 2;
		panel.add(btnAddBook, gbc_btnAddBook);

		btnEditBook = new JButton("Edit");
		btnEditBook.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				editBook();
			}
		});
		GridBagConstraints gbc_btnEditBook = new GridBagConstraints();
		gbc_btnEditBook.insets = new Insets(0, 0, 5, 5);
		gbc_btnEditBook.gridx = 3;
		gbc_btnEditBook.gridy = 2;
		panel.add(btnEditBook, gbc_btnEditBook);

		JButton btnRemoveBook = new JButton("Remove");
		btnRemoveBook.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				removeBook();
			}
		});
		btnRemoveBook.setEnabled(false);
		GridBagConstraints gbc_btnRemoveBook = new GridBagConstraints();
		gbc_btnRemoveBook.insets = new Insets(0, 0, 5, 5);
		gbc_btnRemoveBook.gridx = 4;
		gbc_btnRemoveBook.gridy = 2;
		panel.add(btnRemoveBook, gbc_btnRemoveBook);

		initializeBookListing();
	}

	public void initializeBookListing() {
		Vector<Book> books = new Vector<Book>(ServiceInitializer.getProvider().getBookService().getAll());
		jl_books.setListData(books);
		
		if (books.isEmpty())
			btnEditBook.setEnabled(false);
		else
			btnEditBook.setEnabled(true);
	}
	/**
	 * Method triggered when user clicks edit
	 */
	public void editBook() {
		Book book = jl_books.getSelectedValue();
		if (book != null)
			new BookEntryWindow(this, book).open();
		else
			JOptionPane.showMessageDialog(null, "Please select a book.", "No book Selected", JOptionPane.ERROR_MESSAGE);
	}

	/**
	 * Method triggered when user clicks add
	 */
	public void addBook() {
		new BookEntryWindow(this, new Book()).open();
	}

	public void removeBook() {
		// XXX Not implemented in current version
	}

}