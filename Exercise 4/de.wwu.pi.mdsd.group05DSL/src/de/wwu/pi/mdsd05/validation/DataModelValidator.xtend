package de.wwu.pi.mdsd05.validation

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import de.wwu.pi.mdsd05.group05DSL.Group05DSLPackage
import de.wwu.pi.mdsd05.group05DSL.Reference
import org.eclipse.xtext.validation.Check

import static extension de.wwu.pi.mdsd05.helper.EntitytypeHelperMethods.*

//import org.eclipse.xtext.validation.Check
/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class DataModelValidator extends AbstractGroup05DSLValidator {
	
	// Data model validation -------------------------------------------------------

	@Check
	def public void checkAbtractFeatures(Entitytype entitytype) {
		if (entitytype.abstract != null && !entitytype.isSuperClassAnywhere) {
			error("Class " + entitytype.name + " has no subclass and may therefore not be abstract.",
				Group05DSLPackage.Literals.ENTITYTYPE__ABSTRACT);
		}

	}
	
	@Check
	def checkReference(Reference reference) {
		val entity = (reference.eContainer as Entitytype)
		//Assumption: A case, where one entity references another entity twice with the same multiplicity, cannot be handled by automatic code generation, 
		//since a distinct linking of a reference and its opposite reference is not possible.
		if (reference.hasDoubleReference){
			error(entity.name + " has two references with the same multiplicity to " + reference.references.name +". A distinction among the opposite references is not possible.", reference,
				Group05DSLPackage.Literals.REFERENCE__REFERENCES)
		}
		if (reference.hasWrongOppositeReference){
			error(entity.name + " is not correctly referenced. Check for opposite reference in " + reference.references.name +".", reference,
				Group05DSLPackage.Literals.REFERENCE__REFERENCES)
				}
		if (reference.referencesItself){
			warning(entity.name + " references itself.", reference, Group05DSLPackage.Literals.REFERENCE__REFERENCES)
			}
		if (reference.referencesSubOrSuperclass){
			warning(entity.name + " references a subclass or superclass", reference, Group05DSLPackage.Literals.REFERENCE__REFERENCES)
		}
	}	

	@Check
	def checkCyclicInheritance(Entitytype entity) {
		if (entity.hasCyclicInheritance)
			error("Cyclic inheritance is not allowed", entity, Group05DSLPackage.Literals.ENTITYTYPE__NAME);
	}
	
}
