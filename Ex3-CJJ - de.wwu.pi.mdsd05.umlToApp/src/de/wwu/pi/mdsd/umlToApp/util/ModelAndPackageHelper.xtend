package de.wwu.pi.mdsd.umlToApp.util

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.VisibilityKind
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.common.util.BasicEList
import java.util.Set

class ModelAndPackageHelper {
	public static val PACKAGE_STRING = "de.wwu.pi.mdsd05.library.generated"
	
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
	def static boolean isGeneralized(Class c){
		c.generalizations.size>0
	}
	def static listOfSuperAttributes(Class c){
		var EList<Property> listOfSuperAttributes=new BasicEList<Property>()
		if(c.isGeneralized){
			listOfSuperAttributes=c.generalizations.get(0).general.attributes
			}
		return listOfSuperAttributes
	}
	def static Set<Property> listOfAllAttributes(Class c){
		val allAttributes=c.attributes.toSet
		if(c.isGeneralized){
			for (att:c.generalizations.get(0).general.attributes){
				allAttributes.add(att)
			}
		}
		return allAttributes
	}
		
	def static listOfNotMultivaluedAttributes(Class c){
		c.listOfAllAttributes.filter[at | !at.multivalued]
	}
	def static listOfClassAttributes(Class c){
		c.listOfAllAttributes.filter[at | at.type instanceof Class]	}
	def static listOfMultivaluedClassAttributes(Class c){
		c.listOfAllAttributes.filter[at | at.multivalued && at.type instanceof Class]
	}
	def static listOfNotMultivaluedClassAttributes(Class c){
		c.listOfAllAttributes.filter[at | !at.multivalued && at.type instanceof Class]
	}
	def static listOfNotMultivaluedNonClassAttributes(Class c){
		c.listOfAllAttributes.filter[at | !at.multivalued && !(at.type instanceof Class)]
	}	
	def static listOfExtendingClasses(Class c){
		c.model.allEntities.filter[ent|ent.generalizations.exists[gen|gen.general.equals(c)]]
	}	
	

}
