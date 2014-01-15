package de.wwu.pi.mdsd.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Element
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.Type

import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class ClassHelper { 
	
	def static serviceClassName(Type clazz) {
		clazz.name + 'Service'
	}

	def static listWindowClassName(Type clazz) {
		clazz.name + 'ListWindow'
	}

	def static entryWindowClassName(Type clazz) {
		clazz.name + 'EntryWindow'
	}
	
	def static listingInterfaceClassName(Type type) {
		type.name + 'ListingInterface'
	}
	def static listingInterfaceMethodeName(Type type) {
		'initialize'+ type.name +'Listings'
	}
	
	def static initializeSingleRefMethodName(Property ref) {
		'initialize' + ref.name.toFirstUpper
	}

	def static isDate(Property p) {
		"Date".equals(p.type.name)
	}

	def static isString(Property p) {
		"String".equals(p.type.name)
	}
	
	def static isNumberObject(Property p) {
		"Integer".equals(p.type.name)
	}
	
	def static isNumberPrimitiv(Property p) {
		"int".equals(p.type.name)
	}
	
	def static isObject(Property p) {
		p.string || p.numberObject || p.date
	}
	
	//Note that more specific types are handled first, thus 'Class' is handled before 'Element'.
	// org.eclipse.uml2.uml.Class is subclass of org.eclipse.uml2.uml.Element
	def static dispatch isEntity(Element element) {
		false
	}
	def static dispatch isEntity(Class clazz) {
		clazz.appliedStereotypes.exists[name == "Entity"]
	}

	//-------------------------------------------------------------------------------------
	// Inheritance
	//-------------------------------------------------------------------------------------
	
	def static hasExplicitSuperClass(Class clazz) {
		!clazz.superClasses.empty
	}

	def static superClass(Class clazz) {
		if (clazz.hasExplicitSuperClass)
			clazz.superClasses.head
	}
	
	def static Iterable<Class> allSuperClasses(Class clazz) {
		if(clazz.hasExplicitSuperClass)
			allSuperClasses(clazz.superClass) + #[clazz.superClass]
		else
			emptyList
	}
	
	def static getDirectSubClasses(Class clazz) {
		clazz.model.allEntities.filter[it.superClass == clazz]
	}

	def static hasSubClasses(Class clazz) {
		clazz.getDirectSubClasses.size > 0
	}

	def static hasSubClasses(Property att) {
		att.opposite.class_.hasSubClasses
	}

	def static Iterable<Class> getInstantiableClasses(Class clazz) {
		(	newLinkedList(clazz) +
			//for all sub classes get instantiable classes 
			clazz.getDirectSubClasses.map(cl|cl.instantiableClasses).flatten
		).filter[cl|!cl.abstract].toSet
	}
	
	//-------------------------------------------------------------------------------------
	// Properties and references
	//-------------------------------------------------------------------------------------
	
	def static dispatch Iterable<Property> attributes(Void x, boolean considerSuperclass) {
		emptyList
	}
	
	def static dispatch Iterable<Property> attributes(Class clazz, boolean considerSuperclass) {
		if (considerSuperclass && clazz.hasExplicitSuperClass)
			clazz.superClass.attributes(true) + clazz.attributes
		else
			clazz.attributes
	}
	
	def static primitiveAttributes(Class clazz, boolean considerSuperclass) {
		/* For now, only consider single-valued attributes */
		clazz.attributes(considerSuperclass).filter[!it.multivalued && !type.entity]
	}

	def static entityReferences(Class clazz, boolean considerSuperclass) {
		clazz.attributes(considerSuperclass).filter[type.entity]
	}

	def static singleReferences(Class clazz, boolean considerSuperclass) {
		clazz.entityReferences(considerSuperclass).filter[!it.multivalued]
	}

	def static multiReferences(Class clazz, boolean considerSuperclass) {
		clazz.entityReferences(considerSuperclass).filter[it.multivalued]
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

	def static nameInJava(Property p) {
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
