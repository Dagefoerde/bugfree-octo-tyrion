package de.wwu.pi.mdsd.umlToApp.gui

import de.wwu.pi.mdsd.crudDsl.crudDsl.Attribute
import de.wwu.pi.mdsd.crudDsl.crudDsl.Button
import de.wwu.pi.mdsd.crudDsl.crudDsl.ButtonKind
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.Field
import de.wwu.pi.mdsd.crudDsl.crudDsl.Label
import de.wwu.pi.mdsd.crudDsl.crudDsl.Reference
import de.wwu.pi.mdsd.umlToApp.util.GeneratorWithImports

import static extension de.wwu.pi.mdsd.umlToApp.util.EntityHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntryWindowGenerator extends GeneratorWithImports<EntryWindow> {
	
	override doGenerate(EntryWindow window) '''
		package «window.guiPackageString»;
		
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
				private «elem.inputFieldType» «elem.name»;
			«ENDFOR»
					
			public «window.name»(AbstractWindow parent, «window.entity.javaType» currentEntity) {
				super(parent, currentEntity, «window.size.width», «window.size.height»);
				service = «imported(window.logicPackageString + ".ServiceInitializer")».getProvider().get«window.entity.serviceClassName»();
			}
		
			@Override
			
			protected void createUIElements() {
				«FOR elem : window.elements»
					
					«IF(elem instanceof Label)»
					
					JLabel «elem.name» = new JLabel("«(elem as Label).labelName»");
					«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
					getPanel().add(«elem.name»);
					
					
					«ELSEIF(elem instanceof Field)»
						«IF ((elem as Field).property instanceof Attribute)»
							«elem.name» = «((elem as Field).initializeField)»;
							«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
							getPanel().add(«elem.name»);
							«elem.name».setColumns(10);
						«ELSEIF ((elem as Field).property instanceof Reference)»
							«IF (elem as Field).hasSingleValuedProperty»
							«elem.name» = «((elem as Field).initializeField)»;
							«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
							getPanel().add(«elem.name»);
							«ELSEIF (elem as Field).hasMultiValuedProperty»
							«ENDIF»
						«ENDIF»					
					«ELSEIF(elem instanceof Button)»
					«IF (elem as Button).kind==ButtonKind.CREATE_EDIT»		
					JButton «elem.name» = new JButton("«(elem as Button).readableButtonLabel»");
					«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»);
					getPanel().add(«elem.name»);
					«elem.name».addActionListener(new ActionListener() {
					
					@Override
					public void actionPerformed(ActionEvent e) {
							try {
								saveAction();
							} catch (Exception e1) {
								JOptionPane.showMessageDialog(getPanel(), "Could not be saved. " + e1.getMessage());
							}				
					}
					});
					«ENDIF»
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
				«FOR elem : window.elements.filter(Field).filter[it.hasSingleValuedProperty]»
					« /* declare and initialize local variables to handle imports */
					switch (elem.property){
						Attribute:(elem.property as Attribute).type.literal.objectType
						Reference: (elem.property as Reference).type.name.objectType
					}»
					  «elem.property.name» = «elem.retrieveValueFromFieldCode»;
				«ENDFOR»
				
				«val attributeNames = window.entity.singleValueProperties(true).join(", ",[name])»
				//validation
				try {
					service.validate«window.entity.name»(«attributeNames»);
					«window.name».this.closeWindow();
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
				«FOR elem : window.elements.filter(Field).filter[field|field.property instanceof Reference && (field.property as Reference).isMultivalued]»
					
							«elem.name» = «(elem.initializeField)»;
							«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»-25);
							getPanel().add(«elem.name»);
							//Button for List Element
							JButton «elem.addButtonName» = new JButton("Add");
							«elem.addButtonName».setEnabled(!currentEntity.isNew());
							«elem.addButtonName».setBounds(«elem.bounds.x»,«elem.bounds.y+elem.bounds.height-20»,«(elem.bounds.width-10)/3»,20);
							getPanel().add(«elem.addButtonName»);
							«elem.addButtonName».addActionListener(new ActionListener() {
								@Override
								public void actionPerformed(ActionEvent e) {
									«IF (elem.property as Reference).type.hasSubClasses»
										«(elem.property as Reference).type.name» entity = null;
										«FOR subClass : (elem.property as Reference).type.instantiableClasses»
											if(«subClass.entryWindowClassName».this.«(elem.property as Reference).inheritanceTypeSelectName».getSelectedItem().equals("«importedType(subClass)»"))
												entity = new «subClass.name»().«(elem.property as Reference).initializeSingleRefMethodName»(currentEntity);
										«ENDFOR»
										«(elem.property as Reference).type.inheritanceCallOpenEntryWindow((elem.property as Reference).type.entryWindowClassName+".this")»
									«ELSE»
									new «(elem.property as Reference).type.entryWindowClassName»(«window.name».this, new «(elem.property as Reference).type.name»()).open();//.«(elem.property as Reference).initializeSingleRefMethodName»(currentEntity)).open();
									«ENDIF»
								}
							});
							
							JButton «elem.editButtonName» = new JButton("Edit");
							«elem.editButtonName».setBounds(«elem.bounds.x+(elem.bounds.width-10)/3+5»,«elem.bounds.y+elem.bounds.height-20»,«(elem.bounds.width-10)/3»,20);
							«elem.editButtonName».setEnabled(!currentEntity.isNew());
							getPanel().add(«elem.editButtonName»);
							«elem.editButtonName».addActionListener(new ActionListener() {
								@Override
								public void actionPerformed(ActionEvent e) {
									«(elem.property as Reference).type.name» entity = «window.name».this.«elem.fieldName».getSelectedValue();
									if(entity == null)
										Util.showNothingSelected();
									else
										«IF (elem.property as Reference).type.hasSubClasses»
											«(elem.property as Reference).type.inheritanceCallOpenEntryWindow((elem.property as Reference).type.entryWindowClassName+".this")»
										«ELSE»
											new «(elem.property as Reference).type.entryWindowClassName»(«window.name».this, entity).open();
										«ENDIF»
								}
							});
							
							JButton «elem.deleteButtonName» = new JButton("Delete");
							«elem.deleteButtonName».setEnabled(false);
							«elem.deleteButtonName».setBounds(«elem.bounds.x+2*((elem.bounds.width-10)/3)+10»,«elem.bounds.y+elem.bounds.height-20»,«(elem.bounds.width-10)/3»,20);
							getPanel().add(«elem.deleteButtonName»);
							
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
			FOR elem : window.elements.filter(Field).filter[it.hasMultiValuedProperty]»
				
				public void «elem.listInitializeMethodName»() {
					«elem.fieldName».setListData(new Vector<«(elem.property as Reference).type.name»>(currentEntity.get«elem.property.nameInJava.toFirstUpper»()));
				}
			«ENDFOR»
			« /* Create listing methods required due to listing interfaces */
			 FOR type : window.entity.listingTypes»
				
				@Override
				public void «type.listingInterfaceMethodeName»() {
					«FOR elem : window.elements.filter(Field).filter[it.hasMultiValuedProperty].filter[(it.property as Reference).type.equals(type)]»
						«elem.listInitializeMethodName»();
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
	def initializeField(Field f) {
		switch (f.property) {
			Attribute: '''new «f.inputFieldType»(«(f.property as Attribute).formattedTextCode»)'''
			Reference:
				if (f.hasMultiValuedProperty) {
					'''
					new «f.inputFieldType»();
					«f.listInitializeMethodName»()'''
				} else {
					'''
					new «f.inputFieldType»(new Vector<>(ServiceInitializer.getProvider().get«(f.property as Reference).type.serviceClassName»().getAll()));
					«f.fieldName».setSelectedItem(currentEntity.get«f.property.nameInJava.toFirstUpper»())'''
				}
		}

	}

	/* get Input Field type */
	def inputFieldType(Field f) {
		switch (f.property){
			Attribute:
				'JTextField'
			Reference:
				if (f.hasSingleValuedProperty)
					'JComboBox<' + importedType((f.property as Reference).type) + '>'
				else
					'JList<' + importedType((f.property as Reference).type) + '>'
		}
	}

	def fieldName(Field f) {
		f.name
	}

	def labelName(Label l) {
		if (l.text!=null)
		return l.text
		return l.readableLabel
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
	def retrieveValueFromFieldCode(Field f) {
		if(f.hasSingleValuedReference)
			 return '''«f.fieldName».getItemAt(«f.fieldName».getSelectedIndex())'''

		val getText = '''«f.fieldName».getText()'''
		var result = getText
		if (f.property instanceof Attribute){
		if ((f.property as Attribute).isDate)
			result = '''Util.DATE_TIME_FORMATTER.parse(«result»)'''
		else if (!(f.property as Attribute).string)
			result = '''«(f.property as Attribute).typeInJava.objectType».valueOf(«result»)'''}

		'''«getText».isEmpty() ? null : «result»'''
	}
	
	def listInitializeMethodName(Field f) {
		'''initialize«f.name.toFirstUpper»'''
	}
}
