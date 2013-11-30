package de.wwu.pi.mdsd.umlToApp.data

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList

class DataClassGenerator {
	def generateDataClass(Class clazz) {
	var listOfAllAttributes=clazz.attributes.toSet
	var listOfAttributes=clazz.attributes.toSet
	var EList<Property> listOfSuperAttributes=new BasicEList<Property>()
	var boolean isGeneralized=clazz.generalizations.size>0
	if(isGeneralized){
	listOfSuperAttributes=clazz.generalizations.get(0).general.attributes
	listOfAllAttributes.addAll(clazz.generalizations.get(0).general.attributes.toList)}
	'''
		package somePackageString.data;
		
		«IF clazz.generalizations.size==0»
		import de.wwu.pi.mdsd.framework.data.AbstractDataClass;
		«ENDIF»
		«IF(clazz.ownedAttributes.exists[a|a.multivalued])
		»import java.util.List;
		import java.util.ArrayList;
		«ENDIF»
		«IF( clazz.ownedAttributes.exists[a|a.type.name.equals("Date")])
		»import java.util.Date;
		«ENDIF»
		
		public class «clazz.name» extends 
		«IF clazz.generalizations.size>0»
		«clazz.generalizations.get(0).general.name»
		«ELSE» AbstractDataClass
		«ENDIF»{
			«FOR attribute : clazz.ownedAttributes »
			«IF (attribute.type instanceof Class) && attribute.multivalued»	
				«attribute.visibility» List<«attribute.type.name»> «attribute.name»s = new ArrayList<«attribute.type.name»>();	
			«ELSE»
				«attribute.visibility» «attribute.type.name» «attribute.name»;
			«ENDIF»		
			«ENDFOR»

		«FOR attribute : clazz.ownedAttributes»
			«IF (attribute.type instanceof Class) && attribute.multivalued»	
			public List<«attribute.type.name»> get«attribute.name.toFirstUpper»s(){
				return «attribute.name»s;
			}
			//called only by friend method
			protected void add«attribute.name.toFirstUpper»(«attribute.type.name» «attribute.name»){
				«attribute.name»s.add(«attribute.name»);
			}
				
			«ELSE» 
			public «attribute.type.name» get«attribute.name.toFirstUpper»(){
				return «attribute.name»;
			}
			
			public void set«attribute.name.toFirstUpper»(«attribute.type.name» «attribute.name»){
				«IF(attribute.type instanceof Class)»
					//do nothing, if «attribute.name» is the same
					if(this.«attribute.name» == «attribute.name») return;
					//remove old «clazz.name» from opposite
					if(this.«attribute.name» != null) this.«attribute.name».get«clazz.name.toFirstUpper»s().remove(this);
					//unless new «attribute.name» is null add 
					if(«attribute.name» != null) «attribute.name».add«clazz.name.toFirstUpper»(this);
				«ENDIF»
				this.«attribute.name» = «attribute.name»;
				
			}
			«ENDIF»		
		«ENDFOR»
	
		public «clazz.name»()
		{
			super();	
		}
		public «clazz.name»(
	«FOR attribute : listOfAllAttributes.filter[att|att.multivalued==false] SEPARATOR ','»
	«attribute.type.name» «attribute.name» 
	«ENDFOR») {
	super(«FOR attribute : listOfSuperAttributes.filter[att|att.multivalued==false] SEPARATOR ','»«attribute.name»«ENDFOR»);
	«FOR attribute : listOfAttributes»
	«IF attribute.type instanceof Class && attribute.multivalued»
	«ELSE»
	this.«attribute.name»=«attribute.name»;
	«ENDIF»
	«ENDFOR»}
	
	«FOR attribute:listOfAllAttributes.filter[att|att.type instanceof Class && att.multivalued==false]»
	public «clazz.name»(«attribute.type.name» «attribute.name») {
		super();
		this.«attribute.name»=«attribute.name»;
	}
	«ENDFOR»
	
		
		@Override
	public String toString() {
		return (""+
		«IF isGeneralized»
		super.toString() + "," +
		«ENDIF»
		«FOR attribute:listOfAttributes.filter(att|att.multivalued==false) SEPARATOR '+ "," +'»
		get«attribute.name.toFirstUpper»()
		«ENDFOR»);
	}
	}

	'''
}
}

	

