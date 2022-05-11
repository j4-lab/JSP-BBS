package session;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


public class SessionDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public SessionDAO() {
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
	
	public int getSessionIndex() {
		String SQL = "select session_index from session order by session_index desc limit 1";
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				return rs.getInt("session_index");
			}
			return -1;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;
	}
	
	public int update(String session_key) {
		// session 테이블에 활성화되어있는 멤버 세션이 있는지 count
		String SQL = "select count(*) from session where session_key = ? and session_type = 'A'";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  session_key);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				// 활성되외어있는 멤버 세션이 있으면 비활성화
				if(rs.getInt(1)>0) {
					String SQL1 = "update session set session_type = 'B' where session_key = ? and session_type = 'A'";
					try {
						pstmt = conn.prepareStatement(SQL1);
						pstmt.setString(1, session_key);
						pstmt.executeUpdate();
					}catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
				}
				
				String SQL2 = "insert into session(session_key,session_type) values(?,?)";
				try {
					pstmt = conn.prepareStatement(SQL2);
					pstmt.setString(1, session_key);
					pstmt.setString(2, "A");
					return pstmt.executeUpdate();
				}catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				return 1; // ok
			}
			return -1; // ID not exist
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -2; // DB error
	}
	
	public int logoutSession(int session_index) {
		String SQL = "update session set session_type = 'B' where session_index = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, session_index);
			pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -2; // DB error
	}
	
	public String check(int session_index) {
		String SQL = "select session_type from session where session_index = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  session_index);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);				
			}
			return ""; // ID not exist
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return ""; // DB error
	}
}
