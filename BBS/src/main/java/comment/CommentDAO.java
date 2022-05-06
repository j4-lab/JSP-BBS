package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CommentDAO{
	
	private Connection conn;
	private ResultSet rs;
	
	public CommentDAO() {
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
	
	public ArrayList<Comment> getList(int board_id,int commentNumber){
		//String SQL="SELECT * FROM comment WHERE comment_id<? AND board_id=? ORDER BY comment_id DESC LIMIT 10";
		String SQL = "select * from comment where board_id = ? order by comment_id desc limit ?,10";
		ArrayList<Comment> list=new ArrayList<Comment>();
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, board_id);
			pstmt.setInt(2,(commentNumber-1)*10);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				Comment comment=new Comment();
				comment.setComment_id(rs.getInt(1));
				comment.setBoard_id(rs.getInt(2));
				comment.setWriter(rs.getString(3));
				comment.setContent(rs.getString(4));
				comment.setRegdate(rs.getString(5));
				
				list.add(comment);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<Comment> getListAll(int board_id,int commentNumber){
		//String SQL="SELECT * FROM comment WHERE comment_id<? AND board_id=? ORDER BY comment_id DESC LIMIT 10";
		String SQL = "select * from comment where board_id = ? order by comment_id desc";
		ArrayList<Comment> list=new ArrayList<Comment>();
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, board_id);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				Comment comment=new Comment();
				comment.setComment_id(rs.getInt(1));
				comment.setBoard_id(rs.getInt(2));
				comment.setWriter(rs.getString(3));
				comment.setContent(rs.getString(4));
				comment.setRegdate(rs.getString(5));
				
				list.add(comment);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int getNext() {
		String SQL="select comment_id FROM comment ORDER BY comment_id DESC";
		try {
		
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				//System.out.println(rs.getInt(1)); // select문에서 첫번째 값
				return rs.getInt(1)+1;  // 현재 인덱스(현재 게시글 개수) +1 반환
			}
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	public int write(int board_id,String content,String writer) {
		String SQL="INSERT INTO comment(board_id,writer,content,regdate) VALUES(?,?,?,?)";
		
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, board_id);
			pstmt.setString(2,writer);
			pstmt.setString(3, content);
			pstmt.setString(4, getDate());
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public boolean isExist(int comment_id) {
	    String SQL = "SELECT count(*) FROM comment WHERE comment_id =?";
		try {
		    PreparedStatement ps = conn.prepareStatement(SQL);
		    ps.setInt(1, comment_id);
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
	
	public int delete(int comment_id) {
		//String SQL = "update board set bbsAvailable = 0 where board_id = ?";
		String SQL = "delete from comment where comment_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  comment_id);
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public int countData(int board_id) {
		String SQL = "select count(*) from comment where board_id = ?";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  board_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				int i = rs.getInt(1);
				return i;
			}
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return 0;
	}
}