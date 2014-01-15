package de.wwu.pi.mdsd.umlToApp.gui

import de.wwu.pi.mdsd.crudDsl.crudDsl.CrudModel
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*

class StartWindowGenerator {
	def generateStartWindow(CrudModel model) '''
		« var packageName = model.name»
		package «packageName»;
		
		import java.awt.GridBagConstraints;
		import java.awt.Insets;
		import java.awt.event.ActionEvent;
		import java.awt.event.ActionListener;
		
		import javax.swing.JButton;
		import javax.swing.UIManager;
		import javax.swing.UnsupportedLookAndFeelException;
		
		import de.wwu.pi.mdsd.framework.gui.AbstractStartWindow;
		import «packageName».ServiceInitializer;
		
		public class StartWindowClass extends AbstractStartWindow {
		
			@Override
			protected void ListChoices() {
				«FOR window : model.windows.filter[window|window instanceof de.wwu.pi.mdsd.crudDsl.crudDsl.ListWindow].map[window|window as de.wwu.pi.mdsd.crudDsl.crudDsl.ListWindow]»
					JButton «window.name.toFirstLower» = new JButton("List «window.name.camelCaseToLabel» Elements");
					GridBagConstraints gbc_«window.name.toFirstLower» = new GridBagConstraints();
					gbc_«window.name.toFirstLower».insets = new Insets(0, 0, 5, 5);
					gbc_«window.name.toFirstLower».gridx = 1;
					gbc_«window.name.toFirstLower».gridy = getNextGridY();
					getPanel().add(«window.name.toFirstLower», gbc_«window.name.toFirstLower»);
					«window.name.toFirstLower».addActionListener(new ActionListener() {
						@Override
						public void actionPerformed(ActionEvent arg0) {
							new «window.name»(StartWindowClass.this).open();
						}
					});
				«ENDFOR»
			}
			
			@Override
			protected void closeWindow()  {
				ServiceInitializer.serialize();
				super.closeWindow();
			}
			
			public static void main(String[] args) throws ClassNotFoundException, InstantiationException, IllegalAccessException, UnsupportedLookAndFeelException {
				UIManager.setLookAndFeel(
					UIManager.getSystemLookAndFeelClassName());
					//"com.sun.java.swing.plaf.windows.WindowsLookAndFeel");
				new StartWindowClass().open();
			}
		}
	'''

	def static listButtonName(Property p) {
		"btn" + p.name.toFirstUpper + 'List'
	}
}
