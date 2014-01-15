package de.wwu.pi.mdsd.umlToApp.gui

import de.wwu.pi.mdsd.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.DataType
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.Type

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.Label
import de.wwu.pi.mdsd.crudDsl.crudDsl.Field
import de.wwu.pi.mdsd.crudDsl.crudDsl.Button
import de.wwu.pi.mdsd.crudDsl.crudDsl.Attribute
import de.wwu.pi.mdsd.crudDsl.crudDsl.Reference

class EntryWindowGenerator extends GeneratorWithImports<EntryWindow> {
	
	override doGenerate(EntryWindow window) '''
		package �window.name�;
		
		import java.awt.GridBagConstraints;
		import java.awt.Insets;
		import java.awt.event.ActionEvent;
		import java.awt.event.ActionListener;
		import java.text.ParseException;
		import java.util.*;
		
		import javax.swing.*;
		
		import de.wwu.pi.mdsd.framework.gui.*;
		import de.wwu.pi.mdsd.framework.logic.ValidationException;
		�IMPORTS_MARKER�
		
		public class �window.name� extends AbstractEntryWindow<�importedType(clazz)�> �clazz.listingTypes.join("implements ",", "," ", [listingInterfaceClassName])�{
			�	/* Declare Service class (+ adds full qualified name to import list) */
				imported(window.logicPackageString + "."+clazz.serviceClassName)� service;

			�	/* declare fields for each attribute */
			 FOR elem : window.elements.filter(typeof(Field))�
				private �elem.inputFieldType� �elem.fieldName�;
			�ENDFOR�
					
			public �clazz.entryWindowClassName�(AbstractWindow parent, �clazz.name� currentEntity) {
				super(parent, currentEntity, �window.size.width�, �window.size.height�);
				service = �imported(clazz.logicPackageString + ".ServiceInitializer")�.getProvider().get�clazz.serviceClassName�();
			}
		
			@Override
			
			protected void createUIElements() {
				int gridy = 0;
				�FOR elem : window.elements�
					
					�IF(elem instanceof Label)�
					
					JLabel lbl�elem.name� = new JLabel("�elem.name�");
					lbl�elem.name�.setBounds(�elem.bounds.x�, �elem.bounds.y�, �elem.bounds.width�, �elem.bounds.height�);
					contentPane.add(lbl�elem.name�);
		
		
					�ELSEIF(elem instanceof Field)�
						�IF ((elem as Field).property instanceof Attribute)�
							�elem.fieldname� = �elem.initializeField�;
							fld�elem.name�.setBounds(�elem.bounds.x�, �elem.bounds.y�, �elem.bounds.width�, �elem.bounds.height�);
							contentPane.add(fld�elem.name�);
							fld�elem.name�.setColumns(10);
						�ELSEIF ((elem as Field).property instanceof Reference)�
							�IF (((elem as Field).property as Reference).multiplicity == 0)�
							JComboBox cb�elem.name� = new JComboBox();
							cb�elem.name�.setBounds(�elem.bounds.x�, �elem.bounds.y�, �elem.bounds.width�, �elem.bounds.height�);
							contentPane.add(cb�elem.name�);
							�ELSEIF (((elem as Field).property as Reference).multiplicity == 1)�
							�ENDIF�
						�ENDIF�					
					�ELSEIF(elem instanceof Button)�
							
					JButton btn�elem.name� = new JButton("�elem.name�");
					btn�elem.name�.setBounds(�elem.bounds.x�, �elem.bounds.y�, �elem.bounds.width�, �elem.bounds.height�);
					contentPane.add(btn�elem.name�);
					
					�ENDIF�
				�ENDFOR�
			}
			
			
			
			
			@Override
			protected boolean saveAction() throws ParseException {
				//Read values from different fields 
				�FOR prop : clazz.singleValueProperties(true)�
					� /* declare and initialize local variables to handle imports */
					 prop.type.name.objectType� �prop.name� = �prop.retrieveValueFromFieldCode�;
				�ENDFOR�
				
				�val attributeNames = clazz.singleValueProperties(true).join(", ",[name])�
				//validation
				try {
					service.validate�clazz.name�(�attributeNames�);
				} catch (ValidationException e) {
					Util.showUserMessage("Validation error for " + e.getField(), "Validation error for " + e.getField() + ": " + e.getMessage());
					return false;
				}
				
				//persist
				currentEntity = service.save�clazz.name�(currentEntity.getOid()�if(!attributeNames.empty) ', ' + attributeNames�);
				
				//reload the listing in the parent window to make changes visible
				�FOR currClass : (clazz.allSuperClasses + #{clazz}) �	
					if(getParent() instanceof �currClass.listingInterfaceClassName�)
						((�currClass.listingInterfaceClassName�) getParent()).�currClass.listingInterfaceMethodeName�();
				�ENDFOR�
				return true;
			}
			
			�FOR att : clazz.multiReferences(true).filter[attribute | attribute.hasSubClasses ]�
				javax.swing.JComboBox<String> �att.inheritanceTypeSelectName� = new javax.swing.JComboBox<>();
			�ENDFOR�
			@Override
			protected void createLists() {
				int gridy = 0;
				JButton btn;
				GridBagConstraints gbc_btn;
				�FOR att : clazz.multiReferences(true)�				
					gridy = getNextGridYValue();
					JLabel �att.labelName� = new JLabel("�att.readableLabel + (if(att.required) '*' else '')�");
					GridBagConstraints gbc_�att.labelName� = new GridBagConstraints();
					gbc_�att.labelName�.insets = new Insets(0, 0, 5, 5);
					gbc_�att.labelName�.anchor = GridBagConstraints.NORTHEAST;
					gbc_�att.labelName�.gridx = 0;
					gbc_�att.labelName�.gridy = gridy;
					getPanel().add(�att.labelName�, gbc_�att.labelName�);
					
					�att.fieldName� = �att.initializeField�;
					GridBagConstraints gbc_�att.fieldName� = new GridBagConstraints();
					gbc_�att.fieldName�.gridwidth = 5;
					gbc_�att.fieldName�.insets = new Insets(0, 0, 5, 5);
					gbc_�att.fieldName�.fill = GridBagConstraints.BOTH;
					gbc_�att.fieldName�.gridx = 1;
					gbc_�att.fieldName�.weighty = .5;
					gbc_�att.fieldName�.gridy = gridy;
					getPanel().add(�att.fieldName�, gbc_�att.fieldName�);
					
					gridy = getNextGridYValue();
					� /* Special handling of attributes with inheritance */
					 IF att.hasSubClasses �
					
						�att.createSelectForInheritanceClasses("2","gridy")�
					�ENDIF�
					
					//Button for List Element
					btn = new JButton("Add");
					btn.setEnabled(!currentEntity.isNew());
					gbc_btn = new GridBagConstraints();
					gbc_btn.insets = new Insets(0, 0, 5, 0);
					gbc_btn.gridx = 3;
					gbc_btn.gridy = gridy;
					getPanel().add(btn, gbc_btn);
					btn.addActionListener(new ActionListener() {
						@Override
						public void actionPerformed(ActionEvent e) {
							�IF att.hasSubClasses�
								�att.type.name� entity = null;
								�FOR subClass : att.opposite.class_.instantiableClasses�
									if(�clazz.entryWindowClassName�.this.�att.inheritanceTypeSelectName�.getSelectedItem().equals("�importedType(subClass)�"))
										entity = new �subClass.name�().�att.opposite.initializeSingleRefMethodName�(currentEntity);
								�ENDFOR�
								�att.opposite.class_.inheritanceCallOpenEntryWindow(att.class_.entryWindowClassName+".this")�
							�ELSE�
								new �att.opposite.class_.entryWindowClassName�(�clazz.entryWindowClassName�.this, new �att.type.name�().�att.opposite.initializeSingleRefMethodName�(currentEntity)).open();
							�ENDIF�
						}
					});
					
					btn = new JButton("Edit");
					gbc_btn.gridx = 4;
					btn.setEnabled(!currentEntity.isNew());
					getPanel().add(btn, gbc_btn);
					btn.addActionListener(new ActionListener() {
						@Override
						public void actionPerformed(ActionEvent e) {
							�att.type.name� entity = �clazz.entryWindowClassName�.this.�att.fieldName�.getSelectedValue();
							if(entity == null)
								Util.showNothingSelected();
							else
								�IF att.hasSubClasses�
									�att.opposite.class_.inheritanceCallOpenEntryWindow(att.class_.entryWindowClassName+".this")�
								�ELSE�
									new �att.opposite.class_.entryWindowClassName�(�clazz.entryWindowClassName�.this, entity).open();
								�ENDIF�
						}
					});
					
					btn = new JButton("Delete");
					btn.setEnabled(false);
					gbc_btn.gridx = 5;
					getPanel().add(btn, gbc_btn);
				�ENDFOR�
			}
			� /* Create list initializer methods; one for each list */
			FOR att : clazz.multiReferences(true)�
				
				public void �att.listInitializeMethodName�() {
					�att.fieldName�.setListData(new Vector<�att.type.name�>(currentEntity.get�att.nameInJava.toFirstUpper�()));
				}
			�ENDFOR�
			� /* Create listing methods required due to listing interfaces */
			 FOR type : clazz.listingTypes�
				
				@Override
				public void �type.listingInterfaceMethodeName�() {
					�FOR att : clazz.multiReferences(true).filter[it.type.equals(type)]�
						�att.listInitializeMethodName�();
					�ENDFOR�
				}
			�ENDFOR�
		}
	'''
	
