package de.wwu.pi.mdsd05.scoping;

import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.Scopes;

import de.wwu.pi.mdsd05.group05DSL.EntryWindow;
import de.wwu.pi.mdsd05.group05DSL.Field;
import de.wwu.pi.mdsd05.group05DSL.Property;

public class ScopeProvider {
	/*public IScope scope_#DeclaringType#_#reference#
	(#ContextType# ctx, EReference ref) {
	Iterable<#ReferenceType#> elements = …;
	…
	return Scopes.scopeFor(elements);
	
	}*/
	
	public IScope scope_Field_property(Field ctx, EReference ref) {
		Iterable<Property> elements = ((EntryWindow)ctx.eContainer()).getEntitytype().getProperties();
		return Scopes.scopeFor(elements);
	}
}
