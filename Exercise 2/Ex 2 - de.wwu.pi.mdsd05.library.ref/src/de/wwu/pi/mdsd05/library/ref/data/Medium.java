package de.wwu.pi.mdsd05.library.ref.data;

import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

public abstract class Medium extends AbstractDataClass {
	
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

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return null;
	}

}
