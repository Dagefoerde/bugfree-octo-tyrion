package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import de.wwu.pi.mdsd05.group05DSL.Property
import de.wwu.pi.mdsd05.group05DSL.Reference
import java.util.HashSet
import org.eclipse.emf.common.util.BasicEList
import de.wwu.pi.mdsd05.group05DSL.Model

class EntitytypeHelperMethods {
	def static getAllPropertiesIncludingSuperproperties(Entitytype type) {
		val visitedEntitytypes = new HashSet<Entitytype>();

		var entitytype = type;
		var properties = new BasicEList<Property>();

		while (entitytype != null && !visitedEntitytypes.contains(entitytype)) {
			visitedEntitytypes += entitytype;
			properties += entitytype.getProperties();

			entitytype = entitytype.getSupertype();

		}

		return properties;
	}

	def static hasCyclicInheritance(Entitytype entity) {

		val visitedEntitytypes = new HashSet<Entitytype>();
		var entitytype = entity;

		while (entitytype != null) {
			if (visitedEntitytypes.contains(entitytype)) {
				return true;
			}

			visitedEntitytypes += entitytype;
			entitytype = entitytype.getSupertype();

		}

		return false

	}
	def static hasWrongOppositeReference(Reference ref) {
			val entity = (ref.eContainer as Entitytype)
			val mult = ref.multiplicity
			val opposite = ref.references.properties.filter[re|re instanceof Reference].map[re|re as Reference].filter[re|
				re.references == entity && !mult.equals(re.multiplicity)]
			if(opposite.size < 1) return true
		return false
	}

	def static isSuperClassAnywhere(Entitytype entitytype) {
		var entitytypes = (entitytype.eContainer() as Model).getEntitytypes();
		for (Entitytype e : entitytypes) {
			if(e.getSupertype() != null && e.getSupertype().equals(entitytype)) return true;
		}
		return false;
	}
	
	def static referencesItself(Reference ref){
		val entity = (ref.eContainer as Entitytype)
			if(ref.references.equals(entity)) return true
		return false
	}
	
	def static referencesSubOrSuperclass(Reference ref){
		val entity = (ref.eContainer as Entitytype)
		var loopEntity = entity
		
		//represents a Hashset of all classes that the entity inherits from
		val superClasses = new HashSet<Entitytype>();
		while (loopEntity.supertype!=null && !superClasses.contains(loopEntity)){
			superClasses.add(loopEntity.supertype)
			loopEntity=loopEntity.supertype
			}
		//represents a Hashset of all classes that inherit from entity and for calculation purposes the entity itself
		val subClasses = new HashSet<Entitytype>();
		subClasses.add(entity)
		//to reduce the calculation duration the search space for subclasses is reduced during processing
		val leftClasses = new HashSet<Entitytype>();
		leftClasses.addAll((entity.eContainer() as Model).entitytypes.filter[c| !c.equals(entity)&&!superClasses.contains(c)])
		//states if a new subclass was added during the last iteration.
		var foundSomething=true
		//Searches for Subclasses among the leftClasses
		while (foundSomething){
			foundSomething=false
			for (Entitytype clazz:leftClasses){
				if (clazz.supertype!=null && subClasses.contains(clazz.supertype)){
					subClasses.add(clazz)
					leftClasses.remove(clazz)
					foundSomething=true
				}
			}
		}
		//If is not interesting in the method if the entity references itself, thus it is deleted from this list
		subClasses.remove(entity)
		
		//Is the reference referencing a sub or a superclass
				if (superClasses.contains(ref.references)) return true
				if (subClasses.contains(ref.references)) return true		
		return false
	}
	def static hasDoubleReference(Reference ref)
	{
		val entity = (ref.eContainer as Entitytype);
		for (re:entity.properties.filter[prop| prop instanceof Reference].map[prop|prop as Reference]){
			if (!re.equals(ref) && re.references.equals(ref.references) &&  re.multiplicity.equals(ref.multiplicity)){
				return true;
			}
		}
		return false;
		
	}

}