	/* Get types for all classes that are multi-referenced and thus a listing is presented within this window */
	def listingTypes(Class clazz) {
		clazz.multiReferences(true).map[type].toSet
	}
	
	//Initializes input fields and if necessary selects 
	def initializeField(Property p) {
		switch (p.type) {
			DataType: '''new �p.inputFieldType�(�p.formattedTextCode�)'''
			default:
				if (p.multivalued) {
					'''
					new �p.inputFieldType�();
					�p.listInitializeMethodName�()'''
				} else {
					'''
					new �p.inputFieldType�(new Vector<>(ServiceInitializer.getProvider().get�p.type.serviceClassName�().getAll()));
					�p.fieldName�.setSelectedItem(currentEntity.get�p.nameInJava.toFirstUpper�())'''
				}
		}

	}

	/* get Input Field type */
	def inputFieldType(Property p) {
		switch (p.type) {
			DataType:
				'JTextField'
			default:
				if (p.multivalued)
					'JList<' + importedType(p.type) + '>'
				else
					'JComboBox<' + importedType(p.type) + '>'
		}
	}

	def fieldName(Property p) {
		p.fieldTypeAbb + '_' + p.nameInJava.toFirstUpper
	}
	
	def fieldTypeAbb(Property p) {
		switch (p.type) {
			DataType:
				'tf'
			default:
				if (p.multivalued)
					'li'
				else
					'cb'
		}
	}

