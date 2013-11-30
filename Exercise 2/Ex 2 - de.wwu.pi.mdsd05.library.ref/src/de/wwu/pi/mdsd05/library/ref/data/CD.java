package de.wwu.pi.mdsd05.library.ref.data;

public class CD extends Medium{

	private static final long serialVersionUID = 5881337167782580070L;

	protected int ASIN;
	public int getASIN() {
		return ASIN;
	}
	public void setASIN(int asin) {
		this.ASIN = asin;
	}
	
	
	protected String interpreter;
	public String getInterpreter() {
		return interpreter;
	}
	public void setInterpreter(String interpreter) {
		this.interpreter = interpreter;
	}
	
	//Constructor
	public CD(int asin, String interpreter, String name) {
		setASIN(asin);
		setInterpreter(interpreter);
		setName(name);
	}
	
	public CD() {
		super();
	}
	
	@Override
	public String toString() {
		return (getName()) + ", " + (getASIN()) + ", " + (getInterpreter())+ "";
	}
	

}
