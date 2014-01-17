package de.wwu.pi.mdsd.umlToApp.gui

import de.wwu.pi.mdsd.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Type

import de.wwu.pi.mdsd.crudDsl.crudDsl.Property


import static extension de.wwu.pi.mdsd.umlToApp.util.EntityHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.Label
import de.wwu.pi.mdsd.crudDsl.crudDsl.Field
import de.wwu.pi.mdsd.crudDsl.crudDsl.Button
import de.wwu.pi.mdsd.crudDsl.crudDsl.Attribute
import de.wwu.pi.mdsd.crudDsl.crudDsl.Reference
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity

class EntryWindowGenerator extends GeneratorWithImports<EntryWindow> {
	
	override doGenerate(EntryWindow window) '''
		package «window.name»;
		
		import java.awt.GridBagConstraints;
		import java.awt.Insets;
		import java.awt.event.ActionEvent;
		import java.awt.event.ActionListener;
		import java.text.ParseException;
		import java.util.*;
		
		import javax.swing.*;
		
		import de.wwu.pi.mdsd.framework.gui.*;
		import de.wwu.pi.mdsd.framework.logic.ValidationException;
		«IMPORTS_MARKER»
		
		public class «window.name» extends AbstractEntryWindow<«importedType(window.entity)»> «window.entity.listingTypes.join("implements ",", "," ", [listingInterfaceClassName])»{
			«	/* Declare Service class (+ adds full qualified name to import list) */
				imported( window.logicPackageString + "."+window.entity.serviceClassName)» service;

			«	/* declare fields for each attribute */
			 FOR elem : window.elements.filter(typeof(Field))»
				private «elem.inputFieldType» fld«elem.name»;
			«ENDFOR»
					
			public «window.name»(AbstractWindow parent, «window.entity.javaType» currentEntity) {
				super(parent, currentEntity, «window.size.width», «window.size.height»);
				service = «imported(window.logicPackageString + ".ServiceInitializer")».getProvider().get«window.entity.serviceClassName»();
			}
		
			@Override
			
			protected void createUIElements() {
				int gridy = 0;
				«FOR elem : window.elements»
					
					«IF(elem instanceof Label)»
					
					JLabel lbl«elem.name» = new JLabel("«elem.name»");
					lbl«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
					contentPane.add(lbl«elem.name»);
		
		
					«ELSEIF(elem instanceof Field)»
						«IF ((elem as Field).property instanceof Attribute)»
							fld«elem.name» = «((elem as Field).initializeField)»;
							fld«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
							contentPane.add(fld«elem.name»);
							fld«elem.name».setColumns(10);
						«ELSEIF ((elem as Field).property instanceof Reference)»
							«IF (((elem as Field).property as Reference).multiplicity == 0)»
							JComboBox cb«elem.name» = new JComboBox();
							cb«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
							contentPane.add(cb«elem.name»);
							«ELSEIF (((elem as Field).property as Reference).multiplicity == 1)»
							«ENDIF»
						«ENDIF»					
					«ELSEIF(elem instanceof Button)»
							
					JButton btn«elem.name» = new JButton("«elem.name»");
					btn«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
					contentPane.add(btn«elem.name»);
					
					«ENDIF»
				«ENDFOR»
			}
			
			
			« /* readable List Window Title */»
			@Override
			protected String getTitle() {
				return "«window.windowTitle»";//Edit " + currentEntity.getClass().getSimpleName() + " Window";
			}
			
			@Override
			protected boolean saveAction() throws ParseException {
				//Read values from different fields 
				«FOR prop : window.entity.singleValueProperties(true)»
					« /* declare and initialize local variables to handle imports */
					switch (prop){
					case (Attribute):(prop as Attribute).type.name.objectType
					case (Reference): (prop as Reference).type.name.objectType
					}»
					  «prop.name» = «prop.retrieveValueFromFieldCode»;
				«ENDFOR»
				
				«val attributeNames = window.entity.singleValueProperties(true).join(", ",[name])»
				//validation
				try {
					service.validate«window.entity.name»(«attributeNames»);
				} catch (ValidationException e) {
					Util.showUserMessage("Validation error for " + e.getField(), "Validation error for " + e.getField() + ": " + e.getMessage());
					return false;
				}
				
				//persist
				currentEntity = service.save«window.entity.name»(currentEntity.getOid()«if(!attributeNames.empty) ', ' + attributeNames»);
				
				//reload the listing in the parent window to make changes visible
				«FOR currClass : (window.entity.allSuperClasses + #{window.entity}) »	
					if(getParent() instanceof «currClass.listingInterfaceClassName»)
						((«currClass.listingInterfaceClassName») getParent()).«currClass.listingInterfaceMethodeName»();
				«ENDFOR»
				return true;
			}
			
			«FOR rerference : window.entity.multiReferences(true).filter[rerference | rerference.hasSubClasses ]»
				javax.swing.JComboBox<String> «rerference.inheritanceTypeSelectName» = new javax.swing.JComboBox<>();
			«ENDFOR»
			@Override
			protected void createLists() {
				int gridy = 0;
				«FOR elem : window.elements.filter(Field).filter[field|field.property instanceof Reference && (field.property as Reference).isMultivalued]»
					
							fld«elem.name» = «(elem.initializeField)»;
							fld«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
							contentPane.add(fld«elem.name»);
							fld«elem.name».setColumns(10);
					«ENDFOR»
«««				«FOR element: window.elements.filter(Field)»
«««				int gridy = 0;
«««				JButton btn;
«««				GridBagConstraints gbc_btn;
«««				«FOR ref : window.entity.multiReferences(true)»				
«««					gridy = getNextGridYValue();
«««					JLabel «ref.labelName» = new JLabel("«ref.readableLabel + (if(ref.required) '*' else '')»");
«««					GridBagConstraints gbc_«ref.labelName» = new GridBagConstraints();
«««					gbc_«ref.labelName».insets = new Insets(0, 0, 5, 5);
«««					gbc_«ref.labelName».anchor = GridBagConstraints.NORTHEAST;
«««					gbc_«ref.labelName».gridx = 0;
«««					gbc_«ref.labelName».gridy = gridy;
«««					getPanel().add(«ref.labelName», gbc_«ref.labelName»);
«««					
«««					«ref.fieldName» = «ref.initializeField»;
«««					GridBagConstraints gbc_«ref.fieldName» = new GridBagConstraints();
«««					gbc_«ref.fieldName».gridwidth = 5;
«««					gbc_«ref.fieldName».insets = new Insets(0, 0, 5, 5);
«««					gbc_«ref.fieldName».fill = GridBagConstraints.BOTH;
«««					gbc_«ref.fieldName».gridx = 1;
«««					gbc_«ref.fieldName».weighty = .5;
«««					gbc_«ref.fieldName».gridy = gridy;
«««					getPanel().add(«ref.fieldName», gbc_«ref.fieldName»);
«««					
«««					gridy = getNextGridYValue();
«««					« /* Special handling of attributes with inheritance */
«««					 IF ref.hasSubClasses »
«««					
«««						«ref.createSelectForInheritanceClasses("2","gridy")»
«««					«ENDIF»
«««					
«««					//Button for List Element
«««					btn = new JButton("Add");
«««					btn.setEnabled(!currentEntity.isNew());
«««					gbc_btn = new GridBagConstraints();
«««					gbc_btn.insets = new Insets(0, 0, 5, 0);
«««					gbc_btn.gridx = 3;
«««					gbc_btn.gridy = gridy;
«««					getPanel().add(btn, gbc_btn);
«««					btn.addActionListener(new ActionListener() {
«««						@Override
«««						public void actionPerformed(ActionEvent e) {
«««							«IF ref.hasSubClasses»
«««								«ref.type.name» entity = null;
«««								«FOR subClass : ref.opposite.class_.instantiableClasses»
«««									if(«clazz.entryWindowClassName».this.«ref.inheritanceTypeSelectName».getSelectedItem().equals("«importedType(subClass)»"))
«««										entity = new «subClass.name»().«ref.opposite.initializeSingleRefMethodName»(currentEntity);
«««								«ENDFOR»
«««								«ref.opposite.class_.inheritanceCallOpenEntryWindow(ref.class_.entryWindowClassName+".this")»
«««							«ELSE»
«««								new «ref.opposite.class_.entryWindowClassName»(«clazz.entryWindowClassName».this, new «ref.type.name»().«ref.opposite.initializeSingleRefMethodName»(currentEntity)).open();
«««							«ENDIF»
«««						}
«««					});
«««					
«««					btn = new JButton("Edit");
«««					gbc_btn.gridx = 4;
«««					btn.setEnabled(!currentEntity.isNew());
«««					getPanel().add(btn, gbc_btn);
«««					btn.addActionListener(new ActionListener() {
«««						@Override
«««						public void actionPerformed(ActionEvent e) {
«««							«ref.type.name» entity = «clazz.entryWindowClassName».this.«ref.fieldName».getSelectedValue();
«««							if(entity == null)
«««								Util.showNothingSelected();
«««							else
«««								«IF ref.hasSubClasses»
«««									«ref.opposite.class_.inheritanceCallOpenEntryWindow(ref.class_.entryWindowClassName+".this")»
«««								«ELSE»
«««									new «ref.opposite.class_.entryWindowClassName»(«clazz.entryWindowClassName».this, entity).open();
«««								«ENDIF»
«««						}
«««					});
«««					
«««					btn = new JButton("Delete");
«««					btn.setEnabled(false);
«««					gbc_btn.gridx = 5;
«««					getPanel().add(btn, gbc_btn);
«««				«ENDFOR»
			}
			« /* Create list initializer methods; one for each list */
			FOR att : window.entity.multiReferences(true)»
				
				public void «att.listInitializeMethodName»() {
					«att.fieldName».setListData(new Vector<«att.type.name»>(currentEntity.get«att.nameInJava.toFirstUpper»()));
				}
			«ENDFOR»
			« /* Create listing methods required due to listing interfaces */
			 FOR type : window.entity.listingTypes»
				
				@Override
				public void «type.listingInterfaceMethodeName»() {
					«FOR att : window.entity.multiReferences(true).filter[it.type.equals(type)]»
						«att.listInitializeMethodName»();
					«ENDFOR»
				}
			«ENDFOR»
		}
	'''
	
