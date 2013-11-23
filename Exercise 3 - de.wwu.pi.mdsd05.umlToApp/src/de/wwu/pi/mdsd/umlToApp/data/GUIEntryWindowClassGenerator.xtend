package de.wwu.pi.mdsd.umlToApp.data;

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property
import java.util.Date
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.BasicEList

//Production state
class GUIEntryWindowClassGenerator {
	def generateGUIEntryWindowClass(Class clazz) {
	var listOfAllAttributes=clazz.attributes.toSet
	var listOfAttributes=clazz.attributes.toSet
	var EList<Property> listOfSuperAttributes=new BasicEList<Property>()
	var boolean isGeneralized=clazz.generalizations.size>0
	if(isGeneralized){
	listOfSuperAttributes=clazz.generalizations.get(0).general.attributes
	listOfAllAttributes.addAll(clazz.generalizations.get(0).general.attributes.toList)}
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
import somePackageString.data.*;
import somePackageString.logic.*;

public class «clazz.name»EntryWindow extends AbstractEntryWindow<«clazz.name»> 
«IF listOfAllAttributes.exists[att|att.multivalued==true]»implements«ENDIF» «FOR attribute:listOfAllAttributes.filter[att|att.multivalued==true] SEPARATOR ','»«attribute.type.name»ListingInterface «ENDFOR» {

	«FOR attribute:listOfAllAttributes»
	«IF attribute.type instanceof Class && attribute.multivalued»
	private JList<«attribute.type.name»> li_«attribute.name»s;
	«ELSEIF attribute.type instanceof Class »
	private JComboBox<«attribute.type.name»> cb_«attribute.name»;
	«ELSE»
	private JTextField tf_«attribute.name»;
	«ENDIF»
	«ENDFOR»
	«clazz.name»Service service;
	
	public «clazz.name»EntryWindow(AbstractWindow parent, «clazz.name» currentEntity) {
		super(parent, currentEntity);
		service = ServiceInitializer.getProvider().get«clazz.name.toFirstUpper»Service();
	}

	@Override
	protected void createFields() {
		int gridy = 0;
		«FOR attribute:listOfAllAttributes.filter[att|att.multivalued==false]»
		//set new Line
		gridy = getNextGridYValue();
		«IF attribute.type instanceof Class»
		JLabel lbl«attribute.name» = new JLabel("«attribute.name»«IF attribute.lowerBound>0»*«ENDIF»");
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
		«ELSE»
		JLabel lbl«attribute.name» = new JLabel("«attribute.name»«IF attribute.lowerBound>0»*«ENDIF»");
		GridBagConstraints gbc_lbl«attribute.name» = new GridBagConstraints();
		gbc_lbl«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_lbl«attribute.name».anchor = GridBagConstraints.NORTHEAST;
		gbc_lbl«attribute.name».gridx = 0;
		gbc_lbl«attribute.name».gridy = gridy;
		getPanel().add(lbl«attribute.name», gbc_lbl«attribute.name»);
		
		tf_«attribute.name» = new JTextField(currentEntity.get«attribute.name.toFirstUpper»().toString());
		GridBagConstraints gbc_tf_«attribute.name» = new GridBagConstraints();
		gbc_tf_«attribute.name».gridwidth = 3;
		gbc_tf_«attribute.name».insets = new Insets(0, 0, 5, 5);
		gbc_tf_«attribute.name».anchor = GridBagConstraints.NORTHWEST;
		gbc_tf_«attribute.name».fill = GridBagConstraints.HORIZONTAL;
		gbc_tf_«attribute.name».gridx = 1;
		gbc_tf_«attribute.name».weighty = .2;
		gbc_tf_«attribute.name».gridy = gridy;
		getPanel().add(tf_«attribute.name», gbc_tf_«attribute.name»);
		«ENDIF»
		«ENDFOR»
		}
		
	@Override
	protected void createLists() {
		int gridy = 0;
		JButton btn;
		GridBagConstraints gbc_btn;
		«FOR attribute:listOfAllAttributes.filter[att|att.multivalued==true]»
		gridy = getNextGridYValue();
		JLabel lbl«attribute.name»s = new JLabel("«attribute.name»s");
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
				new «attribute.name.toFirstUpper»EntryWindow(«clazz.name»EntryWindow.this, new «attribute.type.name»(currentEntity)).open();
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
					new «attribute.name.toFirstUpper»EntryWindow(«clazz.name»EntryWindow.this, selected).open();
			}
		});
		
		btn = new JButton("Delete");
		btn.setEnabled(false);
		gbc_btn.gridx = 3;
		getPanel().add(btn, gbc_btn);
		«ENDFOR»
	}
	
	«FOR attribute:listOfAllAttributes.filter[att|att.multivalued==true]»
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
		«FOR attribute:listOfAllAttributes.filter[att|att.multivalued==false]»
		«IF attribute.type instanceof Class»
			«attribute.type.name» «attribute.name»  = cb_«attribute.name».getItemAt(cb_«attribute.name».getSelectedIndex());
		«ELSE»
			«IF attribute.type.name.equals(String.simpleName)»
				«attribute.type.name» «attribute.name» = tf_«attribute.name».getText().isEmpty() ? null : tf_«attribute.name».getText();
			«ELSEIF attribute.type.name.equals(Date.simpleName)»
				«attribute.type.name» «attribute.name» = tf_«attribute.name».getText().isEmpty() ? null : Util.DATE_TIME_FORMATTER.parse(tf_«attribute.name».getText());
			«ELSEIF attribute.type.name.equals(Integer.simpleName)»
				«attribute.type.name» «attribute.name» = tf_«attribute.name».getText().isEmpty() ? null : Integer.valueOf(tf_«attribute.name».getText());
			«ENDIF»
		«ENDIF»
		«ENDFOR»
		//validation
		try {
			service.validate«clazz.name.toFirstUpper»(«FOR attribute:listOfAllAttributes.filter[att|att.multivalued==false] SEPARATOR ','»«attribute.name»«ENDFOR»);
		} catch (ValidationException e) {
			Util.showUserMessage("Validation error for " + e.getField(), "Validation error for " + e.getField() + ": " + e.getMessage());
			return false;
		}
		
		//persist
		currentEntity = service.save«clazz.name.toFirstUpper»(currentEntity.getOid(), «FOR attribute:listOfAllAttributes.filter[att|att.multivalued==false] SEPARATOR ','»«attribute.name»«ENDFOR»);
		
		//reload the listing in the parent window to make changes visible
		if(getParent() instanceof MediumListingInterface)
			((MediumListingInterface) getParent()).initializeMediumListings();
		if(getParent() instanceof BookListingInterface)
			((BookListingInterface) getParent()).initializeBookListings();
		return true;
	}
}
	
	'''}
}
