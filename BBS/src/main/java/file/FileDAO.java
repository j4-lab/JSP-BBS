package file;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FileDAO{
	
	private Connection conn;
	private ResultSet rs;
	
	public FileDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getDate() {
		String SQL = "select now()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return ""; // DB error
	}
	
	public int upload(int board_id, String file_name) {
		String SQL = "insert into file(board_id,file_name,regdate) values (?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  board_id);
			pstmt.setString(2,  file_name);
			pstmt.setString(3,  getDate());
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public int update(int board_id, String file_name) {
		String SQL = "update file set file_name = ? where board_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, file_name);
			pstmt.setInt(2,  board_id);
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public String view(int board_id) {
		
		String SQL = "select file_name from file where board_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, board_id);
						
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return ""; // DB error
	}
	
	public boolean isExist(int board_id) {
	    String SQL = "SELECT count(*) FROM file WHERE board_id =?";
		try {
		    PreparedStatement ps = conn.prepareStatement(SQL);
		    ps.setInt(1, board_id);
		    rs = ps.executeQuery();
		    
		    if(rs.getRow()!=0) {
		    	return true;
		    }else {
		    	return false;
		    }
		}catch(Exception e) {
		    e.printStackTrace();
		}
		return false;
	}
	
	public int delete(int board_id) {
		//String SQL = "update board set bbsAvailable = 0 where board_id = ?";
		String SQL = "delete from file where board_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  board_id);
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
}