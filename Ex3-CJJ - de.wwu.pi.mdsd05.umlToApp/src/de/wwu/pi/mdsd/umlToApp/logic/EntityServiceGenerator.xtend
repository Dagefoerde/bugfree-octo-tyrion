package de.wwu.pi.mdsd.umlToApp.logic

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntityServiceGenerator {
	
	def generateEntityServiceClass(Class clazz) {
	'''
	package «PACKAGE_STRING».logic;

	«IF(clazz.ownedAttributes.exists[a|a.type.name.equals("Date")])»import java.util.Date; 
	«ENDIF»
	import de.wwu.pi.mdsd.framework.logic.AbstractServiceProvider;
	import de.wwu.pi.mdsd.framework.logic.ValidationException;
	«IF clazz.listOfExtendingClasses.size>0»
	import java.util.Collection;
	import java.util.LinkedList;
	«ENDIF»
	
	import «PACKAGE_STRING».data.«clazz.name»;
	«FOR attribute: clazz.listOfAllAttributes.filter[a|a.type instanceof Class && !a.multivalued]»import «PACKAGE_STRING».data.«attribute.type.name»; 
	«ENDFOR»
	
	public class «clazz.name»Service extends AbstractServiceProvider<«clazz.name»> {
	
		protected «clazz.name»Service() {
			super();
		}
		
	
		public boolean validate«clazz.name.toFirstUpper»(«FOR attribute: clazz.listOfAllAttributes.filter[a|!a.multivalued] SEPARATOR', '
			»«attribute.type.name» «attribute.name»«ENDFOR») throws ValidationException {
			«FOR attribute: clazz.listOfAllAttributes.filter[a|!a.multivalued && a.lowerBound>0]»
			if(«attribute.name» == null)
				throw new ValidationException("«attribute.name»", "cannot be empty");
			«ENDFOR» 
			return true;
		}
	
	
		
		public «clazz.name» save«clazz.name.toFirstUpper»(int id, «FOR attribute: clazz.listOfAllAttributes.filter[a|!a.multivalued] SEPARATOR ', '
			»«attribute.type.name» «attribute.name»«ENDFOR»){
			«clazz.name» elem = getByOId(id);
			if(elem == null) elem = new «clazz.name»();
			
			«FOR attribute : clazz.listOfAllAttributes.filter[a|!a.multivalued]»
			elem.set«attribute.name.toFirstUpper»(«attribute.name»);
			«ENDFOR»
			persist(elem);
			return elem;
		}
		
	«IF clazz.listOfExtendingClasses.size>0»
	@Override
	public Collection<«clazz.name»> getAll() {
		Collection<«clazz.name»> result = new LinkedList<«clazz.name»>();
		«FOR ext:clazz.listOfExtendingClasses»
		result.addAll(ServiceInitializer.getProvider().get«ext.name.toFirstUpper»Service().getAll());
		«ENDFOR»
		return result;
	}	
	«ENDIF»
	
	
	}

	'''
}
}