package de.wwu.pi.mdsd.umlToApp.workflow;

import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.xtext.generator.IGenerator;

import de.wwu.pi.mdsd.crudDsl.CrudDslRuntimeModule;
import de.wwu.pi.mdsd.umlToApp.UmlToAppGenerator;

public class UmlToAppGeneratorModule extends CrudDslRuntimeModule {
	
	public Class<? extends IGenerator> bindIGenerator() {
		return UmlToAppGenerator.class;
	}
	
	public Class<? extends ResourceSet> bindResourceSet() {
		return ResourceSetImpl.class;
	}

}