	/* Get types for all classes that are multi-referenced and thus a listing is presented within this window */
	def listingTypes(Entity entity) {
		entity.multiReferences(true).map[type].toSet
	}
	
	//Initializes input fields and if necessary selects 
	def initializeField(Field p) {
		switch (p.property) {
			Attribute: '''new «p.inputFieldType»(«(p as Attribute).formattedTextCode»)'''
			Reference:
				if ((p.property as Reference).multiplicity == 0) {
					'''
					new «p.inputFieldType»();
					«p.property.listInitializeMethodName»()'''
				} else {
					'''
					new «p.inputFieldType»(new Vector<>(ServiceInitializer.getProvider().get«(p.property as Reference).type.serviceClassName»().getAll()));
					«p.property.fieldName».setSelectedItem(currentEntity.get«p.property.nameInJava.toFirstUpper»())'''
				}
		}

	}

	/* get Input Field type */
	def inputFieldType(Field p) {
		switch (p.property){
			Attribute:
				'JTextField'
			Reference:
				if ((p.property as Reference).multiplicity == 0)
					'JComboBox<' + importedType((p.property as Reference).type) + '>'
				else
					'JList<' + importedType((p.property as Reference).type) + '>'
		}
	}

	def fieldName(Property p) {
		p.fieldTypeAbb + '_' + p.nameInJava.toFirstUpper
	}
	
