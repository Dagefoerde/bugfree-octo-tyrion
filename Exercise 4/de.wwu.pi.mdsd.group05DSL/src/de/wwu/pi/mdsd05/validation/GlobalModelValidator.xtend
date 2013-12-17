package de.wwu.pi.mdsd05.validation

import de.wwu.pi.mdsd05.group05DSL.Entitytype
import de.wwu.pi.mdsd05.group05DSL.EntryWindow
import de.wwu.pi.mdsd05.group05DSL.Group05DSLPackage
import de.wwu.pi.mdsd05.group05DSL.Label
import de.wwu.pi.mdsd05.group05DSL.Model
import de.wwu.pi.mdsd05.group05DSL.Property
import de.wwu.pi.mdsd05.group05DSL.UIWindow
import org.eclipse.xtext.validation.Check

import static extension de.wwu.pi.mdsd05.helper.EntitytypeHelperMethods.*

//import org.eclipse.xtext.validation.Check
/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class GlobalModelValidator extends AbstractGroup05DSLValidator {
	
	// Global model validation -----------------------------------------------------

	@Check
	def checkMinEntityAndWindow(Model model) {
		if (model.entitytypes.size == 0 || model.uiwindows.size == 0)
			warning("At least one Entitytype and one UIWindow should be modeled.",
				Group05DSLPackage.Literals.MODEL__PACKAGE)
	}

	@Check
	def EntitytypesHaveTheSameName(Entitytype entitytype) {

		var entitytypes = (entitytype.eContainer() as Model).getEntitytypes();
		for (Entitytype e : entitytypes) {
			if (e.getName() != null && e != entitytype && e.getName().equals(entitytype.getName)) {
				error("Entitytype with the same name already exists", Group05DSLPackage.Literals.ENTITYTYPE__NAME);
			}
		}
	}

	@Check
	def PropertiesHaveTheSameName(Property property) {

		var properties = (property.eContainer() as Entitytype).allPropertiesIncludingSuperproperties;
		for (Property p : properties) {
			if (p.getName() != null && p != property && p.getName().equals(property.getName)) {
				error("A property with the same name already exists in this class or in a superclass.",
					Group05DSLPackage.Literals.PROPERTY__NAME);
			}
		}
	}

	@Check
	def LabelsHaveTheSameName(Label label) {

		var labels = (label.eContainer() as EntryWindow).getElements().filter[l|l instanceof Label].map[l|l as Label];
		for (Label l : labels) {
			if (l.getName() != null && l != label && l.getName().equals(label.getName)) {
				error("A label with the same name already exists", Group05DSLPackage.Literals.LABEL__NAME);
			}
		}
	}

	@Check
	def WindowsHaveTheSameName(UIWindow window) {

		var windows = (window.eContainer() as Model).getUiwindows();
		for (UIWindow w : windows) {
			if (w.getName() != null && w != window && w.getName().equals(window.getName)) {
				error("A window with the same name already exists", Group05DSLPackage.Literals.UI_WINDOW__NAME);
			}
		}
	}

}
