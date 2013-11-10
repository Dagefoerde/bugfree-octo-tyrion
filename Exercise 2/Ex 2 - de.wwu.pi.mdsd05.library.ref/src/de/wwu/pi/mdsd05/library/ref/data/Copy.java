package de.wwu.pi.mdsd05.library.ref.data;


import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

public class Copy extends AbstractDataClass{
	private static final long serialVersionUID = 3092313025089525861L;
	protected Integer inventoryNumber;
	public Integer getInventoryNumber() {
		return inventoryNumber;
	}
	public void setInventoryNumber(Integer inventoryNumber) {
		this.inventoryNumber = inventoryNumber;
	}
	
	protected Medium medium;
	public Medium getMedium() {
		return medium;
	}
	public void setMedium(Medium medium) {
		this.medium = medium;
	}
	
	
	//Constructor
	public Copy(Integer inventoryNumber, Medium medium) {
		setInventoryNumber(inventoryNumber);
		setMedium(medium);
	}
	
	public Copy() {
		super();
	}
	
	@Override
	public String toString() {
		return (getInventoryNumber()) + ", " + (getMedium())+ "";
	}
}
