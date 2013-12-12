package de.wwu.pi.mdsd.scoping;

import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.Scopes;

public class CRUDDslScopeProvider {
	/*public IScope scope_#DeclaringType#_#reference#
	(#ContextType# ctx, EReference ref) {
	Iterable<#ReferenceType#> elements = …;
	…
	return Scopes.scopeFor(elements);
	
	}*/
	
	public IScope scope_Field_property (Field ctx, EReference ref) {
		Iterable<Field> elements = ctx.getCustomer().getAddresses();
		return Scopes.scopeFor(elements);
	
	}
}
