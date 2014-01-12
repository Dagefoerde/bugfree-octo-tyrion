package de.wwu.pi.mdsd.crudDsl.util

import de.wwu.pi.mdsd.crudDsl.crudDsl.Attribute
import de.wwu.pi.mdsd.crudDsl.crudDsl.Bounds
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.Field
import de.wwu.pi.mdsd.crudDsl.crudDsl.Property
import de.wwu.pi.mdsd.crudDsl.crudDsl.Reference
import de.wwu.pi.mdsd.crudDsl.crudDsl.UIElement
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.xbase.lib.Pair

public class ModelUtil { 
	
	def static CrudModel getModelElement(EObject obj) {
		if(obj instanceof CrudModel)
			return obj as CrudModel;
		getModelElement(obj.eContainer)
	}
	
	//==========================================================================================
	// Extensions for Entity Part
	//==========================================================================================
	
	//get all supertypes of the entity
	def static Iterable<Entity> getAllSupertypes(Entity e) {
		getAllSupertypes(e.superType,emptySet)
	}
	def static private Iterable<Entity> getAllSupertypes(Entity e, Iterable<Entity> resultSet) {
		if(e == null || resultSet.exists[ e == it ])
			resultSet
		else 
			getAllSupertypes(e.superType, #{e} + resultSet)
	}
	
	def static Iterable<Property> getProperties(Entity e, boolean withSupertypes) {
		if(withSupertypes && e.superType != ( null ) ) {
			val allentities = (e.getAllSupertypes.toSet + #{e}).toSet
			allentities.map[it.properties].flatten.toSet 
		} else
			e.properties.toSet
	}
	
	def static required(Property p) {
		switch(p) {
			Attribute: !p.optional
			Reference: true
		}
	}
	
	def static optional(Property p) {
		!p.required
	}
	
	def static getEntity(Property prop) {
		prop.eContainer as Entity
	}
	
	
	//==========================================================================================
	// Extensions for UI Part
	//==========================================================================================	
	
	def static allFields(EntryWindow window) {
		window.elements.filter(typeof(Field))
	}
	
	def static Iterable<Entity> findAll(Entity e)
	{ 	
		e.properties.filter(typeof(Entity)) + #[e]
	}
	
	def static uiOverlaps(UIElement first, UIElement second) {
		val boundsFirst = first.getBounds
		val boundsSecond = second.getBounds
		boundsFirst.getVertexes.exists[ boundsSecond.pointWithinBounds(it)] ||
		boundsSecond.getVertexes.exists[ boundsFirst.pointWithinBounds(it)]
	}
	def static pointWithinBounds(Bounds bounds, Pair<Integer,Integer> point) {
		bounds.x <= point.key && point.key <= (bounds.x + bounds.width)  &&
		bounds.y <= point.value && point.value <= (bounds.y + bounds.height)
	}
	
	def static getVertexes(Bounds bounds) {
		val lu = new Pair<Integer,Integer>(bounds.x,bounds.y)
		#[	lu,
			new Pair<Integer,Integer>(lu.key, 				 lu.value + bounds.height),
			new Pair<Integer,Integer>(lu.key + bounds.width, lu.value),
			new Pair<Integer,Integer>(lu.key + bounds.width, lu.value + bounds.height)
		]
	}
}