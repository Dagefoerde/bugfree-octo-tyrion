package de.wwu.pi.mdsd05.framework.data;

import java.io.Serializable;

@SuppressWarnings("serial")
public abstract class AbstractDataClass extends Object implements Serializable {
	public static final int OBJ_ID_FOR_NEW_ELEMS = -1;
	int oId = OBJ_ID_FOR_NEW_ELEMS;

	public AbstractDataClass() {
		super();
	}

	public void setOId(int oId) {
		if (!isNew()) {
			throw new UnsupportedOperationException("Resetting the object ID is prohibited.");
		}
		this.oId = oId;
	}

	public int getOid() {
		return oId;
	}

	@Override
	public abstract String toString();

	public boolean isNew() {
		return oId == OBJ_ID_FOR_NEW_ELEMS;
	}

	@Override
	public boolean equals(Object other) {
		AbstractDataClass otherDataObj = null;
		if (other instanceof AbstractDataClass)
			otherDataObj = (AbstractDataClass) other;
		if (otherDataObj == null)
			return false;

		// if both are new use super equals method
		if (this.isNew() && otherDataObj.isNew())
			return super.equals(otherDataObj);

		// if at least one of both is not new, compare the OId
		if (this.getOid() == otherDataObj.getOid())
			return true;
		else
			return false;
	}
}