	def fieldTypeAbb(Property p) {
		switch (p) {
			Attribute:
				'tf'
			Reference:
				if ((p as Reference).multiplicity == 0)
					'cb'
				else
					'li'
		}
	}

	def labelName(Property p) {
		'lbl' + p.nameInJava.toFirstUpper
	}

	/* get code for formatted text representation of property value */
	def getFormattedTextCode(Attribute a) {
		val getValue = '''currentEntity.get«a.nameInJava.toFirstUpper»()'''
		var result = getValue
		if (a.isDate)
			result = '''Util.DATE_TIME_FORMATTER.format(«result»)'''
		else if (a.numberObject)
			result = '''«getValue».toString()'''
		else if (!a.string)
			result = '''String.valueOf(«result»)'''
		if (a.isObject)
			result = '''«getValue» != null ? «result» : ""'''
		result
	}
	
	/* generates code to retrieve value from imput field */
	def retrieveValueFromFieldCode(Property p) {
		if(p.fieldTypeAbb.equals("cb"))
			 return '''«p.fieldName».getItemAt(«p.fieldName».getSelectedIndex())'''

		val getText = '''«p.fieldName».getText()'''
		var result = getText
		if (p instanceof Attribute){
		if ((p as Attribute).isDate)
			result = '''Util.DATE_TIME_FORMATTER.parse(«result»)'''
		else if (!(p as Attribute).string)
			result = '''«(p as Attribute).typeInJava.objectType».valueOf(«result»)'''}

		'''«getText».isEmpty() ? null : «result»'''
	}
	
	def listInitializeMethodName(Property p) {
		'''initialize«p.fieldTypeAbb.toFirstUpper»«p.nameInJava.toFirstUpper»'''
	}
}
