package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import java.util.HashSet
import de.wwu.pi.mdsd05.group05DSL.Property;
import org.eclipse.emf.common.util.BasicEList

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

}
