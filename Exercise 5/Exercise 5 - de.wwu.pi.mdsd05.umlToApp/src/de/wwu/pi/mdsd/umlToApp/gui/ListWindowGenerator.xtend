package de.wwu.pi.mdsd.umlToApp.gui

import de.wwu.pi.mdsd.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.ListWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity

class ListWindowGenerator extends GeneratorWithImports<ListWindow>{
	override doGenerate(ListWindow window) '''
	package «window.name»;
	
	import java.util.Vector;
	
	import de.wwu.pi.mdsd.framework.gui.AbstractListWindow;
	import de.wwu.pi.mdsd.framework.gui.AbstractWindow;
	//import de.wwu.pi.mdsd.framework.logic.*;
	import «(window.eContainer as CrudModel).logicPackageString».ServiceInitializer;
	«IMPORTS_MARKER»
		
	public class «window.name» extends AbstractListWindow<«window.entity.importedType»> implements «window.entity.listingInterfaceClassName»{
	
		public «window.name»(AbstractWindow parent) {
			super(parent);
		}
		« /* readable List Window Title */»
		public String getTitle() {
			return "List «window.name.camelCaseToLabel» Objects";
		}
		
		@Override
		public Vector<«window.entity.name»> getElements() {
			return new Vector<«window.entity.name»>(ServiceInitializer.getProvider().get«window.entity.serviceClassName»().getAll());
		}
		
		@Override
		public void «window.entity.listingInterfaceMethodeName»() {
			initializeList();
		}
		
		@Override
		public void showEntryWindow(«window.entity.name» entity) {
			//If entity is null -> initialize entity as new entity
			//show Entity Edit Window
			if(entity == null) {
				«window.entity.initializeEntity»
			}
			«window.entity.callOpenEntryWindow»
		}
		« /* create select for inheritance types */
		 IF window.entity.hasSubClasses »
		
			javax.swing.JComboBox<String> «window.entity.inheritanceTypeSelectName» = new javax.swing.JComboBox<>();
			@Override //overrides superclass method to add a select box to the window
			public void createContents() {
				super.createContents();
				«clazz.createSelectForInheritanceClasses("1","2")»
			}
		«ENDIF»
	}
	
	//Interface that needs to be implemented, if the class references «window.entity.name» objects in a list
	interface «window.entity.listingInterfaceClassName» {
		public void «window.entity.listingInterfaceMethodeName»();
	}'''
	
	def initializeEntity(Entity entity) '''
		«IF (entity.hasSubClasses) /* special case: initialize entity according to the selected type */ »
			«FOR subClass : entity.instantiableClasses»
				if(«entity.inheritanceTypeSelectName».getSelectedItem().equals("«importedType(subClass)»"))
					entity = new «subClass.name»();
			«ENDFOR»
		«ELSE/* usual case */»
			entity = new «entity.name»();
		«ENDIF»
	'''
	
	def callOpenEntryWindow(Entity entity) '''
		«IF (entity.hasSubClasses) /* special case: open Window depending on selected type */ »
			«entity.inheritanceCallOpenEntryWindow("this")»
		«ELSE/* usual case */»
			new «entity.entryWindowClassName»(this,entity).open();
		«ENDIF»
	'''
	
}
