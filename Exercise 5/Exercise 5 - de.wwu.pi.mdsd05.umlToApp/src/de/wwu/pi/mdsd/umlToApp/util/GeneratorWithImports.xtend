package de.wwu.pi.mdsd.umlToApp.util

import java.util.HashSet
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Type

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.Entity
import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel

abstract class GeneratorWithImports<T> {
	public static val IMPORTS_MARKER = "//$GENERATED_IMPORTS_HERE$"
	val HashSet<String> imports = newHashSet
	
	def generate(T object) {
		object.doGenerate.toString.replace(IMPORTS_MARKER, imports.sort.map['''import «it»;'''].join('\n'))
	}
	
	def CharSequence doGenerate(T object)
	
	def imported(String imp) {
		imports.add(imp)
		imp.substring(imp.lastIndexOf('.') + 1)
	}
	
	def importedType(Type type) {
		if(type.entity)
			imported((type as Class).entityPackageString + '.' + type.javaType)
		type.javaType
	}
	
	def importedType(Entity entity) {
		if(entity!=null)
			imported((entity.eContainer as CrudModel).entityPackageString + '.' + entity.javaType)
		entity.javaType
	}
}