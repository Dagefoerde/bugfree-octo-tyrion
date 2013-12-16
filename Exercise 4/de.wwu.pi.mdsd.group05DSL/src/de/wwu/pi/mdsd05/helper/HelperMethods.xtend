package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import java.util.HashSet
import de.wwu.pi.mdsd05.group05DSL.Property;
import org.eclipse.emf.common.util.BasicEList

class HelperMethods {
	def static getAllPropertiesIncludingSuperproperties(Entitytype type)
	{
		val visitedEntitytypes = new HashSet<Entitytype>();
		
		var entitytype = type;
		var properties = new BasicEList<Property>();
		 		
 		while (entitytype!=null
 			 && !visitedEntitytypes.contains(entitytype)
 		)
 		{
 			visitedEntitytypes+=entitytype;
 			properties += entitytype.getProperties();
 			
 			entitytype = entitytype.getSupertype();
 			
 		}
 		
		return properties;
	}
}