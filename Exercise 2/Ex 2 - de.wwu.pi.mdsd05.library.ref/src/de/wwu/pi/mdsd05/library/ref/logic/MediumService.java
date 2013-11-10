package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.Date;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Loan;
import de.wwu.pi.mdsd05.library.ref.data.Medium;

public class MediumService extends AbstractServiceProvider<Medium> {
	
	//Constructor
	protected MediumService() {
		super();
	}

	public boolean validateLoan(String name) throws ValidationException {
		if(name == null)
			throw new ValidationException("name", "cannot be empty");
		return true;
	}
	
}
