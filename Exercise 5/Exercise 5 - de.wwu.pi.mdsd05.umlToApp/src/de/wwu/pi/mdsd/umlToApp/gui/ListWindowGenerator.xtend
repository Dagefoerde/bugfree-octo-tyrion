package de.wwu.pi.mdsd.umlToApp.gui

import de.wwu.pi.mdsd.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.ListWindow

class ListWindowGenerator extends GeneratorWithImports<ListWindow>{
	override doGenerate(ListWindow window) '''
	package «window..guiPackageString»;
	
	import java.util.Vector;
	
	import de.wwu.pi.mdsd.framework.gui.AbstractListWindow;
	import de.wwu.pi.mdsd.framework.gui.AbstractWindow;
	//import de.wwu.pi.mdsd.framework.logic.*;
	import «clazz.logicPackageString».ServiceInitializer;
	«IMPORTS_MARKER»
		
	public class «clazz.listWindowClassName» extends AbstractListWindow<«clazz.importedType»> implements «clazz.listingInterfaceClassName»{
	
		public «clazz.listWindowClassName»(AbstractWindow parent) {
			super(parent);
		}
		« /* readable List Window Title */»
		public String getTitle() {
			return "List «clazz.readableLabel» Objects";
		}
		
		@Override
		public Vector<«clazz.name»> getElements() {
			return new Vector<«clazz.name»>(ServiceInitializer.getProvider().get«clazz.serviceClassName»().getAll());
		}
		
		@Override
		public void «clazz.listingInterfaceMethodeName»() {
			initializeList();
		}
		
		@Override
		public void showEntryWindow(«clazz.name» entity) {
			//If entity is null -> initialize entity as new entity
			//show Entity Edit Window
			if(entity == null) {
				«clazz.initializeEntity»
			}
			«clazz.callOpenEntryWindow»
		}
		« /* create select for inheritance types */
		 IF clazz.hasSubClasses »
		
			javax.swing.JComboBox<String> «clazz.inheritanceTypeSelectName» = new javax.swing.JComboBox<>();
			@Override //overrides superclass method to add a select box to the window
			public void createContents() {
				super.createContents();
				«clazz.createSelectForInheritanceClasses("1","2")»
			}
		«ENDIF»
	}
	
	//Interface that needs to be implemented, if the class references «clazz.name» objects in a list
	interface «clazz.listingInterfaceClassName» {
		public void «clazz.listingInterfaceMethodeName»();
	}'''
	
	def initializeEntity(Class clazz) '''
		«IF (clazz.hasSubClasses) /* special case: initialize entity according to the selected type */ »
			«FOR subClass : clazz.instantiableClasses»
				if(«clazz.inheritanceTypeSelectName».getSelectedItem().equals("«importedType(subClass)»"))
					entity = new «subClass.name»();
			«ENDFOR»
		«ELSE/* usual case */»
			entity = new «clazz.name»();
		«ENDIF»
	'''
	
	def callOpenEntryWindow(Class clazz) '''
		«IF (clazz.hasSubClasses) /* special case: open Window depending on selected type */ »
			«clazz.inheritanceCallOpenEntryWindow("this")»
		«ELSE/* usual case */»
			new «clazz.entryWindowClassName»(this,entity).open();
		«ENDIF»
	'''
	
	override doGenerate(Class clazz) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
