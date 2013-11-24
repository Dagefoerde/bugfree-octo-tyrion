package de.wwu.pi.mdsd.umlToApp.gui

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class StartWindowClassGenerator {
	def generateStartWindowClass (Iterable<Class> entities) '''
package de.wwu.pi.mdsd.library.ref.gui;
	
import java.awt.GridBagConstraints;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

import de.wwu.pi.mdsd.framework.gui.AbstractStartWindow;
import de.wwu.pi.mdsd.library.ref.logic.ServiceInitializer;	

public class StartWindowClass extends AbstractStartWindow {
	
	@Override
	protected void ListChoices() {
		
		«FOR clazz : entities»
		JButton «clazz.name»ListWindow = new JButton("List «clazz.name.toFirstUpper» Elements");
		GridBagConstraints gbc_userListWindow = new GridBagConstraints();
		gbc_userListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_userListWindow.gridx = 1;
		gbc_userListWindow.gridy = getNextGridY();
		getPanel().add(userListWindow, gbc_userListWindow);
		userListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new UserListWindow(StartWindowClass.this).open();
			}
		});
		«ENDFOR»

		JButton userListWindow = new JButton("List User Elements");
		GridBagConstraints gbc_userListWindow = new GridBagConstraints();
		gbc_userListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_userListWindow.gridx = 1;
		gbc_userListWindow.gridy = getNextGridY();
		getPanel().add(userListWindow, gbc_userListWindow);
		userListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new UserListWindow(StartWindowClass.this).open();
			}
		});
		JButton loanListWindow = new JButton("List Loan Elements");
		GridBagConstraints gbc_loanListWindow = new GridBagConstraints();
		gbc_loanListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_loanListWindow.gridx = 1;
		gbc_loanListWindow.gridy = getNextGridY();
		getPanel().add(loanListWindow, gbc_loanListWindow);
		loanListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new LoanListWindow(StartWindowClass.this).open();
			}
		});
		JButton copyListWindow = new JButton("List Copy Elements");
		GridBagConstraints gbc_copyListWindow = new GridBagConstraints();
		gbc_copyListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_copyListWindow.gridx = 1;
		gbc_copyListWindow.gridy = getNextGridY();
		getPanel().add(copyListWindow, gbc_copyListWindow);
		copyListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new CopyListWindow(StartWindowClass.this).open();
			}
		});
		JButton mediumListWindow = new JButton("List Medium Elements");
		GridBagConstraints gbc_mediumListWindow = new GridBagConstraints();
		gbc_mediumListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_mediumListWindow.gridx = 1;
		gbc_mediumListWindow.gridy = getNextGridY();
		getPanel().add(mediumListWindow, gbc_mediumListWindow);
		mediumListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new MediumListWindow(StartWindowClass.this).open();
			}
		});
		JButton bookListWindow = new JButton("List Book Elements");
		GridBagConstraints gbc_bookListWindow = new GridBagConstraints();
		gbc_bookListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_bookListWindow.gridx = 1;
		gbc_bookListWindow.gridy = getNextGridY();
		getPanel().add(bookListWindow, gbc_bookListWindow);
		bookListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new BookListWindow(StartWindowClass.this).open();
			}
		});
		JButton cDListWindow = new JButton("List CD Elements");
		GridBagConstraints gbc_cDListWindow = new GridBagConstraints();
		gbc_cDListWindow.insets = new Insets(0, 0, 5, 5);
		gbc_cDListWindow.gridx = 1;
		gbc_cDListWindow.gridy = getNextGridY();
		getPanel().add(cDListWindow, gbc_cDListWindow);
		cDListWindow.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent arg0) {
				new CDListWindow(StartWindowClass.this).open();
			}
		});
	}
	
	@Override
	protected void closeWindow()  {
		ServiceInitializer.serialize();
		super.closeWindow();
	}
	
	public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException, UnsupportedLookAndFeelException {
		UIManager.setLookAndFeel(
			UIManager.getSystemLookAndFeelClassName());
			//"com.sun.java.swing.plaf.windows.WindowsLookAndFeel");
		new StartWindowClass().open();
	}
}
	
	'''
}