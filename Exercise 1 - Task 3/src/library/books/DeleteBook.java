package library.books;

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

public class DeleteBook extends JFrame {

	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					DeleteBook frame = new DeleteBook();
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
	public DeleteBook() {
		setTitle("Delete Book");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		GridBagLayout gbl_contentPane = new GridBagLayout();
		gbl_contentPane.columnWidths = new int[]{0, 0, 0};
		gbl_contentPane.rowHeights = new int[]{0, 0, 0, 0};
		gbl_contentPane.columnWeights = new double[]{1.0, 1.0, Double.MIN_VALUE};
		gbl_contentPane.rowWeights = new double[]{0.0, 1.0, 0.0, Double.MIN_VALUE};
		contentPane.setLayout(gbl_contentPane);
		
		JLabel lblAreYouSure = new JLabel("Are you sure you want to delete the following book?");
		GridBagConstraints gbc_lblAreYouSure = new GridBagConstraints();
		gbc_lblAreYouSure.gridwidth = 2;
		gbc_lblAreYouSure.insets = new Insets(0, 0, 5, 5);
		gbc_lblAreYouSure.gridx = 0;
		gbc_lblAreYouSure.gridy = 0;
		contentPane.add(lblAreYouSure, gbc_lblAreYouSure);
		
		JScrollPane scrollPane = new JScrollPane();
		GridBagConstraints gbc_scrollPane = new GridBagConstraints();
		gbc_scrollPane.gridwidth = 2;
		gbc_scrollPane.insets = new Insets(0, 0, 5, 5);
		gbc_scrollPane.fill = GridBagConstraints.BOTH;
		gbc_scrollPane.gridx = 0;
		gbc_scrollPane.gridy = 1;
		contentPane.add(scrollPane, gbc_scrollPane);
		
		JTextPane txtpnIsbnName = new JTextPane();
		txtpnIsbnName.setText("ISBN: ...\r\nName: ...\r\nAuthor: ...");
		scrollPane.setViewportView(txtpnIsbnName);
		txtpnIsbnName.setEditable(false);
		
		JButton btnYes = new JButton("Yes");
		GridBagConstraints gbc_btnYes = new GridBagConstraints();
		gbc_btnYes.insets = new Insets(0, 0, 0, 5);
		gbc_btnYes.gridx = 0;
		gbc_btnYes.gridy = 2;
		contentPane.add(btnYes, gbc_btnYes);
		
		JButton btnNo = new JButton("No");
		GridBagConstraints gbc_btnNo = new GridBagConstraints();
		gbc_btnNo.gridx = 1;
		gbc_btnNo.gridy = 2;
		contentPane.add(btnNo, gbc_btnNo);
	}

}
