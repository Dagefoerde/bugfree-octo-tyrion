package de.wwu.pi.mdsd05.library.ref.logic;

import java.util.Date;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.Copy;
import de.wwu.pi.mdsd05.library.ref.data.Loan;
import de.wwu.pi.mdsd05.library.ref.data.User;

public class LoanService extends AbstractServiceProvider<Loan> {
	
	//Constructor
	protected LoanService() {
		super();
	}

	public boolean validateLoan(Copy copy, User user, Date issueDate) throws ValidationException {
		if(copy == null)
			throw new ValidationException("copy", "cannot be empty");
		if(user == null)
			throw new ValidationException("user", "cannot be empty");
		if(issueDate == null)
			throw new ValidationException("issueDate", "cannot be empty");
		return true;
	}
	
	public Loan saveLoan(int id, Copy copy, User user, Date issueDate, Date returnDate) {
	Loan elem = getByOId(id);
	if(elem == null)
		elem = new Loan();
	elem.setCopy(copy);
	elem.setUser(user);
	elem.setIssueDate(issueDate);
	elem.setReturnDate(returnDate);
	persist(elem);
	return elem;
	}
	
}
