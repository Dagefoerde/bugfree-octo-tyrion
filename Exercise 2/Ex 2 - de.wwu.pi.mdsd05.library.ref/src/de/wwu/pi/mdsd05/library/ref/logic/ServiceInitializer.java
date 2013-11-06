package de.wwu.pi.mdsd05.library.ref.logic;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;

public class ServiceInitializer implements Serializable {
	private static final long serialVersionUID = 4083901003693858998L;

	private static String filename = "MDSD-DataProv.dat";
	
	private static ServiceInitializer provider;
	
	public static ServiceInitializer getProvider() {
		if(provider == null && !deserialize())
			provider = new ServiceInitializer();
		return provider;
	}
	
	private UserService userService;

	private ServiceInitializer() {
		super();
		userService = new UserService();
	}
	
	public UserService getUserService() {
		if(userService == null)
			userService = new UserService();
		return userService;
	}
	
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
