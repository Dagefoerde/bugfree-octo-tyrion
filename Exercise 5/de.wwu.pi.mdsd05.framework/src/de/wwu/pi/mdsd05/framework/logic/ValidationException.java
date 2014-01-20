package de.wwu.pi.mdsd05.framework.logic;

public class ValidationException extends Exception {
	String field,message;
	public ValidationException(String field, String message) {
		this.field = field;
		this.message = message;
	}
	
	public String getMessage() {
		return message;
	}
	
	public String getField() {
		return field;
	}
}
