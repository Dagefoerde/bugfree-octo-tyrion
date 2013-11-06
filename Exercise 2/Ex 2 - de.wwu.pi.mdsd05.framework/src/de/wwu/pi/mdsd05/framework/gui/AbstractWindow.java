package de.wwu.pi.mdsd05.framework.gui;

import java.awt.Component;
import java.awt.Container;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;

import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JScrollPane;

public abstract class AbstractWindow {

	private JFrame frame;
	private AbstractWindow parent;
	private Container panel;

	public AbstractWindow(AbstractWindow parent) {
		super();
		this.parent = parent;
	}

	/**
	 * Open the window.
	 */
	public void open() {
		frame = new JFrame();
		frame.setBounds(100, 100, 450, 400);
		if (parent == null)
			frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		else
			frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		frame.setTitle(getTitle());
		frame.setResizable(false);

		frame.getContentPane().setLayout(new GridBagLayout());

		GridBagConstraints gbc_frame = new GridBagConstraints();
		gbc_frame.fill = GridBagConstraints.BOTH;
		gbc_frame.insets = new Insets(5, 5, 5, 5);
		gbc_frame.weightx = gbc_frame.weighty = 1;
		panel = new OwnContainer();
		frame.getContentPane().add(panel, gbc_frame);

		this.createContents();
		frame.addWindowListener(new WindowListener() {

			@Override
			public void windowOpened(WindowEvent arg0) {
				setParentVisible(false);
			}

			@Override
			public void windowIconified(WindowEvent arg0) {
			}

			@Override
			public void windowDeiconified(WindowEvent arg0) {
			}

			@Override
			public void windowDeactivated(WindowEvent arg0) {
			}

			@Override
			public void windowClosing(WindowEvent arg0) {
				closeWindow();
			}

			@Override
			public void windowClosed(WindowEvent arg0) {
			}

			@Override
			public void windowActivated(WindowEvent arg0) {
			}
		});

		frame.setVisible(true);

	}
	
	protected void closeWindow() {
		frame.dispose();
		setParentVisible(true);
	}
	private void setParentVisible(boolean visible) {
		if(parent != null)
			parent.frame.setVisible(visible);
	}

	protected AbstractWindow getParent() {
		return parent;
	}
	protected Container getPanel() {
		return panel;
	}

	protected abstract void createContents();

	protected abstract String getTitle();

	/**
	 * Own container class that is subclass of Container and enhances the add method to wrap certain elements with e.g. a JScrollPane.
	 * @author cl-a.us
	 *
	 */
	private class OwnContainer extends Container {
		public void add(Component component, Object obj) {
			if (component instanceof JList)
				component = new JScrollPane(component);
			super.add(component, obj);
		}
	}
}
