package de.wwu.pi.mdsd.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.VisibilityKind

class ModelAndPackageHelper {
	def static allEntities(Model model) {
		model.allOwnedElements.filter(typeof(Class)).filter[c | c.appliedStereotypes.exists["Entity".equals(name)]]
		//model.allOwnedElements.filter(typeof(Class)).filter[ it.appliedStereotypes.exists["Entity".equals(name)]]
	}


	def static visibilityInJava(VisibilityKind kind) {
		switch (kind) {
			case VisibilityKind.PACKAGE: 'package'
			case VisibilityKind.PROTECTED: 'protected'
			case VisibilityKind.PUBLIC: 'public'
			case VisibilityKind.PRIVATE: 'private'
		}
	}
	def static visibilityInJava(Property p) {
		p.visibility.visibilityInJava
	}
}
