package de.wwu.pi.mdsd.umlToApp.logic

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.BasicEList
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class EntityServiceGenerator {
	
	def generateEntityServiceClass(Class clazz) {
	var listOfExtendingClasses = clazz.model.allEntities.filter[ent|ent.generalizations.exists[gen|gen.general.equals(clazz)]]
	var listOfAllAttributes=clazz.attributes.toSet
	var listOfAttributes=clazz.attributes.toSet
	var EList<Property> listOfSuperAttributes=new BasicEList<Property>()
	var boolean isGeneralized=clazz.generalizations.size>0
	if(isGeneralized){
	listOfSuperAttributes=clazz.generalizations.get(0).general.attributes
	listOfAllAttributes.addAll(clazz.generalizations.get(0).general.attributes.toList)}
	'''
	package somePackageString.logic;

	«IF(clazz.ownedAttributes.exists[a|a.type.name.equals("Date")])»import java.util.Date; 
	«ENDIF»
	import de.wwu.pi.mdsd.framework.logic.AbstractServiceProvider;
	import de.wwu.pi.mdsd.framework.logic.ValidationException;
	«IF listOfExtendingClasses.size>0»
	import java.util.Collection;
	import java.util.LinkedList;
	«ENDIF»
	
	import somePackageString.data.«clazz.name»;
	«FOR attribute: clazz.ownedAttributes.filter[a|a.type instanceof Class && !a.multivalued]»import somePackageString.data.«attribute.type.name»; 
	«ENDFOR»
	
	public class «clazz.name»Service extends AbstractServiceProvider<«clazz.name»> {
	
		protected «clazz.name»Service() {
			super();
		}
		
	
		public boolean validate«clazz.name.toFirstUpper»(«FOR attribute: listOfAllAttributes.filter[a|!a.multivalued] SEPARATOR', '
			»«attribute.type.name» «attribute.name»«ENDFOR») throws ValidationException {
			«FOR attribute: listOfAllAttributes.filter[a|!a.multivalued]»
			if(«attribute.name» == null)
				throw new ValidationException("«attribute.name»", "cannot be empty");
			«ENDFOR» 
			return true;
		}
	
	
		
		public «clazz.name» save«clazz.name.toFirstUpper»(int id, «FOR attribute: listOfAllAttributes.filter[a|!a.multivalued] SEPARATOR ', '
			»«attribute.type.name» «attribute.name»«ENDFOR»){
			«clazz.name» elem = getByOId(id);
			if(elem == null) elem = new «clazz.name»();
			
			«FOR attribute : listOfAllAttributes.filter[a|!a.multivalued]»
			elem.set«attribute.name.toFirstUpper»(«attribute.name»);
			«ENDFOR»
			persist(elem);
			return elem;
		}
		
	«IF listOfExtendingClasses.size>0»
	@Override
	public Collection<«clazz.name»> getAll() {
		Collection<«clazz.name»> result = new LinkedList<«clazz.name»>();
		«FOR ext:listOfExtendingClasses»
		result.addAll(ServiceInitializer.getProvider().get«ext.name.toFirstUpper»Service().getAll());
		«ENDFOR»
		return result;
	}	
	«ENDIF»
	
	
	}

	'''
}
}