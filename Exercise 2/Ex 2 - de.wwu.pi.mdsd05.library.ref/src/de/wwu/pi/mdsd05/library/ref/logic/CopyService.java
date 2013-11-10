package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.Date;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Loan;

public class CopyService extends AbstractServiceProvider<Loan> {
	
	//Constructor
	protected CopyService() {
		super();
	}

	public boolean validateCopy(Integer inventoryNumber, Medium medium) throws ValidationException {
		if(inventoryNumber == null)
			throw new ValidationException("inventoryNumber", "cannot be empty");
		if(medium == null)
			throw new ValidationException("medium", "cannot be empty");
		;
		return true;
	}
	
	public Copy saveUser(Integer inventoryNumber, Medium medium,) {
	Copy elem = getByOId(id);
	if(elem == null)
		elem = new Loan();
	elem.setMedium(medium);
	elem.setUser(user);
	elem.setInventoryNumber(inventoryNumber);
	
	persist(elem);
	return elem;
	}
	
}
