package de.wwu.pi.mdsd.umlToApp.gui
import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntryWindowGenerator {
	def generateEntryWindow(Class clazz) '''
	
package somePackageString.gui;

import java.awt.GridBagConstraints;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.text.ParseException;
import java.util.*;

import javax.swing.*;

import de.wwu.pi.mdsd.framework.gui.*;
import de.wwu.pi.mdsd.framework.logic.ValidationException;

import somePackageString.data.«clazz.name»;
«FOR attribute : clazz.ownedAttributes »
			«IF (attribute.type instanceof Class) && attribute.multivalued»	
				import somePackageString.data.«attribute.name»;
			«ENDIF»		
			«ENDFOR»
import somePackageString.logic.«clazz.name»Service;
import somePackageString.logic.ServiceInitializer;

public class «clazz.name»EntryWindow extends AbstractEntryWindow<Book> «FOR attribute : clazz.ownedAttributes »
			«IF (attribute.type instanceof Class) && attribute.multivalued»	
				implements «attribute.name»ListingInterface
			«ENDIF»		
			«ENDFOR» {
«FOR attribute : clazz.attributes»
	«IF (attribute.type instanceof Class) && attribute.multivalued»	
	private JList<«attribute.name»> li_«attribute.name»s;
	«ENDIF»
	«IF (attribute.type instanceof Class) && attribute.multivalued == false» 
	private JComboBox<«attribute.name»> cb_«attribute.name»;
	«ENDIF»
	«IF (attribute.type instanceof Class == false) && attribute.multivalued == false»
	private JTextField tf_«attribute.name»;
	«ENDIF»
«ENDFOR»
«clazz.name»Service service;
	
	public «clazz.name»EntryWindow(AbstractWindow parent, «clazz.name» currentEntity) {
		super(parent, currentEntity);
		service = ServiceInitializer.getProvider().get«clazz.name»Service();
	}

	@Override
	protected void createFields() {
		int gridy = 0;
		
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lblName = new JLabel("Name*");
		GridBagConstraints gbc_lblName = new GridBagConstraints();
		gbc_lblName.insets = new Insets(0, 0, 5, 5);
		gbc_lblName.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblName.gridx = 0;
		gbc_lblName.gridy = gridy;
		getPanel().add(lblName, gbc_lblName);
		
		tf_Name = new JTextField(currentEntity.getName());
		GridBagConstraints gbc_tf_Name = new GridBagConstraints();
		gbc_tf_Name.gridwidth = 3;
		gbc_tf_Name.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Name.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Name.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Name.gridx = 1;
		gbc_tf_Name.weighty = .2;
		gbc_tf_Name.gridy = gridy;
		getPanel().add(tf_Name, gbc_tf_Name);
		
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lblAuthor = new JLabel("Author*");
		GridBagConstraints gbc_lblAuthor = new GridBagConstraints();
		gbc_lblAuthor.insets = new Insets(0, 0, 5, 5);
		gbc_lblAuthor.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblAuthor.gridx = 0;
		gbc_lblAuthor.gridy = gridy;
		getPanel().add(lblAuthor, gbc_lblAuthor);
		
		tf_Author = new JTextField(currentEntity.getAuthor());
		GridBagConstraints gbc_tf_Author = new GridBagConstraints();
		gbc_tf_Author.gridwidth = 3;
		gbc_tf_Author.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Author.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Author.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Author.gridx = 1;
		gbc_tf_Author.weighty = .2;
		gbc_tf_Author.gridy = gridy;
		getPanel().add(tf_Author, gbc_tf_Author);
		
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lblIsbn = new JLabel("Isbn*");
		GridBagConstraints gbc_lblIsbn = new GridBagConstraints();
		gbc_lblIsbn.insets = new Insets(0, 0, 5, 5);
		gbc_lblIsbn.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblIsbn.gridx = 0;
		gbc_lblIsbn.gridy = gridy;
		getPanel().add(lblIsbn, gbc_lblIsbn);
		
		tf_Isbn = new JTextField(String.valueOf(currentEntity.getIsbn()));
		GridBagConstraints gbc_tf_Isbn = new GridBagConstraints();
		gbc_tf_Isbn.gridwidth = 3;
		gbc_tf_Isbn.insets = new Insets(0, 0, 5, 5);
		gbc_tf_Isbn.anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_Isbn.fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_Isbn.gridx = 1;
		gbc_tf_Isbn.weighty = .2;
		gbc_tf_Isbn.gridy = gridy;
		getPanel().add(tf_Isbn, gbc_tf_Isbn);
	}

	@Override
	protected void createLists() {
		int gridy = 0;
		JButton btn;
		GridBagConstraints gbc_btn;
		gridy = getNextGridYValue();
		JLabel lblCopies = new JLabel("Copies");
		GridBagConstraints gbc_lblCopies = new GridBagConstraints();
		gbc_lblCopies.insets = new Insets(0, 0, 5, 5);
		gbc_lblCopies.anchor = GridBagConstraints.NORTHEAST;
		gbc_lblCopies.gridx = 0;
		gbc_lblCopies.gridy = gridy;
		getPanel().add(lblCopies, gbc_lblCopies);
		
		li_Copies = new JList<Copy>();
		initializeLiCopies();
		GridBagConstraints gbc_li_Copies = new GridBagConstraints();
		gbc_li_Copies.gridwidth = 3;
		gbc_li_Copies.insets = new Insets(0, 0, 5, 5);
		gbc_li_Copies.fill = GridBagConstraints.BOTH;
		gbc_li_Copies.gridx = 1;
		gbc_li_Copies.weighty = .5;
		gbc_li_Copies.gridy = gridy;
		getPanel().add(li_Copies, gbc_li_Copies);
		
		//Button for List Element
		btn = new JButton("Add");
		btn.setEnabled(!currentEntity.isNew());
		gbc_btn = new GridBagConstraints();
		gbc_btn.insets = new Insets(0, 0, 5, 0);
		gbc_btn.gridx = 1;
		gbc_btn.gridy = getNextGridYValue();;
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				new CopyEntryWindow(BookEntryWindow.this, new Copy(currentEntity)).open();
			}
		});
		
		btn = new JButton("Edit");
		gbc_btn.gridx = 2;
		btn.setEnabled(!currentEntity.isNew());
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				Copy selected = BookEntryWindow.this.li_Copies.getSelectedValue();
				if(selected == null)
					Util.showNothingSelected();
				else
					new CopyEntryWindow(BookEntryWindow.this, selected).open();
			}
		});
		
		btn = new JButton("Delete");
		btn.setEnabled(false);
		gbc_btn.gridx = 3;
		getPanel().add(btn, gbc_btn);
	}
	
	public void initializeLiCopies() {
		li_Copies.setListData(new Vector<Copy>(currentEntity.getCopies()));
	}
	
	@Override
	public void initializeCopyListings() {
		initializeLiCopies();
	}
	
	@Override
	protected boolean saveAction() throws ParseException {
		//Read values from different fields 
		String name = tf_Name.getText().isEmpty() ? null : tf_Name.getText();
		String author = tf_Author.getText().isEmpty() ? null : tf_Author.getText();
		Integer isbn = tf_Isbn.getText().isEmpty() ? null : Integer.valueOf(tf_Isbn.getText());
		
		//validation
		try {
			service.validateBook(name, author, isbn);
		} catch (ValidationException e) {
			Util.showUserMessage("Validation error for " + e.getField(), "Validation error for " + e.getField() + ": " + e.getMessage());
			return false;
		}
		
		//persist
		currentEntity = service.saveBook(currentEntity.getOid(), name, author, isbn);
		
		//reload the listing in the parent window to make changes visible
		if(getParent() instanceof MediumListingInterface)
			((MediumListingInterface) getParent()).initializeMediumListings();
		if(getParent() instanceof BookListingInterface)
			((BookListingInterface) getParent()).initializeBookListings();
		return true;
	}
}
	
	
	
	'''
	}