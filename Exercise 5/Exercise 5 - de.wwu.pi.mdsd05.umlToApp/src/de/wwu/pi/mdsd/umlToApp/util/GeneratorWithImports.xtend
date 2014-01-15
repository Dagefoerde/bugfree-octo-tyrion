package de.wwu.pi.mdsd.umlToApp.util

import java.util.HashSet
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Type

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

abstract class GeneratorWithImports {
	public static val IMPORTS_MARKER = "//$GENERATED_IMPORTS_HERE$"
	val HashSet<String> imports = newHashSet
	
	def generate(Class clazz) {
		clazz.doGenerate.toString.replace(IMPORTS_MARKER, imports.sort.map['''import «it»;'''].join('\n'))
	}
	
	def CharSequence doGenerate(Class clazz)
	
	def imported(String imp) {
		imports.add(imp)
		imp.substring(imp.lastIndexOf('.') + 1)
	}
	
	def importedType(Type type) {
		if(type.entity)
			imported((type as Class).entityPackageString + '.' + type.javaType)
		type.javaType
	}
}