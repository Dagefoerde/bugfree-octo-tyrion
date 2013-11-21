package de.wwu.pi.mdsd.umlToApp.data

import org.eclipse.uml2.uml.Class

class DataClassGenerator {
	def generateDataClass(Class clazz) '''
		package somePackageString.data;
		
		«IF clazz.generalizations.size==0»
		import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;
		«ENDIF»
		import java.util.*;
		«IF clazz.attributes.exists[att|att.multivalued==true]»
		import java.util.Vector;
		«ENDIF»
		
		public class «clazz.name» extends 
		«IF clazz.generalizations.size>0»
		«clazz.generalizations.get(0).general.name»
		«ELSE» AbstractDataClass
		«ENDIF»{
			«FOR attribute : clazz.ownedAttributes »
				//Some comment for «attribute.name.toFirstLower»
				«IF (attribute.type instanceof Class) && attribute.multivalued»
				protected Vector<«attribute.type.name»> «attribute.name.toFirstLower»s;
				«ELSE»
				protected «attribute.type.name» «attribute.name.toFirstLower»;
				«ENDIF»
			«ENDFOR»
			//Getters and Setters
			«FOR attribute : clazz.ownedAttributes »
				«IF (attribute.type instanceof Class) && attribute.multivalued»
				public Vector<«attribute.type.name»> get«attribute.name.toFirstUpper»s(){
					return «attribute.name.toFirstLower»s;
				}
				public boolean add«attribute.name.toFirstUpper»(«attribute.type.name» «attribute.name.toFirstUpper»){
					return «attribute.name.toFirstLower»s.add(«attribute.name.toFirstUpper»);
				}
				public boolean remove«attribute.name.toFirstUpper»(«attribute.type.name» «attribute.name.toFirstUpper»){
					return «attribute.name.toFirstLower»s.remove(«attribute.name.toFirstUpper»);
				}
				«ELSEIF (attribute.type instanceof Class) »
				public «attribute.type.name» get«attribute.name.toFirstUpper»(){
					return «attribute.name.toFirstLower»;
				}
				public void set«attribute.name.toFirstUpper»(«attribute.type.name» «attribute.name.toFirstLower»){
				//do nothing, if «attribute.name.toFirstLower» is the same
				if(this.«attribute.name.toFirstLower» == «attribute.name.toFirstLower»)
					return;
				//remove old «attribute.name.toFirstLower» from oposite
				if(this.«attribute.name.toFirstLower» != null)
					this.«attribute.name.toFirstLower».remove«clazz.name.toFirstUpper»(this);
				//unless new «attribute.name.toFirstLower» is null add 
				if(«attribute.name.toFirstLower» != null)
					«attribute.name.toFirstLower».add«clazz.name.toFirstUpper»(this);
				this.«attribute.name.toFirstLower» = «attribute.name.toFirstLower»;
				}
				«ELSE»
				public «attribute.type.name» get«attribute.name.toFirstUpper»(){
					return «attribute.name.toFirstLower»;
				}
				public void set«attribute.name.toFirstUpper»(«attribute.type.name» «attribute.name.toFirstLower»){
					this.«attribute.name.toFirstLower»=«attribute.name.toFirstLower»;
				}
				«ENDIF»
			«ENDFOR»
			
	//Constructor
	public «clazz.name»(
	«FOR attribute : clazz.attributes.filter(att|att.multivalued==false) SEPARATOR ','»
	«attribute.type.name» «attribute.name.toFirstLower» 
	«ENDFOR») {
	«FOR attribute : clazz.attributes»
	«IF attribute.type instanceof Class && attribute.multivalued»
	this.«attribute.name.toFirstLower»s=new Vector<«attribute.type.name»>();
	«ELSE»
	this.«attribute.name.toFirstLower»=«attribute.name.toFirstLower»;
	«ENDIF»
	«ENDFOR»}
	
	public «clazz.name»() {
		super();
		«FOR attribute : clazz.attributes.filter[att|att.multivalued==true]»
		«attribute.name.toFirstLower»s=new Vector<«attribute.type.name»>();
		«ENDFOR»
	}
	
	@Override
	public String toString() {
		return (
		«FOR attribute:clazz.attributes.filter(att|att.multivalued==false) SEPARATOR '+ "," +'»
		get«attribute.name.toFirstUpper»()
		«ENDFOR»);
	}
}

	'''
}

