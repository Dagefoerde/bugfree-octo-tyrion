package de.wwu.pi.mdsd.umlToApp

import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.uml2.uml.Model
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.uml2.uml.Class

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
		println(
			"Model elements within the UML model: " +
				model.allOwnedElements.filter(typeof(Class)).join(", ", [clazz|clazz.name])
		)
	}

	def doGenerate(CrudModel model, IFileSystemAccess fsa) {
		println(
			"Window elements within the crud model: " + model.windows.join(", ", [it.name])
		)
	}
}