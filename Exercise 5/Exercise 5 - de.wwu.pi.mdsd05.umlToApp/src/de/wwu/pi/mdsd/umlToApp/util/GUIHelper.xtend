package de.wwu.pi.mdsd.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.NamedElement
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity

class GUIHelper { 
	// from http://stackoverflow.com/a/2560017
	static val REGEX_SPLIT_CAMEL_CASE = 
		"(?<=[A-Z])(?=[A-Z][a-z])" + '|' + //UC behind me, UC followed by LC in front of me (e.g. PDFReader > PDF Reader)
		"(?<=[^A-Z])(?=[A-Z])" + '|' + //non-UC behind me, UC in front of me (e.g. MyClass > My Class; 99Bottles > 99 Bottles)
		"(?<=[A-Za-z])(?=[^A-Za-z])" //Letter behind me, non-letter in front of me  (e.g. May15 > May 15
	def static camelCaseToLabel(String camelCaseString) {
		camelCaseString.replaceAll(REGEX_SPLIT_CAMEL_CASE, " ")
	}

	def static readableLabel(NamedElement named) {
		named.name.camelCaseToLabel.toFirstUpper
	}
	
	def static private Class getClazz(NamedElement elem) {
		switch elem {
			Class : elem
			Property : elem.opposite.class_
		}
	}
	
	def static inheritanceTypeSelectName(NamedElement att)
		'''cb_select_inh_type_� att.name�'''
	
	def static inheritanceTypeSelectName(Entity entity)
		'''cb_select_inh_type_� entity.name�'''
		
	def static inheritanceCallOpenEntryWindow(Class clazz, String refToWindowClass) '''
		�FOR subClass : clazz.instantiableClasses�
			if(entity instanceof �javaType(subClass)�)
				new �subClass.entryWindowClassName�(�refToWindowClass�, (�subClass.name�) entity).open();
		�ENDFOR�
	'''
	
	def static inheritanceCallOpenEntryWindow(Entity entity, String refToWindowClass) '''
		�FOR subClass : entity.instantiableClasses�
			if(entity instanceof �javaType(subClass)�)
				new �subClass.entryWindowClassName�(�refToWindowClass�, (�subClass.name�) entity).open();
		�ENDFOR�
	'''
	
	def static createSelectForInheritanceClasses(NamedElement elem, String x,String y) {
		val clazz = elem.getClazz
		'''
		�FOR subclass : clazz.instantiableClasses�
			�elem.inheritanceTypeSelectName�.addItem("�subclass.name�");
		�ENDFOR�
		java.awt.GridBagConstraints gbc_�elem.inheritanceTypeSelectName� = new java.awt.GridBagConstraints();
		gbc_�elem.inheritanceTypeSelectName�.insets = new java.awt.Insets(0, 0, 5, 5);
		gbc_�elem.inheritanceTypeSelectName�.gridx = �x�;
		gbc_�elem.inheritanceTypeSelectName�.gridy = �y�;
		getPanel().add(�elem.inheritanceTypeSelectName�, gbc_�elem.inheritanceTypeSelectName�);
		'''
	}
}
