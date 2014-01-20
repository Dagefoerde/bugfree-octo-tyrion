package de.wwu.pi.mdsd05.framework.logic;

import java.io.Serializable;
import java.util.Collection;
import java.util.LinkedList;

import de.wwu.pi.mdsd05.framework.data.AbstractDataClass;

@SuppressWarnings("serial")
public abstract class AbstractServiceProvider<A extends AbstractDataClass> implements Serializable {
	private static int oid_counter;
	
	protected Collection<A> list;
	
	public AbstractServiceProvider() {
		super();
		list = new LinkedList<>();
	}
	
	protected int getNewOId() {
		return ++oid_counter;
	}

	public void persist(A current) {
		if (current.isNew()) {
			int oId = getNewOId();
			current.setOId(oId);
			list.add(current);
			System.out.println("Created: [" + current.getOid() + "] " + current.toString());
		}
		//@TODO persist action	
	}
	public Collection<A> getAll() {
		return list;
	}
	
	public A getByOId(int id) {
		for(A elem: list)
			if(elem.getOid() == id)
				return elem;
		//if id is not found
		return null;
	}
	
	public static Integer serialize() {
		return oid_counter;
	}
	public static void deserialize(Integer oid_counter) {
		AbstractServiceProvider.oid_counter = oid_counter;
	}
}
