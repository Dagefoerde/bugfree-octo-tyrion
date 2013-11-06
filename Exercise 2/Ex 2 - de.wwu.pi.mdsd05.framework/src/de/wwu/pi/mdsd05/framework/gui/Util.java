package de.wwu.pi.mdsd05.framework.gui;

import java.text.DateFormat;
import java.text.FieldPosition;
import java.text.ParsePosition;
import java.util.Date;
import java.util.Locale;

import javax.swing.JOptionPane;

public class Util {
	public static final DateFormat DATE_TIME_FORMATTER = new MyDateFormat();
	
	public static void showNothingSelected() {
		JOptionPane.showMessageDialog(null,
			    "Please select an element.",
			    "No Element Selected",
			    JOptionPane.ERROR_MESSAGE);
	}
	
	public static void showElemCouldNotBeEmptyMsg(String elemName) {
		JOptionPane.showMessageDialog(null,
			    elemName +" is a mandatory field and cannot be empty.",
			    elemName +" cannot be empty",
			    JOptionPane.ERROR_MESSAGE);
	}
	
	public static void showUserMessage(String title, String message) {
		JOptionPane.showMessageDialog(null,
			    message,
			    title,
			    JOptionPane.ERROR_MESSAGE);
	}
	
	public static void showImplementAction() {
		Util.showUserMessage("No Action Implemented", "This action is not implemented jet. Please implement this action.");
	}

	//Standard Date Format can not deal with null date elements.
	@SuppressWarnings("serial")
	static class MyDateFormat extends DateFormat {
		static final DateFormat FORMATTER = DateFormat.getDateInstance(DateFormat.SHORT , Locale.GERMAN);

		@Override
		public StringBuffer format(Date date, StringBuffer toAppendTo,
				FieldPosition fieldPosition) {
			if(date == null)
				return toAppendTo;
			return FORMATTER.format(date, toAppendTo, fieldPosition);
		}

		@Override
		public Date parse(String source, ParsePosition pos) {
			// TODO Auto-generated method stub
			return FORMATTER.parse(source, pos);
		}
	}
}