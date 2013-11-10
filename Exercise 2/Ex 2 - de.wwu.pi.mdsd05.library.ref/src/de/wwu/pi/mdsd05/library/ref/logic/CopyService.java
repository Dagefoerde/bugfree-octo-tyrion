package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.Date;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.data.Medium;

public class CopyService extends AbstractServiceProvider<Copy> {
	
	//Constructor
	protected CopyService() {
		super();
	}

	public boolean validateCopy(int inventoryNumber, Medium medium) throws ValidationException {
		if(inventoryNumber == 0)
			throw new ValidationException("inventoryNumber", "cannot be empty");
		if(medium == null)
			throw new ValidationException("medium", "cannot be empty");
		return true;
	}
	
	public Copy saveCopy(int id, int inventoryNumber, Medium medium) {
	Copy elem = getByOId(id);
	if(elem == null)
		elem = new Copy();
	elem.setMedium(medium);
	elem.setInventoryNumber(inventoryNumber);
	
	persist(elem);
	return elem;
	}
	
}
