package de.wwu.pi.mdsd05.library.ref.data;


import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

public class User extends AbstractDataClass{
	private static final long serialVersionUID = 3092313025089525861L;
	protected String name;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	protected String address;
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	
	//Constructor
	public User(String name, String address) {
		setName(name);
		setAddress(address);
	}
	
	public User() {
		super();
	}
	
	@Override
	public String toString() {
		return (getName()) + ", " + (getAddress())+ "";
	}
}
