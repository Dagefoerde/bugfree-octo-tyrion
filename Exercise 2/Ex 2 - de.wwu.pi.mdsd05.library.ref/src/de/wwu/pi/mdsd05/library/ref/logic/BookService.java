
package de.wwu.pi.mdsd05.library.ref.logic;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Book;

public class BookService extends AbstractServiceProvider<Book> {

	//Constructor
	protected BookService() {
		super();
	}

	public boolean validateBook(String name, int ISBN, String author) throws ValidationException {
		if(name == null)
			throw new ValidationException("Name", "cannot be empty");
		if(ISBN == 0)
			throw new ValidationException("ISBN", "cannot be empty");
		if(author == null)
			throw new ValidationException("Author", "cannot be empty");
		return true;
	}
	
	public Book saveBook(int id, String name, int ISBN, String author) {
	Book elem = getByOId(id);
	if(elem == null)
		elem = new Book();
	elem.setName(name);
	elem.setISBN(ISBN);
	elem.setAuthor(author);
	persist(elem);
	return elem;
	}
	
}

