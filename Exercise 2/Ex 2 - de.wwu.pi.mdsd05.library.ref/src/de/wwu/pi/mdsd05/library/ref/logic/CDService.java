package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.Collection;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.CD;

public class CDService extends AbstractServiceProvider<CD>{

	
	private static final long serialVersionUID = 6114246295799356828L;

	protected CDService() {
		super();
	}
	
	public boolean validateCD(String name, int ASIN, String interpreter) throws ValidationException {
		if(name == null)
			throw new ValidationException("name", "cannot be empty");
		if(ASIN == 0)
			throw new ValidationException("ASIN", "cannot be empty");
		if(interpreter == null)
			throw new ValidationException("interpreter", "cannot be empty");
		return true;
	}
	
	public CD saveCD(int id,String name, int ASIN, String interpreter) {
	CD elem = getByOId(id);
	if(elem == null) elem = new CD();
	elem.setName(name);
	elem.setASIN(ASIN);
	elem.setInterpreter(interpreter);
	persist(elem);
	return elem;
	}
	
	
	public CD getByASIN(int ASIN)
	{
		Collection<CD> cds = getAll();
			for(CD elem : cds )
			{
				if(elem.getASIN() == ASIN) return elem;
				
			}
			return null;
	
	}
}
