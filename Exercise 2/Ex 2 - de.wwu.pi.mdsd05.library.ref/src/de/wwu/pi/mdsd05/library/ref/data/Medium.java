package de.wwu.pi.mdsd05.library.ref.data;

import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

public abstract class Medium extends AbstractDataClass {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2607767705950788721L;
	protected String name;
	
	public void setName(String name){
		this.name = name;
	}
	public String getName(){
		return this.name;
	}
	
	public Medium (String name){
		this.name = name;
	}
	
	public Medium (){
		super();
	}

	@Override
	public String toString() {
		return getName();
	}

}
