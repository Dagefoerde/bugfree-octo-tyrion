package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import de.wwu.pi.mdsd05.group05DSL.Property
import de.wwu.pi.mdsd05.group05DSL.Reference
import java.util.HashSet
import org.eclipse.emf.common.util.BasicEList
import de.wwu.pi.mdsd05.group05DSL.Model
import java.awt.List

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

	def static hasWrongOppositeReferences(Entitytype entity) {

		for (ref : entity.getProperties().filter[re|re instanceof Reference].map[re|re as Reference]) {
			val mult = ref.multiplicity
			val opposite = ref.references.properties.filter[re|re instanceof Reference].map[re|re as Reference].filter[re|
				re != ref && re.references == entity]
			if(opposite.size != 1) return true
			if(mult == opposite.get(0).multiplicity) return true

		}
		return false
	}

	def static isSuperClassAnywhere(Entitytype entitytype) {
		var entitytypes = (entitytype.eContainer() as Model).getEntitytypes();
		for (Entitytype e : entitytypes) {
			if(e.getSupertype() != null && e.getSupertype().equals(entitytype)) return true;
		}
		return false;
	}
	
	def static referencesItself(Entitytype entity){
		for (Reference r : entity.properties.filter[ref| ref instanceof Reference].map[ref| ref as Reference]){
			if(r.references.equals(entity)) return true
		}
		return false
	}
	
	def static referencesSubOrSuperclass(Entitytype entity){
		val superClass = entity.supertype
		
		var Entitytype[] subClasses
		subClasses.add(entity)
		var Entitytype[] leftClasses = (entity.eContainer() as Model).entitytypes.filter[c| !c.equals(entity)]
		
		for(int i:0..(entity.eContainer()as Model).entitytypes.size-2){
			for (e: leftClasses){
				for (s: subClasses){
					if(e.properties.filter[ref|ref instanceof Reference].map[ref|ref as Reference].equals(s)) return true
					if (e.supertype != null && e.supertype.equals(s)){
						subClasses.add(e)
						leftClasses.remove(e)
					}
				}

			}
		}
		
		val references = entity.properties.filter[ref| ref instanceof Reference].map[ref| ref as Reference]
			for(ref : references){
				if (ref.references.equals(superClass)) return true
				for(sub : subClasses){
					if (ref.references.equals(sub)) return true
				}			
			}			
		return false
	}

}
