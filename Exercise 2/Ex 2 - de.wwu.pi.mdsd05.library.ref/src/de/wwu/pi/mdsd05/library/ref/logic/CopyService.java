package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.data.Medium;

public class CopyService extends AbstractServiceProvider<Copy> {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4894922972459195001L;

	//Constructor
	protected CopyService() {
		super();
	}

	public boolean validateCopy(int inventoryNumber, Medium medium) throws ValidationException {
		if(inventoryNumber == 0)
			throw new ValidationException("inventoryNumber", "cannot be zero");
		if(InventoryNumberAlreadyExists(inventoryNumber))
			throw new ValidationException("inventoryNumber", "already exists");
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

	public Collection<Copy> getAllByMedium(Medium currentEntity) {
		Collection<Copy> result= new LinkedList<Copy>();
		for (Copy copy:getAll()){
			if (copy.getMedium().equals(currentEntity))
				result.add(copy);
		}
		return result;
	}
	
	public boolean InventoryNumberAlreadyExists(int invNo)
	{
		Collection<Copy> copies = getAll();
		if(copies.isEmpty()) return false;
		else {
			for(Iterator i = copies.iterator(); i.hasNext(); )
			{
				Copy elem = (Copy) i.next();
				if(elem.getInventoryNumber() == invNo) return true;
			}
			return false;
	
		} 	
	}

}
