package de.wwu.pi.mdsd.umlToApp.gui

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntryWindowGenerator {
	def generateEntryWindow(Class clazz)  {
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
«FOR attribute : clazz.listOfClassAttributes»
				import somePackageString.data.«attribute.type.name»;	
			«ENDFOR»
import somePackageString.logic.«clazz.name»Service;
import somePackageString.logic.ServiceInitializer;

public class «clazz.name»EntryWindow extends AbstractEntryWindow<«clazz.name»> «IF clazz.listOfMultivaluedClassAttributes.size>0»implements«ENDIF»  «FOR attribute : clazz.listOfMultivaluedClassAttributes SEPARATOR ','»
				 «attribute.type.name»ListingInterface	
			«ENDFOR» {
«FOR attribute : clazz.listOfMultivaluedClassAttributes»
	private JList<«attribute.type.name»> li_«attribute.name»s;
«ENDFOR»
«FOR attribute : clazz.listOfNotMultivaluedClassAttributes» 
	private JComboBox<«attribute.type.name»> cb_«attribute.name»;
«ENDFOR»
«FOR attribute : clazz.listOfNotMultivaluedNonClassAttributes»
	private JTextField tf_«attribute.name»;
«ENDFOR»
private «clazz.name»Service service;
	
	public «clazz.name»EntryWindow(AbstractWindow parent, «clazz.name» currentEntity) {
		super(parent, currentEntity);
		service = ServiceInitializer.getProvider().get«clazz.name.toFirstUpper»Service();
	}

	@Override
	protected void createFields() {
		int gridy = 0;
		
		
		«FOR attribute : clazz.listOfNotMultivaluedNonClassAttributes»	
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lbl«attribute.name» = new JLabel("«attribute.name.toFirstUpper»«IF attribute.lowerBound>0»*«ENDIF»");
		GridBagConstraints gbc_lbl«attribute.name» = new GridBagConstraints();
		gbc_lbl«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.name».anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.name».gridx = 0;
		gbc_lbl«attribute.name».gridy = gridy;
		getPanel().add(lbl«attribute.name», gbc_lbl«attribute.name»);
		
		«IF attribute.type.name.equals("Date")»
		tf_«attribute.name» = new JTextField(Util.DATE_TIME_FORMATTER.format(currentEntity.get«attribute.name.toFirstUpper»()));
		«ELSE»
		tf_«attribute.name» = new JTextField(currentEntity.get«attribute.name.toFirstUpper»()==null?"":currentEntity.get«attribute.name.toFirstUpper»().toString());
		«ENDIF»
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
		«FOR attribute : clazz.listOfNotMultivaluedClassAttributes» 
		//set new Line
		gridy = getNextGridYValue();
		
		JLabel lbl«attribute.name» = new JLabel("«attribute.name.toFirstUpper»«IF attribute.lowerBound>0»*«ENDIF»");
		GridBagConstraints gbc_lbl«attribute.name» = new GridBagConstraints();
		gbc_lbl«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.name».anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.name».gridx = 0;
		gbc_lbl«attribute.name».gridy = gridy;
		getPanel().add(lbl«attribute.name», gbc_lbl«attribute.name»);
		
		cb_«attribute.name» = new JComboBox<«attribute.type.name»>(new Vector<>(ServiceInitializer.getProvider().get«attribute.name.toFirstUpper»Service().getAll()));
		cb_«attribute.name».setSelectedItem(currentEntity.get«attribute.name.toFirstUpper»());
		GridBagConstraints gbc_cb_«attribute.name» = new GridBagConstraints();
		gbc_cb_«attribute.name».gridwidth = 3;
		gbc_cb_«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_cb_«attribute.name».anchor = GridBagConstraints.NORTHWEST;
		gbc_cb_«attribute.name».fill = GridBagConstraints.HORIZONTAL;
		gbc_cb_«attribute.name».gridx = 1;
		gbc_cb_«attribute.name».weighty = .2;
		gbc_cb_«attribute.name».gridy = gridy;
		getPanel().add(cb_«attribute.name», gbc_cb_«attribute.name»);
		«ENDFOR»
	}
	
	@Override
	protected void createLists() {
		int gridy = 0;
		JButton btn;
		GridBagConstraints gbc_btn;
		«FOR attribute : clazz.listOfMultivaluedClassAttributes»
		gridy = getNextGridYValue();
		JLabel lbl«attribute.name»s = new JLabel("«attribute.name.toFirstUpper»s");
		GridBagConstraints gbc_lbl«attribute.name»s = new GridBagConstraints();
		gbc_lbl«attribute.name»s.insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.name»s.anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.name»s.gridx = 0;
		gbc_lbl«attribute.name»s.gridy = gridy;
		getPanel().add(lbl«attribute.name»s, gbc_lbl«attribute.name»s);
		
		li_«attribute.name»s = new JList<«attribute.type.name»>();
		initializeLi«attribute.name.toFirstUpper»s();
		GridBagConstraints gbc_li_«attribute.name»s = new GridBagConstraints();
		gbc_li_«attribute.name»s.gridwidth = 3;
		gbc_li_«attribute.name»s.insets = new Insets(0, 0, 5, 5);
		gbc_li_«attribute.name»s.fill = GridBagConstraints.BOTH;
		gbc_li_«attribute.name»s.gridx = 1;
		gbc_li_«attribute.name»s.weighty = .5;
		gbc_li_«attribute.name»s.gridy = gridy;
		getPanel().add(li_«attribute.name»s, gbc_li_«attribute.name»s);
		
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
				«attribute.type.name» selected = «clazz.name»EntryWindow.this.li_«attribute.name»s.getSelectedValue();
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


	«FOR attribute : clazz.listOfMultivaluedClassAttributes»
	public void initializeLi«attribute.name.toFirstUpper»s() {
		li_«attribute.name»s.setListData(new Vector<«attribute.type.name»>(currentEntity.get«attribute.name.toFirstUpper»s()));
	}
	
	@Override
	public void initialize«attribute.name.toFirstUpper»Listings() {
		initializeLi«attribute.name.toFirstUpper»s();
	}
	«ENDFOR»
	
	@Override
	protected boolean saveAction() throws ParseException {
		//Read values from different fields 
		«FOR attribute : clazz.listOfNotMultivaluedNonClassAttributes»
			«IF attribute.type.name.equals("Date")»
				«attribute.type.name» «attribute.name» = tf_«attribute.name».getText().isEmpty() ? null : Util.DATE_TIME_FORMATTER.parse(tf_«attribute.name».getText());
			«ELSE»
				«attribute.type.name» «attribute.name» = tf_«attribute.name».getText().isEmpty() ? null : «attribute.type.name».valueOf(tf_«attribute.name».getText());
			«ENDIF»
		«ENDFOR»
		«FOR attribute : clazz.listOfNotMultivaluedClassAttributes»
			«attribute.type.name» «attribute.name» = cb_«attribute.name».getItemAt(cb_«attribute.name».getSelectedIndex());
		«ENDFOR»
		
		//validation
		try {
			service.validate«clazz.name.toFirstUpper»(«FOR attribute : clazz.listOfNotMultivaluedAttributes SEPARATOR ','»«attribute.name»
			«ENDFOR»);
		} catch (ValidationException e) {
			Util.showUserMessage("Validation error for " + e.getField(), "Validation error for " + e.getField() + ": " + e.getMessage());
			return false;
		}
		
		//persist
		currentEntity = service.save«clazz.name.toFirstUpper»(currentEntity.getOid(), «FOR attribute : clazz.listOfNotMultivaluedAttributes SEPARATOR ','»«attribute.name»«ENDFOR»);
		
		//reload the listing in the parent window to make changes visible
		«IF clazz.isGeneralized»
		if(getParent() instanceof «clazz.generalizations.get(0).general.name»ListingInterface)
			(( «clazz.generalizations.get(0).general.name»ListingInterface) getParent()).initialize«clazz.generalizations.get(0).general.name»Listings();
			«ENDIF»
		if(getParent() instanceof «clazz.name»ListingInterface)
			((«clazz.name»ListingInterface) getParent()).initialize«clazz.name»Listings();
		return true;
	}
}
	
	
	
	'''
	
	}
	}
	
