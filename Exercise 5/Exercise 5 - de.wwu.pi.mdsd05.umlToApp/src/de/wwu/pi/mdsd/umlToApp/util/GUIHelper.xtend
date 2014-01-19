package de.wwu.pi.mdsd.umlToApp.util

import de.wwu.pi.mdsd.crudDsl.crudDsl.Button
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.Field
import de.wwu.pi.mdsd.crudDsl.crudDsl.Label
import de.wwu.pi.mdsd.crudDsl.crudDsl.ListWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.Reference

import static extension de.wwu.pi.mdsd.umlToApp.util.EntityHelper.*

class GUIHelper { 
	// from http://stackoverflow.com/a/2560017
	static val REGEX_SPLIT_CAMEL_CASE = 
		"(?<=[A-Z])(?=[A-Z][a-z])" + '|' + //UC behind me, UC followed by LC in front of me (e.g. PDFReader > PDF Reader)
		"(?<=[^A-Z])(?=[A-Z])" + '|' + //non-UC behind me, UC in front of me (e.g. MyClass > My Class; 99Bottles > 99 Bottles)
		"(?<=[A-Za-z])(?=[^A-Za-z])" //Letter behind me, non-letter in front of me  (e.g. May15 > May 15
	def static camelCaseToLabel(String camelCaseString) {
		camelCaseString.replaceAll(REGEX_SPLIT_CAMEL_CASE, " ")
	}
	
	def static readableLabel(Label label) {
		if (label.text == null)
			label.name.camelCaseToLabel.toFirstUpper
		else
			label.text
	}

	def static windowTitle(ListWindow window) {
		if (window.title == null)
			'''«window.name.camelCaseToLabel.toFirstUpper»'''
		else
			window.title
	}
	
	def static readableButtonLabel(Button button) {
		if (button.text == null)
			'''«button.name.camelCaseToLabel.toFirstUpper»'''
		else
			button.text
	}

	def static windowTitle(EntryWindow window) {
		if (window.title == null)
			'''«window.name.camelCaseToLabel.toFirstUpper»'''
		else
			window.title
	}
	
	def static getAddButtonName(Field field)
		'''btn_«field.name»_Add'''
		
	def static getEditButtonName(Field field)
		'''btn_«field.name»_Edit'''
		
	def static getDeleteButtonName(Field field)
		'''btn_«field.name»_Delete'''
	
	def static inheritanceTypeSelectName(Reference ref)
		'''cb_select_inh_type_« ref.name»'''
		
	def static inheritanceTypeSelectName(Entity entity)
		'''cb_select_inh_type_« entity.name»'''
	
	def static inheritanceCallOpenEntryWindow(Entity entity, String refToWindowClass) '''
		«FOR subClass : entity.instantiableClasses»
			if(entity instanceof «javaType(subClass)»)
				new «subClass.entryWindowClassName»(«refToWindowClass», («subClass.name») entity).open();
		«ENDFOR»
	'''

	def static createSelectForInheritanceClasses(Entity entity, String x,String y) {
		'''
		«FOR subclass : entity.instantiableClasses»
			«entity.inheritanceTypeSelectName».addItem("«subclass.name»");
		«ENDFOR»
		java.awt.GridBagConstraints gbc_«entity.inheritanceTypeSelectName» = new java.awt.GridBagConstraints();
		gbc_«entity.inheritanceTypeSelectName».insets = new java.awt.Insets(0, 0, 5, 5);
		gbc_«entity.inheritanceTypeSelectName».gridx = «x»;
		gbc_«entity.inheritanceTypeSelectName».gridy = «y»;
		getPanel().add(«entity.inheritanceTypeSelectName», gbc_«entity.inheritanceTypeSelectName»);
		'''
	}
	
	def static isSpaceForButtons(Field field){
		(field.bounds.height>50 && field.bounds.width>50)
	}
	def static Integer numberOfButtonsThereIsSpaceFor(Field field){
		if (!field.isSpaceForButtons) return 0
		if (field.bounds.width<50) return 0
		if (field.bounds.width<105) return 1
		if (field.bounds.width<160) return 2
		else
		return 3			
	}
}
