package de.wwu.pi.mdsd.umlToApp.data

import org.eclipse.uml2.uml.Class

class DataClassGenerator {
	def generateDataClass(Class clazz) '''
		package somePackageString;
		
		public class «clazz.name» {
			«FOR attribute : clazz.ownedAttributes »
				//Some comment for «attribute.name»
			«ENDFOR»
		}

	'''
}

