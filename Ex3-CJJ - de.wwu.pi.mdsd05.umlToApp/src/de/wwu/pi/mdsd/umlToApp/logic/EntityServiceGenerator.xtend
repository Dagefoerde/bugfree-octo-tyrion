package de.wwu.pi.mdsd.umlToApp.logic

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntityServiceGenerator {
	
	def generateEntityServiceClass(Class clazz) '''
	package somePackageString.logic;
	«IF(clazz.ownedAttributes.exists[a|a.multivalued])»import java.util.Collection;
	import java.util.LinkedList;
	«ENDIF»
	«IF(clazz.ownedAttributes.exists[a|a.type.name.equals("Date")])»import java.util.Date; 
	«ENDIF»
	import de.wwu.pi.mdsd.framework.logic.AbstractServiceProvider;
	import de.wwu.pi.mdsd.framework.logic.ValidationException;
	
	import somePackageString.data.«clazz.name»;
	«FOR attribute: clazz.ownedAttributes.filter[a|a.type instanceof Class]»import somePackageString.data.«attribute.type.name»; 
	«ENDFOR»
	
	public class «clazz.name»Service extends AbstractServiceProvider<«clazz.name»> {
	
		protected «clazz.name»Service() {
			super();
		}
		
	
		public boolean validate«clazz.name.toFirstUpper»(«FOR attribute: clazz.ownedAttributes.filter[a|!a.multivalued] SEPARATOR', '
			»«attribute.type.name» «attribute.name»«ENDFOR») throws ValidationException {
			«FOR attribute: clazz.ownedAttributes.filter[a|!a.multivalued]»
			if(«attribute.name» == null)
				throw new ValidationException("«attribute.name»", "cannot be empty");
			«ENDFOR» 
			return true;
		}
	
	
		
		public «clazz.name» save«clazz.name»(int id, «FOR attribute: clazz.ownedAttributes.filter[a|!a.multivalued] SEPARATOR ', '
			»«attribute.type.name» «attribute.name»«ENDFOR»){
			«clazz.name» elem = getByOId(id);
			if(elem == null) elem = new «clazz.name»();
			
			«FOR attribute : clazz.ownedAttributes.filter[a|!a.multivalued]»
			elem.set«attribute.name.toFirstUpper»(«attribute.name»);
			«ENDFOR»
			persist(elem);
			return elem;
		}
	
	
	
	
	}

	'''
	
}