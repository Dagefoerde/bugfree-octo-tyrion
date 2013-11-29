package de.wwu.pi.mdsd.umlToApp.gui
import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntryWindowGenerator {
	def generateEntryWindow(Class clazz)  {
	val notMultivalued = clazz.attributes.filter[at | !at.multivalued]
	val anyClass = clazz.attributes.filter[at | at.type instanceof Class]
	val classMultivalued = clazz.attributes.filter[at | at.multivalued && at.type instanceof Class]
	val classNotMultivalued = clazz.attributes.filter[at | !at.multivalued && at.type instanceof Class]
	val notClassNotMultivalued = clazz.attributes.filter[at | !at.multivalued && !(at.type instanceof Class)]
	'''
	
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
«FOR attribute : anyClass »
				import somePackageString.data.«attribute.type.name»;	
			«ENDFOR»
import somePackageString.logic.«clazz.name»Service;
import somePackageString.logic.ServiceInitializer;

public class «clazz.name»EntryWindow extends AbstractEntryWindow<«clazz.name»> «FOR attribute : classMultivalued »
				implements «attribute.type.name»ListingInterface	
			«ENDFOR» {
«FOR attribute : classMultivalued»
	private JList<«attribute.type.name»> li_«attribute.type.name»s;
«ENDFOR»
«FOR attribute : classNotMultivalued» 
	private JComboBox<«attribute.type.name»> cb_«attribute.type.name»;
«ENDFOR»
«FOR attribute : notClassNotMultivalued»
	private JTextField tf_«attribute.name»;
«ENDFOR»
«clazz.name»Service service;
	
	public «clazz.name»EntryWindow(AbstractWindow parent, «clazz.name» currentEntity) {
		super(parent, currentEntity);
		service = ServiceInitializer.getProvider().get«clazz.name»Service();
	}

	@Override
	protected void createFields() {
		int gridy = 0;
		
		
		«FOR attribute : notClassNotMultivalued»	
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lbl«attribute.name» = new JLabel("«attribute.name»*");
		GridBagConstraints gbc_lbl«attribute.name» = new GridBagConstraints();
		gbc_lbl«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.name».anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.name».gridx = 0;
		gbc_lbl«attribute.name».gridy = gridy;
		getPanel().add(lbl«attribute.name», gbc_lbl«attribute.name»);
		
		tf_«attribute.name» = new JTextField(currentEntity.get«attribute.name»());
		GridBagConstraints gbc_tf_«attribute.name» = new GridBagConstraints();
		gbc_tf_«attribute.name».gridwidth = 3;
		gbc_tf_«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_tf_«attribute.name».anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_«attribute.name».fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_«attribute.name».gridx = 1;
		gbc_tf_«attribute.name».weighty = .2;
		gbc_tf_«attribute.name».gridy = gridy;
		getPanel().add(tf_«attribute.name», gbc_tf_«attribute.name»);
		«ENDFOR»
		«FOR attribute : classNotMultivalued» 
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lbl«attribute.type.name» = new JLabel("«attribute.type.name»*");
		GridBagConstraints gbc_lbl«attribute.type.name» = new GridBagConstraints();
		gbc_lbl«attribute.type.name».insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.type.name».anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.type.name».gridx = 0;
		gbc_lbl«attribute.type.name».gridy = gridy;
		getPanel().add(lbl«attribute.type.name», gbc_lbl«attribute.type.name»);
		
		cb_«attribute.type.name» = new JComboBox<«attribute.type.name»>(new Vector<>(ServiceInitializer.getProvider().get«attribute.type.name»Service().getAll()));
		cb_«attribute.type.name».setSelectedItem(currentEntity.get«attribute.type.name»());
		GridBagConstraints gbc_cb_«attribute.type.name» = new GridBagConstraints();
		gbc_cb_«attribute.type.name».gridwidth = 3;
		gbc_cb_«attribute.type.name».insets = new Insets(0, 0, 5, 5);
		gbc_cb_«attribute.type.name».anchor = GridBagConstraints.NORTHWEST;
		gbc_cb_«attribute.type.name».fill = GridBagConstraints.HORIZONTAL;
		gbc_cb_«attribute.type.name».gridx = 1;
		gbc_cb_«attribute.type.name».weighty = .2;
		gbc_cb_«attribute.type.name».gridy = gridy;
		getPanel().add(cb_«attribute.type.name», gbc_cb_«attribute.type.name»);
		«ENDFOR»
	}
	
	@Override
	protected void createLists() {
		int gridy = 0;
		JButton btn;
		GridBagConstraints gbc_btn;
		«FOR attribute : classMultivalued»
		gridy = getNextGridYValue();
		JLabel lbl«attribute.type.name»s = new JLabel("«attribute.type.name»s");
		GridBagConstraints gbc_lbl«attribute.type.name»s = new GridBagConstraints();
		gbc_lbl«attribute.type.name»s.insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.type.name»s.anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.type.name»s.gridx = 0;
		gbc_lbl«attribute.type.name»s.gridy = gridy;
		getPanel().add(lbl«attribute.type.name»s, gbc_lbl«attribute.type.name»s);
		
		li_«attribute.type.name»s = new JList<«attribute.type.name»>();
		initializeLi«attribute.type.name»s();
		GridBagConstraints gbc_li_«attribute.type.name»s = new GridBagConstraints();
		gbc_li_«attribute.type.name»s.gridwidth = 3;
		gbc_li_«attribute.type.name»s.insets = new Insets(0, 0, 5, 5);
		gbc_li_«attribute.type.name»s.fill = GridBagConstraints.BOTH;
		gbc_li_«attribute.type.name»s.gridx = 1;
		gbc_li_«attribute.type.name»s.weighty = .5;
		gbc_li_«attribute.type.name»s.gridy = gridy;
		getPanel().add(li_«attribute.type.name»s, gbc_li_«attribute.type.name»s);
		
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
				new «attribute.type.name»EntryWindow(«clazz.name»EntryWindow.this, new «attribute.type.name»(currentEntity)).open();
			}
		});
		
		btn = new JButton("Edit");
		gbc_btn.gridx = 2;
		btn.setEnabled(!currentEntity.isNew());
		getPanel().add(btn, gbc_btn);
		btn.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				«attribute.type.name» selected = «clazz.name»EntryWindow.this.li_«attribute.type.name»s.getSelectedValue();
				if(selected == null)
					Util.showNothingSelected();
				else
					new «attribute.type.name»EntryWindow(«clazz.name»EntryWindow.this, selected).open();
			}
		});
		
		btn = new JButton("Delete");
		btn.setEnabled(false);
		gbc_btn.gridx = 3;
		getPanel().add(btn, gbc_btn);
	«ENDFOR»
	}


	«FOR attribute : classMultivalued»
	public void initializeLi«attribute.type.name»s() {
		li_«attribute.type.name»s.setListData(new Vector<«attribute.type.name»>(currentEntity.get«attribute.type.name»s()));
	}
	
	@Override
	public void initialize«attribute.type.name»Listings() {
		initializeLi«attribute.type.name»s();
	}
	«ENDFOR»
	
	@Override
	protected boolean saveAction() throws ParseException {
		//Read values from different fields 
		«FOR attribute : clazz.attributes»
		«IF (attribute.type instanceof Class == false) && attribute.multivalued == false»
		«attribute.type.name» «attribute.name» = tf_«attribute.name».getText().isEmpty() ? null : «attribute.type.name».valueOf(tf_«attribute.name».getText());
		«ENDIF»
		«IF (attribute.type instanceof Class) && attribute.multivalued == false»
		«attribute.type.name» «attribute.name» = cb_«attribute.type.name».getItemAt(cb_«attribute.type.name».getSelectedIndex());
		«ENDIF»
		«ENDFOR»
		
		//validation
		try {
			service.validate«clazz.name.toFirstUpper»(«FOR attribute : notMultivalued SEPARATOR ','»«attribute.name»
			«ENDFOR»);
		} catch (ValidationException e) {
			Util.showUserMessage("Validation error for " + e.getField(), "Validation error for " + e.getField() + ": " + e.getMessage());
			return false;
		}
		
		//persist
		currentEntity = service.save«clazz.name»(currentEntity.getOid(), «FOR attribute : notMultivalued SEPARATOR ','»«attribute.name»«ENDFOR»);
		
		//folgenden teil habe ich nicht so ganz gecheckt (ist aus dem BookEntryWindow kopiert)
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
	}