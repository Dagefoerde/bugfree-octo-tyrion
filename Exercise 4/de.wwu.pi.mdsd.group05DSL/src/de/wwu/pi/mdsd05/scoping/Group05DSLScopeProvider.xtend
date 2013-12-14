/*
 * generated by Xtext
 */
package de.wwu.pi.mdsd05.scoping

import org.eclipse.xtext.scoping.IScope
import de.wwu.pi.mdsd05.group05DSL.Field
import de.wwu.pi.mdsd05.group05DSL.EntryWindow
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.Scopes

/**
 * This class contains custom scoping description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#scoping
 * on how and when to use it 
 *
 */
class Group05DSLScopeProvider extends org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider {

	
	def IScope scope_Field_property(Field ctx, EReference ref) {
		val elements = (ctx.eContainer() as EntryWindow).getEntitytype().getProperties();
		// TODO: supertype properties!
		return Scopes.scopeFor(elements);
	}
}
