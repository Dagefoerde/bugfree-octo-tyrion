package de.wwu.pi.mdsd.umlToApp.data

import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class DataClassGenerator {
	def generateDataClass(Class clazz) 
	'''
		package «PACKAGE_STRING».data;
		
		«IF clazz.generalizations.size==0»
		import de.wwu.pi.mdsd.framework.data.AbstractDataClass;
		«ENDIF»
		«IF(clazz.ownedAttributes.exists[a|a.multivalued])
		»import java.util.List;
		import java.util.ArrayList;
		«ENDIF»
		«IF(clazz.ownedAttributes.exists[a|a.type.name.equals("Date")])
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
	«FOR attribute : clazz.listOfAllAttributes.filter[att|att.multivalued==false] SEPARATOR ','»
	«attribute.type.name» «attribute.name» 
	«ENDFOR») {
	super(«FOR attribute : clazz.listOfSuperAttributes.filter[att|att.multivalued==false] SEPARATOR ','»«attribute.name»«ENDFOR»);
	«FOR attribute : clazz.attributes»
	«IF attribute.type instanceof Class && attribute.multivalued»
	«ELSE»
	this.«attribute.name»=«attribute.name»;
	«ENDIF»
	«ENDFOR»}
	
	«FOR attribute:clazz.listOfAllAttributes.filter[att|att.type instanceof Class && att.multivalued==false]»
	public «clazz.name»(«attribute.type.name» «attribute.name») {
		super();
		this.«attribute.name»=«attribute.name»;
	}
	«ENDFOR»
	
		
		@Override
	public String toString() {
		return (""
		«IF clazz.isGeneralized»
		+ super.toString() 
		«ENDIF»
		«FOR attribute:clazz.attributes.filter(att|att.multivalued==false)»
		+ "," + get«attribute.name.toFirstUpper»()
		«ENDFOR»);
	}
	}

	'''
}

	

