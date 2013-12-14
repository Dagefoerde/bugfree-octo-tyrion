package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import de.wwu.pi.mdsd05.group05DSL.Property
import java.util.ArrayList
import org.eclipse.emf.common.util.EList

class HelperMethods {
	def static EList<Property> getAllPropertiesIncludingSuperproperties(Entitytype type)
	{
		val listOfVisitedEntitytypes = new ArrayList<Entitytype>();
		
		var entitytype = type;
 		var properties = entitytype.getProperties();
 		
 		while (entitytype.getSupertype()!=null
 			 && !listOfVisitedEntitytypes.contains(entitytype)
 		)
 		{
 			listOfVisitedEntitytypes+=entitytype;
 			properties += entitytype.getSupertype().getProperties();
 			entitytype = entitytype.getSupertype();
 		}
 		
		return properties;
	}
}