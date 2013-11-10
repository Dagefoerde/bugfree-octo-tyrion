package de.wwu.pi.mdsd05.library.ref.data;


import java.sql.Date;

import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

public class Loan extends AbstractDataClass{
	private static final long serialVersionUID = -6825176774888285533L;
	protected Date issueDate;
	public Date getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(Date issueDate) {
		this.issueDate = issueDate;
	}
	protected Date returnDate;
	public Date getReturnDate() {
		return returnDate;
	}
	public void setReturnDate(Date returnDate) {
		this.returnDate = returnDate;
	}
	protected Copy copy;
	public Copy getCopy() {
		return copy;
	}
	public void setCopy(Copy copy) {
		this.copy = copy;
	}
	protected User user;
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	
	//Constructor
	public Loan(Copy copy, User user, Date issueDate, Date returnDate) {
		setCopy(copy);
		setUser(user);
		setIssueDate(issueDate);
		setReturnDate(returnDate);
	}
	
	public Loan() {
		super();
	}
	
	@Override
	public String toString() {
		return (getCopy()) + ", " + (getUser())+ ", " + (getIssueDate())+ ", " + (getReturnDate())+ "";
	}
}