	def labelName(Property p) {
		'lbl' + p.nameInJava.toFirstUpper
	}

	/* get code for formatted text representation of property value */
	def getFormattedTextCode(Property p) {
		val getValue = '''currentEntity.get�p.nameInJava.toFirstUpper�()'''
		var result = getValue
		if (p.isDate)
			result = '''Util.DATE_TIME_FORMATTER.format(�result�)'''
		else if (p.numberObject)
			result = '''�getValue�.toString()'''
		else if (!p.string)
			result = '''String.valueOf(�result�)'''
		if (p.isObject)
			result = '''�getValue� != null ? �result� : ""'''
		result
	}
	
	/* generates code to retrieve value from imput field */
	def retrieveValueFromFieldCode(Property p) {
		if(p.fieldTypeAbb.equals("cb"))
			 return '''�p.fieldName�.getItemAt(�p.fieldName�.getSelectedIndex())'''

		val getText = '''�p.fieldName�.getText()'''
		var result = getText
		if (p.isDate)
			result = '''Util.DATE_TIME_FORMATTER.parse(�result�)'''
		else if (!p.string)
			result = '''�p.typeInJava.objectType�.valueOf(�result�)'''

		'''�getText�.isEmpty() ? null : �result�'''
	}

	def getServiceProviderForType(Type t) {
		'''serviceProvider.get�(t as Class).serviceClassName�()'''
	}
	
	def listInitializeMethodName(Property p) {
		'''initialize�p.fieldTypeAbb.toFirstUpper��p.nameInJava.toFirstUpper�'''
	}
}