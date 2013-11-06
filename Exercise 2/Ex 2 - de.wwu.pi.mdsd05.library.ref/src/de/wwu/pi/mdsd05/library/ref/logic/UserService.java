package de.wwu.pi.mdsd05.library.ref.logic;

import de.wwu.pi.mdsd05.framework.logic.AbstractServiceProvider;
import de.wwu.pi.mdsd05.framework.logic.ValidationException;
import de.wwu.pi.mdsd05.library.ref.data.User;

public class UserService extends AbstractServiceProvider<User> {
	
	//Constructor
	protected UserService() {
		super();
	}

	public boolean validateUser(String name, String address) throws ValidationException {
		if(name == null)
			throw new ValidationException("name", "cannot be empty");
		if(address == null)
			throw new ValidationException("address", "cannot be empty");
		return true;
	}
	
	public User saveUser(int id,String name, String address) {
	User elem = getByOId(id);
	if(elem == null)
		elem = new User();
	elem.setName(name);
	elem.setAddress(address);
	persist(elem);
	return elem;
	}
	
}
