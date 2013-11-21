package de.wwu.pi.mdsd.umlToApp.data;

import org.eclipse.uml2.uml.Class

class ServiceClassGenerator {
	def generateServiceClass(Class clazz) '''
	package somePackageString.logic;
	
	import java.util.*;
	import somePackageString.data.*;
	import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
	import de.wwu.pi.mdsd05.framework.logic.ValidationException;
	
public class «clazz.name»Service extends AbstractServiceProvider<«clazz.name»> {
	//Constructor
	protected «clazz.name»Service() {
		super();
	}

	public boolean validate«clazz.name»(
	«FOR attribute : clazz.attributes.filter[att|att.multivalued == false] SEPARATOR ','»
	«attribute.type.name» «attribute.name.toFirstLower»
	«ENDFOR») throws ValidationException {
	«FOR attribute : clazz.attributes.filter[att|att.multivalued == false]»
		if(«attribute.name.toFirstLower»==null)
			throw new ValidationException("«attribute.name.toFirstLower»","cannot be empty");
	«ENDFOR»
		return true;
	}
	
	public «clazz.name» save«clazz.name.toFirstUpper»(int id, «FOR attribute : clazz.attributes.filter[att|
		att.multivalued == false] SEPARATOR ','»
	«attribute.type.name» «attribute.name.toFirstLower»
	«ENDFOR») {
	«clazz.name» elem = getByOId(id);
	if(elem == null)
		elem = new «clazz.name»();
	«FOR attribute : clazz.attributes.filter[att|att.multivalued == false]»
		elem.set«attribute.name.toFirstUpper»(«attribute.name.toFirstLower»);
	«ENDFOR»
	persist(elem);
	return elem;
	}
	
	«IF clazz.attributes.exists[att|att.appliedStereotypes.exists[st|st.name.equals("PrimaryKey")]]»
	
	public «clazz.name» getBy«FOR attribute : clazz.attributes.filter[att|
		att.appliedStereotypes.exists[st|st.name.equals("PrimaryKey")]]»«attribute.name.toFirstUpper»«ENDFOR»(
	«FOR attribute : clazz.attributes.filter[att|att.appliedStereotypes.exists[st|st.name.equals("PrimaryKey")]] SEPARATOR ','»
«attribute.type.name» «attribute.name.toFirstLower»
	«ENDFOR»){
	
		Collection<«clazz.name»> «clazz.name.toFirstLower»s = getAll();

			for («clazz.name» elem: «clazz.name.toFirstLower»s)
			{
				«FOR attribute : clazz.attributes.filter[att|att.appliedStereotypes.exists[st|st.name.equals("PrimaryKey")]]»
					if (elem.get«attribute.name.toFirstUpper»() != «attribute.name.toFirstLower») continue;
				«ENDFOR»
				return elem;
				
			}
			return null;
	
	}
«ENDIF»

}

	
	
	'''
}
