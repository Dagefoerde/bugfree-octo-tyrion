package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Book;
import de.wwu.pi.mdsd05.library.ref.data.CD;
import de.wwu.pi.mdsd05.library.ref.data.Medium;

public class MediumService extends AbstractServiceProvider<Medium> {
	

	CDService cdService;
	BookService bookService;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7564384820420239045L;

	//Constructor
	protected MediumService() {
		super();
	}

	public boolean validateMedium(String name) throws ValidationException {
		if(name == null)
			throw new ValidationException("name", "cannot be empty");
		return true;
	}
	
	public Collection<Medium> getAll() {
		if (cdService == null) cdService = ServiceInitializer.getProvider().getCDService();
		if (bookService == null) bookService = ServiceInitializer.getProvider().getBookService();;
		
		Collection<CD> cds = cdService.getAll();
		Collection<Book> books = bookService.getAll();
		
		ArrayList<Medium> mediums = new ArrayList<Medium>(cds.size() + books.size());
		mediums.addAll(cds);
		mediums.addAll(books);
		
		return mediums;
	}
	
	

	
	
}
