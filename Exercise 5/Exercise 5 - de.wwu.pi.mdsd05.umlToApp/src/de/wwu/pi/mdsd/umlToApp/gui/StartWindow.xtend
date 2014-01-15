package de.wwu.pi.mdsd.umlToApp.gui

import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.GUIHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class StartWindow {
	def generateStartWindow(Model model) '''
		« var anyEntityclass = model.allEntities.last»
		package «anyEntityclass.guiPackageString»;
		
		import java.awt.GridBagConstraints;
		import java.awt.Insets;
		import java.awt.event.ActionEvent;
		import java.awt.event.ActionListener;
		
		import javax.swing.JButton;
		import javax.swing.UIManager;
		import javax.swing.UnsupportedLookAndFeelException;
		
		import de.wwu.pi.mdsd.framework.gui.AbstractStartWindow;
		import «anyEntityclass.logicPackageString».ServiceInitializer;
		
		public class StartWindowClass extends AbstractStartWindow {
		
			@Override
			protected void ListChoices() {
				«FOR entity : model.allEntities»
					JButton «entity.listWindowClassName.toFirstLower» = new JButton("List «entity.name.camelCaseToLabel» Elements");
					GridBagConstraints gbc_«entity.listWindowClassName.toFirstLower» = new GridBagConstraints();
					gbc_«entity.listWindowClassName.toFirstLower».insets = new Insets(0, 0, 5, 5);
					gbc_«entity.listWindowClassName.toFirstLower».gridx = 1;
					gbc_«entity.listWindowClassName.toFirstLower».gridy = getNextGridY();
					getPanel().add(«entity.listWindowClassName.toFirstLower», gbc_«entity.listWindowClassName.toFirstLower»);
					«entity.listWindowClassName.toFirstLower».addActionListener(new ActionListener() {
						@Override
						public void actionPerformed(ActionEvent arg0) {
							new «entity.listWindowClassName»(StartWindowClass.this).open();
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
