package de.wwu.pi.mdsd.umlToApp

import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.uml2.uml.Model
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.eclipse.uml2.uml.Class

import de.wwu.pi.mdsd.umlToApp.gui.ListWindowGenerator
import de.wwu.pi.mdsd.umlToApp.logic.ServiceProvider
import de.wwu.pi.mdsd.umlToApp.data.DataClass
import de.wwu.pi.mdsd.umlToApp.logic.ServiceInitializerGen
import de.wwu.pi.mdsd.umlToApp.gui.StartWindowGenerator

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*
import de.wwu.pi.mdsd.crudDsl.crudDsl.ListWindow
import de.wwu.pi.mdsd.crudDsl.crudDsl.EntryWindow

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

		//process single entities
		model.allEntities.forEach[processEntity(fsa)]

		//Process model specific elements
		//Generate ServiceInitializer
		fsa.generateFile('''«model.allEntities.head.logicPackageString.toFolderString»/ServiceInitializer.java''',
			new ServiceInitializerGen().generateServiceInitializer(model))

		//Generate StartWindow
//		fsa.generateFile('''«model.allEntities.head.guiPackageString.toFolderString»/StartWindowClass.java''',
//			new StartWindowGenerator().generateStartWindow(model))
	}

	def processEntity(Class clazz, IFileSystemAccess fsa) {

		//Generate Data Classes
		fsa.generateFile(
			'''«clazz.entityPackageString.toFolderString»/«clazz.name».java''',
			new DataClass().generateDataClass(clazz)
		)

		//Generate Service Classes
		fsa.generateFile(
			'''«clazz.logicPackageString.toFolderString»/«clazz.serviceClassName».java''',
			new ServiceProvider().generate(clazz)
		)

		//Generate ListWindow Classes
//		fsa.generateFile(
//			'''«clazz.guiPackageString.toFolderString»/«clazz.listWindowClassName».java''',
//			new ListWindowGenerator().generate(clazz)
//		)

		//Generate EntryWindow Classes
//		if (!clazz.abstract) {
//			fsa.generateFile(
//				'''«clazz.guiPackageString.toFolderString»/«clazz.entryWindowClassName».java''',
//				new EntryWindow().generate(clazz)
//			)
		}
	
	
	def doGenerate(CrudModel model, IFileSystemAccess fsa) {

		//val PACKAGE_DIR = PACKAGE_STRING.replace('.', File.separatorChar);
		println(
			"Window elements within the crud model: " + model.windows.join(", ", [it.name])
		)
		model.windows.filter[e| e instanceof EntryWindow].map[e| e as EntryWindow].forEach[processEntryWindow(fsa)]
		model.windows.filter[e| e instanceof ListWindow].map[e|e as ListWindow].forEach[processListWindow(fsa)]
	}
	
	def processEntryWindow(EntryWindow window, IFileSystemAccess fsa){
		fsa.generateFile(
			'''«window.guiPackageString.toFolderString»/«window.name».java''',
			new EntryWindowGenerator().doGenerate(window)
		)
	}
	
	def processListWindow(ListWindow window, IFileSystemAccess fsa){
		fsa.generateFile(
			'''«window.guiPackageString.toFolderString»/«window.name».java''',
			new ListWindowGenerator().doGenerate(window)
		)
	}
}
