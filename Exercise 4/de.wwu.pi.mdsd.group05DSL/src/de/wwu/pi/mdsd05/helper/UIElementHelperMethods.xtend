package de.wwu.pi.mdsd05.helper

import de.wwu.pi.mdsd05.group05DSL.UIElement

class UIElementHelperMethods {
	

	def static overlapping(UIElement element, UIElement element2) {
		val x = element2.getUiOptions().getPosition().getX();
		val y = element2.getUiOptions().getPosition().getY();
		val width = element2.getUiOptions().getSize().getWidth();
		val height = element2.getUiOptions().getSize().getHeight();

		if(pointInWindow(element, x, y)) return true;
		if(pointInWindow(element, x + width, y)) return true;
		if(pointInWindow(element, x, y + height)) return true;
		if(pointInWindow(element, x + width, y + height)) return true;
		return false
	}

	def static pointInWindow(UIElement element, Integer x, Integer y) {
		val xElement = element.getUiOptions().getPosition().getX();
		val yElement = element.getUiOptions().getPosition().getY();
		val width = element.getUiOptions().getSize().getWidth();
		val height = element.getUiOptions().getSize().getHeight();
		if((xElement <= x && (xElement + width) >= x) && (yElement <= y && (y + height) >= yElement)) return true;
		return false
	}

}
