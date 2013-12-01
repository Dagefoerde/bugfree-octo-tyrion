package de.wwu.pi.mdsd05.library.ref.logic;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;

public class ServiceInitializer implements Serializable {
	private static final long serialVersionUID = 4087901003693858998L;

	private static String filename = "MDSD-DataProv.dat";
	
	private static ServiceInitializer provider;
	
	public static ServiceInitializer getProvider() {
		if(provider == null && !deserialize())
			provider = new ServiceInitializer();
		if(provider == null) provider = new ServiceInitializer();
		return provider;
	}
	
	private UserService userService;
	
	private LoanService loanService;
	
	private MediumService mediumService;
	
	private BookService bookService;

	private CDService cdService;
	
	private CopyService copyService;

	private ServiceInitializer() {
		super();
		userService = new UserService();
		loanService = new LoanService();
		mediumService = new MediumService();
		bookService = new BookService();
		cdService = new CDService();
		copyService = new CopyService();
	}
	
	public UserService getUserService() {
		if(userService == null)
			userService = new UserService();
		return userService;
	}
	
	public LoanService getLoanService() {
		if(loanService == null)
			loanService = new LoanService();
		return loanService;
	}
	
	public MediumService getMediumService() {
		if(mediumService == null)
			mediumService = new MediumService();
		return mediumService;
	}
	
	public BookService getBookService() {
		if(bookService == null)
			bookService = new BookService();
		return bookService;
	}
	
	public CDService getCDService() {
		if(cdService == null)
			cdService = new CDService();
		return cdService;
	}
	
	public CopyService getCopyService() {
		if(copyService == null)
			copyService = new CopyService();
		return copyService;
	}

	
	
	private static boolean deserialize() {
		try {
			System.out.println("Trying to read following file:" + new File(filename).getAbsolutePath());
			ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename));
			provider = (ServiceInitializer) ois.readObject();
			AbstractServiceProvider.deserialize(ois.readInt());
			ois.close();
			System.out.println("Deserialization completed");
			return true;
		} catch (Exception e) {
			System.out.println("Deserialization failed: " + e.getMessage());
			provider = new ServiceInitializer();
			return false;
		}
	}

	public static void serialize() {
		try {
			ObjectOutputStream oos = new ObjectOutputStream( new FileOutputStream(filename));
			oos.writeObject(provider);
			oos.writeInt(AbstractServiceProvider.serialize());
			oos.close();
			System.out.println("Serialization completed");
		} catch (Exception e) {
			System.out.println("Serialization failed: " + e.getMessage());
		}
	}
}
