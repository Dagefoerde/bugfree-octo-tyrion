package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.UIElement

class UIElementHelperMethods {
	
	//Assumption: x and y coordinates define the left upper corner of an UIelement
	def static overlapping(UIElement element, UIElement element2) {
		val options1 = element.uiOptions;
		val options2 = element2.uiOptions;
		
		// case 1: element is left to element2
		if (options1.position.x + options1.size.width < options2.position.x) {
			return false;
		}
		
		// case 2: element is above element2
		if (options1.position.y + options1.size.height < options2.position.y) {
			return false;
		}
		
		// case 3: element is below element2
		if (options2.position.y + options2.size.height < options1.position.y) {
			return false;
		}
		
		// case 4: element is right to element2
		if (options2.position.x + options2.size.width < options1.position.x) {
			return false;
		}
		
		// all other cases are overlaps.
		return true;
	}

}
