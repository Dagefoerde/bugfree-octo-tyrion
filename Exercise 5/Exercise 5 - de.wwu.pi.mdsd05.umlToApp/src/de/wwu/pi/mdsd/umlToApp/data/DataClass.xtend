package de.wwu.pi.mdsd.umlToApp.data

import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class DataClass {
	def generateDataClass(Class clazz) '''
		package «clazz.entityPackageString»;
		
		import java.util.*;
		import de.wwu.pi.mdsd.framework.data.AbstractDataClass;
		
		@SuppressWarnings("serial")
		public «if(clazz.abstract) 'abstract ' »class «clazz.name» «clazz.superClassExtension ?: ''»{
			« //Declaration + Get/Set
			FOR att : clazz.primitiveAttributes(false)»
				
				«att.visibilityInJava» «att.typeAndNameInJava»;
				«att.generateGetter»
				«att.generateSetter»
			«ENDFOR»
			« //Single referenced objects
			FOR ref : clazz.singleReferences(false)»
				
				«ref.visibilityInJava» «ref.typeAndNameInJava»;
				«ref.generateGetter»
				«ref.generateSetter(ref.opposite)»
			«ENDFOR»
			« //Multi referenced objects
			FOR ref : clazz.multiReferences(false)»
				
				«ref.visibilityInJava» «ref.typeInJava» «ref.nameInJava» = new ArrayList<«ref.type.javaType»>();
				«ref.generateGetter»
				«ref.generateAdder»
			«ENDFOR»
			
			«IF clazz.requiredProperties(true).size > 0 »
				//Constructors
				public «clazz.name»(«clazz.requiredProperties(true).map[typeAndNameInJava].join( ', ')») {
					«IF (clazz.hasExplicitSuperClass)»
						super(«clazz.superClass.requiredProperties(true).join(null, ', ', null, [nameInJava])»);
					«ELSE»
						this();
					«ENDIF»
					«FOR att : clazz.primitiveAttributes(false).required»
						set«att.nameInJava.toFirstUpper»(«att.nameInJava»);
					«ENDFOR»
					«FOR ref : clazz.singleReferences(false).required»
						set«ref.nameInJava.toFirstUpper»(«ref.nameInJava»);
					«ENDFOR»
				}
			«ENDIF»
			« // Create methods to initialize single references
			FOR ref : clazz.singleReferences(true)»
				// Initializer for «ref.name»; can be called when initializing a new «clazz.name». Does not take care of friend methods
				public «clazz.name» «ref.initializeSingleRefMethodName»(«ref.typeAndNameInJava») {
					this.«ref.nameInJava» = «ref.nameInJava»;
					return this;
				}
			«ENDFOR»
			
			//Default Constructor
			public «clazz.name»() {
				super();
			}
			
			@Override
			public String toString() {
				return «if(clazz.hasExplicitSuperClass) 'super.toString() + ", " + '»«
				/* for each object concatenate the owned primitive attributes */
				clazz.primitiveAttributes(false).join(null,' + ", " + ', ' + ', [generateToStringPart])»""«
				/* If nothing is returned return the object id */
				if(clazz.primitiveAttributes(true).size==0) ' + getOid()'»;
			}
		}
	'''

	def generateAdder(Property p) '''
		protected void «p.adderMethodName»(«p.type.name» elem) {
			«p.nameInJava».add(elem);
		}
	'''

	def generateGetter(Property p) '''
		public «p.typeInJava» get«p.nameInJava.toFirstUpper»() {
			return «p.nameInJava»;
		}
	'''

	def generateSetter(Property p) {
		generateSetter(p, null)
	}

	// Generate Setter as friend method for 1-* references.
	// @TODO: does only support 1-* references
	def generateSetter(Property p, Property opposite) '''
		public void set«p.nameInJava.toFirstUpper»(«p.typeAndNameInJava») {
			«IF (opposite != null)»
				//do nothing, if «p.nameInJava» is the same
				if(this.«p.nameInJava» == «p.nameInJava»)
					return;
				//remove old «p.nameInJava» from opposite
				if(this.«p.nameInJava» != null)
					this.«p.nameInJava».«opposite.name».remove(this.«p.nameInJava»);
				this.«p.nameInJava» = «p.nameInJava»;
				//unless new «p.nameInJava» is null add 
				if(«p.nameInJava» != null)
					«p.nameInJava».«opposite.adderMethodName»(this);
			«ENDIF»
			this.«p.nameInJava» = «p.nameInJava»;
		}
	'''

	//Generates toString part for one property 
	def generateToStringPart(Property p) {
		val callToGetter = '''get«p.name.toFirstUpper»()''';
		//if p is not required it might be null, then print '-'
		'''(«IF !p.required»(«callToGetter»==null)?"-":«ENDIF»«callToGetter»)'''
	}

	def superClassExtension(Class clazz) {
		if (clazz.hasExplicitSuperClass)
			'extends ' + clazz.superClasses.head.javaType
		else
			'extends AbstractDataClass'
	}
	
	def adderMethodName(Property p) 
		'''addTo«p.name.toFirstUpper»'''
}
