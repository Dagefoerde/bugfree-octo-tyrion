package de.wwu.pi.mdsd.umlToApp.logic

import de.wwu.pi.mdsd.umlToApp.util.GeneratorWithImports
import org.eclipse.uml2.uml.Class

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class ServiceProvider extends GeneratorWithImports<Class>{
	override doGenerate(Class clazz) '''
	package «clazz.logicPackageString»;
	
	import java.util.Collection;
	import java.util.Date;
	import java.util.LinkedList;
	
	import de.wwu.pi.mdsd.framework.logic.AbstractServiceProvider;
	import de.wwu.pi.mdsd.framework.logic.ValidationException;
	
	«IMPORTS_MARKER»
	«//add imports for single value references
	 FOR att : clazz.singleValueProperties(true).filter[it.type.entity]»
		«var tmp = importedType(att.type)»
	«ENDFOR»
	
	public class «clazz.serviceClassName» extends AbstractServiceProvider<«importedType(clazz)»> {
		
		//Constructor
		protected «clazz.serviceClassName»() {
			super();
		}
		«/* write validation method */»
		public boolean validate«clazz.name»(«clazz.singleValueProperties(true).
				join(null, ', ', null, [typeInJava.objectType + " " + nameInJava])») throws ValidationException {
			«FOR att : clazz.singleValueProperties(true).filter[required]»
				if(«att.nameInJava» == null)
					throw new ValidationException("«att.label»", "cannot be empty");
			«ENDFOR»
			return true;
		}
		«/* write save method */»
		«IF !clazz.abstract »
			public «clazz.name» save«clazz.name»(int id«clazz.singleValueProperties(true).join(', ', ', ', null, [typeInJava.objectType + " " + nameInJava])») {
				«clazz.name» elem = getByOId(id);
				if(elem == null)
					elem = new «clazz.name»();
				«FOR att : clazz.singleValueProperties(true)»
					elem.set«att.name.toFirstUpper»(«att.name»);
				«ENDFOR»
				persist(elem);
				return elem;
			}
		«ENDIF»
		«/* overwrite getAll method for entities with subclasses */»
		«IF clazz.directSubClasses.size > 0»
			@Override
			//Class has subclasses, thus getAll need to return subclasses
			public Collection<«clazz.name»> getAll() {
				Collection<«clazz.name»> result = new LinkedList<«clazz.name»>();
				result.addAll(super.getAll());
				«FOR curClazz : clazz.directSubClasses »
					result.addAll(ServiceInitializer.getProvider().get«curClazz.serviceClassName»().getAll());
				«ENDFOR»
				return result;
			}
		«ENDIF»
	}
	'''
}



