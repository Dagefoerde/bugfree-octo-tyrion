package de.wwu.pi.mdsd.umlToApp.service

import org.eclipse.uml2.uml.Class

class ServiceInitializerGenerator {
	def generateServiceInitializer(Iterable<Class> entities) '''
		package somePackageString.service;
		
		
		public class ServiceInitializer {
	

		}


	'''
}


	

