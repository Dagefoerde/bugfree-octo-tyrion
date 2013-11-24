package de.wwu.pi.mdsd.umlToApp.gui

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class ListWindowGenerator {
	def generateListWindow(Class clazz) '''
package de.wwu.pi.mdsd.library.ref.gui;

import java.util.Vector;

import de.wwu.pi.mdsd.framework.gui.AbstractListWindow;
import de.wwu.pi.mdsd.framework.gui.AbstractWindow;
import de.wwu.pi.mdsd.library.ref.logic.ServiceInitializer;
import de.wwu.pi.mdsd.library.ref.data.Book;
	
public class BookListWindow extends AbstractListWindow<Book> implements BookListingInterface{

	public BookListWindow(AbstractWindow parent) {
		super(parent);
	}

	@Override
	public void showEntryWindow(Book entity) {
		//If entity is null -> initialize entity as new entity
		//show Entity Edit Window
		if(entity == null)
			entity = new Book();
		new BookEntryWindow(this,entity).open();
	}

	@Override
	public Vector<Book> getElements() {
		return new Vector<Book>(ServiceInitializer.getProvider().getBookService().getAll());
	}
	
	@Override
	public void initializeBookListings() {
		initializeList();
	}

	// @TODO remove; only for testing
	public static void main(String args[]) {
		BookListWindow window = new BookListWindow(null);
		window.open();
	}
}

interface BookListingInterface {
	public void initializeBookListings();
}
	'''
}


	

