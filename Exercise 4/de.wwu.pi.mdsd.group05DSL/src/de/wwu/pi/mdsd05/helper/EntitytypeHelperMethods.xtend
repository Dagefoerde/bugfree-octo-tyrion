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

}
