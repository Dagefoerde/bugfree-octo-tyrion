package de.wwu.pi.mdsd.umlToApp.gui

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class ListWindowGenerator {
	def generateListWindow(Class clazz) '''
package somePackageString.gui;

import java.util.Vector;

import de.wwu.pi.mdsd.framework.gui.AbstractListWindow;
import de.wwu.pi.mdsd.framework.gui.AbstractWindow;
import somePackageString.logic.ServiceInitializer;
import somePackageString.data.«clazz.name»;
	
public class «clazz.name.toFirstUpper»ListWindow extends AbstractListWindow<«clazz.name»> implements «clazz.name.toFirstUpper»ListingInterface{

	public «clazz.name.toFirstUpper»ListWindow(AbstractWindow parent) {
		super(parent);
	}

	@Override
	public void showEntryWindow(«clazz.name» entity) {
		//If entity is null -> initialize entity as new entity
		//show Entity Edit Window
		if(entity == null)
			entity = new «clazz.name»();
		new «clazz.name.toFirstUpper»EntryWindow(this,entity).open();
	}

	@Override
	public Vector<«clazz.name»> getElements() {
		return new Vector<«clazz.name»>(ServiceInitializer.getProvider().get«clazz.name.toFirstUpper»Service().getAll());
	}
	
	@Override
	public void initialize«clazz.name.toFirstUpper»Listings() {
		initializeList();
	}
}

interface «clazz.name.toFirstUpper»ListingInterface {
	public void initialize«clazz.name.toFirstUpper»Listings();
}
	'''
}


	

