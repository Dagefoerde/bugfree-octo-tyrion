package de.wwu.pi.mdsd.umlToApp.logic

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntityServiceGenerator {
	
	def generateEntityServiceClass(Class clazz) '''
	«IF(clazz.ownedAttributes.exists[a|a.multivalued])» import java.util.Collection;
	import java.util.LinkedList;
	«ENDIF»
	«IF(clazz.ownedAttributes.exists[a|a.type.name.equals("Date")])» import java.util.Date; 
	«ENDIF»
	import de.wwu.pi.mdsd.framework.logic.AbstractServiceProvider;
	import de.wwu.pi.mdsd.framework.logic.ValidationException;
	
	import de.wwu.pi.mdsd.library.ref.data.«clazz.name»;
		

	public class «clazz.name»Service extends AbstractServiceProvider<«clazz.name»> {
	
		protected «clazz.name»Service() {
			super();
		}
		
	
		public boolean validate«clazz.name.toFirstUpper»(
		«FOR attribute: clazz.ownedAttributes» SEPERATOR ','
		«attribute.type.name» «attribute.name» «ENDFOR» throws ValidationException {
		«FOR attribute: clazz.ownedAttributes»
		if(«attribute.name» == null)
			throw new ValidationException(«attribute.name», "cannot be empty");
		return true;
		«ENDFOR» 

	}
	
	
	
	}

	'''
	
}