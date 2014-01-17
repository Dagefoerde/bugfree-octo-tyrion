package de.wwu.pi.mdsd.umlToApp.util

import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import de.wwu.pi.mdsd.crudDsl.crudDsl.Property
import de.wwu.pi.mdsd.crudDsl.crudDsl.Attribute
import de.wwu.pi.mdsd.crudDsl.crudDsl.Reference
import de.wwu.pi.mdsd.crudDsl.crudDsl.MultiplicityKind

class ClassHelper { 

	def static listWindowClassName(Entity entity) {
		entity.name + 'ListWindow'
	}
	
	/*def static listingInterfaceClassName(Type type) {
		type.name + 'ListingInterface'
	}
	def static listingInterfaceMethodeName(Type type) {
		'initialize'+ type.name +'Listings'
	}*/
	
	def static entryWindowClassName(Entity entity) {
		entity.name + 'EntryWindow'
	}
	
	def static serviceClassName(Entity entity) {
		entity.name + 'Service'
	}
	
	def static listingInterfaceClassName(Entity entity) {
		entity.name + 'ListingInterface'
	}
	
	def static listingInterfaceMethodeName(Entity enity) {
		'initialize'+ enity.name +'Listings'
	}
	
	def static initializeSingleRefMethodName(Property ref) {
		'initialize' + ref.name.toFirstUpper
	}

	def static isDate(Attribute a) {
		"Date".equals(a.type.name)
	}

	def static isString(Attribute a) {
		"String".equals(a.type.name)
	}
	
	def static isNumberObject(Attribute a) {
		"Integer".equals(a.type.name)
	}
	
	def static isNumberPrimitiv(Attribute a) {
		"int".equals(a.type.name)
	}
	
	def static isObject(Attribute a) {
		a.string || a.numberObject || a.date
	}
	
	//Note that more specific types are handled first, thus 'Class' is handled before 'Element'.
	// org.eclipse.uml2.uml.Class is subclass of org.eclipse.uml2.uml.Element
	/*def static dispatch isEntity(Element element) {
		false
	}
	def static dispatch isEntity(Class clazz) {
		true
	}*/

	//-------------------------------------------------------------------------------------
	// Inheritance
	//-------------------------------------------------------------------------------------
	
	def static hasExplicitSuperClass(Entity entity) {
		entity.superType!=null
	}

	def static superClass(Entity entity) {
		if (entity.hasExplicitSuperClass)
			entity.superType
	}
	
	def static Iterable<Entity> allSuperClasses(Entity entity) {
		if(entity.hasExplicitSuperClass)
			allSuperClasses(entity.superClass) + #[entity.superClass]
		else
			emptyList
	}
	
	def static getDirectSubClasses(Entity entity) {
		(entity.eContainer as CrudModel).entities.filter[it.superType == entity]
	}

	def static hasSubClasses(Entity entity) {
		entity.getDirectSubClasses.size > 0
	}

	/*def static hasSubClasses(Property att) {
		att.opposite.class_.hasSubClasses
	}*/

	def static Iterable<Entity> getInstantiableClasses(Entity entity) {
		(	newLinkedList(entity) +
			//for all sub classes get instantiable classes 
			entity.getDirectSubClasses.map(cl|cl.instantiableClasses).flatten
		).filter[cl|!cl.abstract].toSet
	}
	
	//-------------------------------------------------------------------------------------
	// Properties and references
	//-------------------------------------------------------------------------------------
	
	def static dispatch Iterable<Property> properties(Void x, boolean considerSuperclass) {
		emptyList
	}
	
	def static dispatch Iterable<Property> properties(Entity entity, boolean considerSuperclass) {
		if (considerSuperclass && entity.hasExplicitSuperClass)
			entity.superClass.properties(true) + entity.properties
		else
			entity.properties
	}
	
	def static primitiveAttributes(Entity entity, boolean considerSuperclass) {
		/* For now, only consider single-valued attributes */
		entity.properties(considerSuperclass).filter(Attribute)
	}

	def static entityReferences(Entity entity, boolean considerSuperclass) {
		entity.properties(considerSuperclass).filter(Reference)
	}

	def static singleReferences(Entity entity, boolean considerSuperclass) {
		entity.entityReferences(considerSuperclass).filter[it.multiplicity==MultiplicityKind.SINGLE]
	}

	def static multiReferences(Entity entity, boolean considerSuperclass) {
		entity.entityReferences(considerSuperclass).filter[it.multiplicity==MultiplicityKind.MULTIPLE]
	}

	/** primitive attributes and single References */
	def static singleValueProperties(Class clazz, boolean considerSuperclass) {
		(clazz.primitiveAttributes(considerSuperclass) + clazz.singleReferences(considerSuperclass))
	}

	def static Iterable<Property> required(Iterable<Property> properties) {
		properties.filter[it.required]
	}

	def static isRequired(Property p) {
		p.lowerBound >= 1
	}

	def static requiredProperties(Class clazz, boolean considerSuperclass) {
		(
			if (considerSuperclass)
				 clazz.superClass.singleValueProperties(considerSuperclass).required
			else
				emptyList
		)
		+ clazz.singleValueProperties(false).required
	}

	def static optionalProperties(Class clazz, boolean considerSuperclass) {
		clazz.singleValueProperties(considerSuperclass).filter[!it.required]
	}

	
	def static typeAndNameInJava(Property p) {
		'''«p.typeInJava» «p.nameInJava»'''
	}

	/** get the type representation of properties in Java 
	 * incl. multivalue type e.g. multivalued properties as List<p.javaType>
	 */
	def static typeInJava(Property p) {
		if (p.multivalued)
			'List<' + p.type.javaType + '>'
		else
			p.type.javaType
	}

	def static javaType(Type type) {
		type.name
	}
	def static javaType(Entity entity) {
		entity.name
	}

	def static nameInJava(Property p) {
		p.name
	}
	
	def static nameInJava(de.wwu.pi.mdsd.crudDsl.crudDsl.Property p) {
		p.name
	}
	
	/**
	 * get java object type for primitive java types
	 */
	def static objectType(String javaType) {
		switch (javaType) {
			case "boolean": "Boolean"
			case "int": "Integer"
			case "double": "Double"
			default: javaType
		}
	}
}
