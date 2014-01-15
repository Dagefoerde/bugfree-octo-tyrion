package de.wwu.pi.mdsd.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.VisibilityKind

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*

class ModelAndPackageHelper {
	def static Iterable<Class> allEntities(Model model) {
		model.allOwnedElements.filter(typeof(Class));
	}

	def static toFolderString(String packageName) {
		packageName.replace('.', '/')
	}

	def static packageString(Class clazz) {
		clazz.package.name
	}

	def static entityPackageString(Class clazz) {
		clazz.packageString + ".data"
	}

	def static logicPackageString(Class clazz) {
		clazz.packageString + ".logic"
	}

	def static guiPackageString(Class clazz) {
		clazz.packageString + ".gui"
	}

	def static visibilityInJava(VisibilityKind kind) {
		switch (kind) {
			case VisibilityKind.PACKAGE_LITERAL: 'package'
			case VisibilityKind.PROTECTED_LITERAL: 'protected'
			case VisibilityKind.PUBLIC_LITERAL: 'public'
			case VisibilityKind.PRIVATE_LITERAL: 'private'
		}
	}

	def static visibilityInJava(Property p) {
		p.visibility.visibilityInJava
	}
}
