package de.wwu.pi.mdsd.umlToApp.logic

import org.eclipse.uml2.uml.Class

import static de.wwu.pi.mdsd.umlToApp.util.ModelAndPackageHelper.*

class ServiceInitializerGenerator {
	def generateServiceInitializer(Iterable<Class> entities) '''
package «PACKAGE_STRING».logic;

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
	
	«FOR clazz : entities»
	private «clazz.name»Service «clazz.name»Service;
	«ENDFOR»
	
	private ServiceInitializer() {
		super();
		«FOR clazz : entities»
		this.«clazz.name»Service = new «clazz.name»Service();
		«ENDFOR»
	}
	
	«FOR clazz : entities»
	public «clazz.name»Service get«clazz.name.toFirstUpper»Service() {
		return «clazz.name»Service;
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


	

