package de.wwu.pi.mdsd.umlToApp.logic

import org.eclipse.uml2.uml.Model

import static extension de.wwu.pi.mdsd.umlToApp.util.ClassHelper.*
import static extension de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class ServiceInitializerGen {

	def generateServiceInitializer(Model model) '''
		« var anyEntityclass = model.allEntities.last»
		package «anyEntityclass.logicPackageString»;
		
		import java.io.File;
		import java.io.FileInputStream;
		import java.io.FileOutputStream;
		import java.io.ObjectInputStream;
		import java.io.ObjectOutputStream;
		import java.io.Serializable;
		
		import de.wwu.pi.mdsd.framework.logic.AbstractServiceProvider;
		
		public class ServiceInitializer implements Serializable {
			private static String filename = "MDSD-DataProv.dat";
			
			private static ServiceInitializer provider;
			
			public static ServiceInitializer getProvider() {
				if(provider == null && !deserialize())
					provider = new ServiceInitializer();
				return provider;
			}
			
			«FOR clazz : model.allEntities»
			private «clazz.serviceClassName» «clazz.serviceClassName.toFirstLower»;
			«ENDFOR»
			
			private ServiceInitializer() {
				super();
				«FOR clazz : model.allEntities»
					«clazz.serviceClassName.toFirstLower» = new «clazz.serviceClassName»();
				«ENDFOR»
			}
			
			«FOR clazz : model.allEntities»
				public «clazz.serviceClassName» get«clazz.serviceClassName»() {
					return «clazz.serviceClassName.toFirstLower»;
				}
			«ENDFOR»
			
			private static boolean deserialize() {
				try {
					System.out.println("Trying to read following file:" + new File(filename).getAbsolutePath());
					ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename));
					provider = (ServiceInitializer) ois.readObject();
					AbstractServiceProvider.deserialize(ois.readInt());
					ois.close();
					System.out.println("Deserialization completed");
					return true;
				} catch (Exception e) {
					System.out.println("Deserialization failed: " + e.getMessage());
					provider = new ServiceInitializer();
					return false;
				}
			}
		
			public static void serialize() {
				try {
					ObjectOutputStream oos = new ObjectOutputStream( new FileOutputStream(filename));
					oos.writeObject(provider);
					oos.writeInt(AbstractServiceProvider.serialize());
					oos.close();
					System.out.println("Serialization completed");
				} catch (Exception e) {
					System.out.println("Serialization failed: " + e.getMessage());
				}
			}
		}
		'''	
}