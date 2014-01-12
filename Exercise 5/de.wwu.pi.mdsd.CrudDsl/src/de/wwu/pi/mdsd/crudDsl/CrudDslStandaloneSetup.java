
package de.wwu.pi.mdsd.crudDsl;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class CrudDslStandaloneSetup extends CrudDslStandaloneSetupGenerated{

	public static void doSetup() {
		new CrudDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

