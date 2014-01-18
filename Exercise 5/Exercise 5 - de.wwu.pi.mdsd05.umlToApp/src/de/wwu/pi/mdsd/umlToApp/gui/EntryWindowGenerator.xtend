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
import de.wwu.pi.mdsd.crudDsl.crudDsl.Window

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
							«elem.name».setBounds(«elem.bounds.x», «elem.bounds.y», «elem.bounds.width», «elem.bounds.height»«IF elem.isSpaceForButtons»-25«ENDIF»);
							getPanel().add(«elem.name»);
							«IF elem.numberOfButtonsThereIsSpaceFor>0»
								//Button for List Element								
							«ENDIF»
							«elem.createAddButtonForField(window)»
							«elem.createEditButtonForField(window)»
							«elem.createDeleteButtonForField(window)»
				«ENDFOR»
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
	
	def createAddButtonForField(Field field,Window window){
		if (field.numberOfButtonsThereIsSpaceFor>0){
			'''JButton «field.addButtonName» = new JButton("Add");
							«field.addButtonName».setEnabled(!currentEntity.isNew());
							«field.addButtonName».setBounds(«field.bounds.x»,«field.bounds.y+field.bounds.height-20»,«(field.bounds.width-(field.numberOfButtonsThereIsSpaceFor-1)*5)/field.numberOfButtonsThereIsSpaceFor»,20);
							getPanel().add(«field.addButtonName»);
							«field.addButtonName».addActionListener(new ActionListener() {
								@Override
								public void actionPerformed(ActionEvent e) {
									«IF (field.property as Reference).type.hasSubClasses»
										«(field.property as Reference).type.name» entity = null;
										«FOR subClass : (field.property as Reference).type.instantiableClasses»
											if(«subClass.entryWindowClassName».this.«(field.property as Reference).inheritanceTypeSelectName».getSelectedItem().equals("«importedType(subClass)»"))
												entity = new «subClass.name»().«(field.property as Reference).opposite.initializeSingleRefMethodName»(currentEntity);
										«ENDFOR»
										«(field.property as Reference).type.inheritanceCallOpenEntryWindow((field.property as Reference).type.entryWindowClassName+".this")»
									«ELSE»
									new «(field.property as Reference).type.entryWindowClassName»(«window.name».this, new «(field.property as Reference).type.name»().«(field.property as Reference).opposite.initializeSingleRefMethodName»(currentEntity)).open();
									«ENDIF»
								}
							});'''
		}
	}
	def createEditButtonForField(Field field,Window window){
		if (field.numberOfButtonsThereIsSpaceFor>1){
			'''JButton «field.editButtonName» = new JButton("Edit");
							«field.editButtonName».setBounds(«field.bounds.x+((field.bounds.width-(field.numberOfButtonsThereIsSpaceFor-1)*5)/field.numberOfButtonsThereIsSpaceFor)+5»,«field.bounds.y+field.bounds.height-20»,«(field.bounds.width-(field.numberOfButtonsThereIsSpaceFor-1)*5)/field.numberOfButtonsThereIsSpaceFor»,20);
							«field.editButtonName».setEnabled(!currentEntity.isNew());
							getPanel().add(«field.editButtonName»);
							«field.editButtonName».addActionListener(new ActionListener() {
								@Override
								public void actionPerformed(ActionEvent e) {
									«(field.property as Reference).type.name» entity = «window.name».this.«field.fieldName».getSelectedValue();
									if(entity == null)
										Util.showNothingSelected();
									else
										«IF (field.property as Reference).type.hasSubClasses»
											«(field.property as Reference).type.inheritanceCallOpenEntryWindow((field.property as Reference).type.entryWindowClassName+".this")»
										«ELSE»
											new «(field.property as Reference).type.entryWindowClassName»(«window.name».this, entity).open();
										«ENDIF»
								}
							});'''
		}
	}
	def createDeleteButtonForField(Field field,Window window){
		if (field.numberOfButtonsThereIsSpaceFor>2){
			'''							JButton «field.deleteButtonName» = new JButton("Delete");
							«field.deleteButtonName».setEnabled(false);
							«field.deleteButtonName».setBounds(«field.bounds.x+2*((field.bounds.width-(field.numberOfButtonsThereIsSpaceFor-1)*5)/field.numberOfButtonsThereIsSpaceFor)+(field.numberOfButtonsThereIsSpaceFor-1)*5»,«field.bounds.y+field.bounds.height-20»,«(field.bounds.width-(field.numberOfButtonsThereIsSpaceFor-1)*5)/field.numberOfButtonsThereIsSpaceFor»,20);
							getPanel().add(«field.deleteButtonName»);'''
		}
	}
}
