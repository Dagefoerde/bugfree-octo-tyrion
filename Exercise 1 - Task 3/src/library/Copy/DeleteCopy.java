package library.Copy;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Insets;
import javax.swing.JTextPane;
import javax.swing.JScrollPane;
import javax.swing.JButton;

public class DeleteCopy extends JFrame {

	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					DeleteCopy frame = new DeleteCopy();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public DeleteCopy() {
		setTitle("Delete Copy");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		GridBagLayout gbl_contentPane = new GridBagLayout();
		gbl_contentPane.columnWidths = new int[]{0, 0, 0};
		gbl_contentPane.rowHeights = new int[]{0, 0, 0};
		gbl_contentPane.columnWeights = new double[]{1.0, 1.0, Double.MIN_VALUE};
		gbl_contentPane.rowWeights = new double[]{1.0, 1.0, Double.MIN_VALUE};
		contentPane.setLayout(gbl_contentPane);
		
		JLabel lblAreYouSure = new JLabel("Are you sure you want to delete this Copy?");
		GridBagConstraints gbc_lblAreYouSure = new GridBagConstraints();
		gbc_lblAreYouSure.gridwidth = 2;
		gbc_lblAreYouSure.insets = new Insets(0, 0, 5, 0);
		gbc_lblAreYouSure.gridx = 0;
		gbc_lblAreYouSure.gridy = 0;
		contentPane.add(lblAreYouSure, gbc_lblAreYouSure);
		
		JButton btnYes = new JButton("Yes");
		GridBagConstraints gbc_btnYes = new GridBagConstraints();
		gbc_btnYes.insets = new Insets(0, 0, 0, 5);
		gbc_btnYes.gridx = 0;
		gbc_btnYes.gridy = 1;
		contentPane.add(btnYes, gbc_btnYes);
		
		JButton btnNo = new JButton("No");
		GridBagConstraints gbc_btnNo = new GridBagConstraints();
		gbc_btnNo.gridx = 1;
		gbc_btnNo.gridy = 1;
		contentPane.add(btnNo, gbc_btnNo);
	}

}
