package de.wwu.pi.mdsd.umlToApp

import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.uml2.uml.Model
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.uml2.uml.Class
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import java.io.File
import de.wwu.pi.mdsd.umlToApp.data.DataClassGenerator
import de.wwu.pi.mdsd.umlToApp.logic.ServiceInitializerGenerator
import de.wwu.pi.mdsd.umlToApp.logic.EntityServiceGenerator

class UmlToAppGenerator implements IGenerator {
	def static isModel(Resource input) {
		input.contents.size == 2 && input.crudModel != null && input.umlModel != null
	}

	def static getCrudModel(Resource input) {
		input.contents.head as CrudModel
	}

	def static getUmlModel(Resource input) {
		input.contents.tail.head as Model
	}

	/* 
	 * Limitations / Assumptions:
	 * - @structure: (no nested packages, everything contained in Model) 
	 * - @properties: only bidirectional 1:* references, no multi-valued primitive attributes
	 * - @size & position in pixel
	 */
	override doGenerate(Resource input, IFileSystemAccess fsa) {
		System::out.print("UmlToAppGenerator.doGenerate called with resource " + input.URI)
		if (isModel(input)) {
			System::out.println(" - Generating ...")
			input.umlModel.doGenerate(fsa)
			input.crudModel.doGenerate(fsa)
		} else
			System::out.println(" - Skipped.")
	}

	def doGenerate(Model model, IFileSystemAccess fsa) {
		val PACKAGE_DIR = PACKAGE_STRING.replace('.', File.separatorChar);
		model.allOwnedElements.filter(typeof(Class)).forEach[ clazz |
			fsa.generateFile('''«PACKAGE_DIR»«File.separatorChar»data«File.separatorChar»«clazz.name».java''', new DataClassGenerator().generateDataClass(clazz))
			fsa.generateFile('''«PACKAGE_DIR»«File.separatorChar»logic«File.separatorChar»«clazz.name»Service.java''', new EntityServiceGenerator().generateEntityServiceClass(clazz))
			
		]
		fsa.generateFile('''«PACKAGE_DIR»«File.separatorChar»logic«File.separatorChar»ServiceInitializer.java''', new ServiceInitializerGenerator().generateServiceInitializer(model.allEntities))
	
		
		
		
		
			"Model elements within the UML model: " +
				model.allOwnedElements.filter(typeof(Class)).join(", ", [clazz|clazz.name])
		
	}

	def doGenerate(CrudModel model, IFileSystemAccess fsa) {
		val PACKAGE_DIR = PACKAGE_STRING.replace('.', File.separatorChar);
		println(
			"Window elements within the crud model: " + model.windows.join(", ", [it.name])
		)
	}
}