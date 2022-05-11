package member;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MemberDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public MemberDAO() {
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
	
	public int getFailCount(String id) {
		String SQL = "select fail_count from member where id = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt("fail_count");
			}
			return -1; 
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -2; 
	}
	
	public int login(String id, String pw) {
		String SQL = "select pw from member where id = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(pw)) {
					return 1; // login
				}else {
					String SQL1 = "update member set fail_count = member.fail_count+1 where id = ?";
					try {
						pstmt = conn.prepareStatement(SQL1);
						pstmt.setString(1, id);
						pstmt.executeUpdate();
					}catch (Exception e) {
						// TODO: handle exception
						e.printStackTrace();
					}
					return 0; // password incorrect
				}
			}
			return -1; // ID not exist
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -2; // DB error
	}
	
	public int join(Member mem) {
		
		String SQL = "insert into member values(?,?,?,?,?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, mem.getId());
			pstmt.setString(2, mem.getPw());
			pstmt.setString(3, mem.getName());
			pstmt.setString(4, mem.getGender());
			pstmt.setString(5, mem.getEmail());
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
		
	public Member getMember(String id) {
		String SQL = "select * from member where id = ?";
		Member mem = new Member();
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				mem.setId(rs.getString("id"));
				mem.setPw(rs.getString("pw"));
				mem.setName(rs.getString("name"));
				mem.setGender(rs.getString("gender"));
				mem.setEmail(rs.getString("email"));
			}
			return mem;
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return mem;
	}
	
	public int update(Member mem, String id) {
			
			String SQL = "update member set pw = ?, name = ?, gender = ?, email =? where id = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, mem.getPw());
				pstmt.setString(2, mem.getName());
				pstmt.setString(3, mem.getGender());
				pstmt.setString(4, mem.getEmail());
				pstmt.setString(5, id);
				return pstmt.executeUpdate();
			}catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			}
			return -1; // DB error
		}
	
	public int delete(String id) {
		
		String SQL = "delete from member where id = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, id);
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1;	
	}
}
