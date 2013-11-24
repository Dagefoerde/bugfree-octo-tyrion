package de.wwu.pi.mdsd.umlToApp

import de.wwu.pi.mdsd.umlToApp.data.DataClassGenerator
import java.io.File
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.uml2.uml.Model
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator

import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class UmlToAppGenerator implements IGenerator {
	static val INTERNAL_MODEL_EXTENSIONS = newArrayList(".library.uml", ".profile.uml", ".metamodel.uml")
	
	def static isModel(Resource input) {
		!INTERNAL_MODEL_EXTENSIONS.exists(ext | input.URI.path.endsWith(ext))
	}

	override doGenerate(Resource input, IFileSystemAccess fsa) {
		print("UmlToAppGenerator.doGenerate called with resource " + input.URI)
		if(isModel(input)) {
			println(" - Generating ...")
			input.contents.filter(typeof(Model)).forEach[doGenerate(fsa)]
		}
		else
			println(" - Skipped.")
	}
	
	def doGenerate(Model model, IFileSystemAccess fsa) {
		model.allEntities.forEach[ clazz |
			fsa.generateFile('''somePackageString«File.separatorChar»data«File.separatorChar»«clazz.name».java''', new DataClassGenerator().generateDataClass(clazz))
		]
	}
}