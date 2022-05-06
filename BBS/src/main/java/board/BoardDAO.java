package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BoardDAO {

	private Connection conn;
	private ResultSet rs;
	
	public BoardDAO() {
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
	
	public int getID() {
		String SQL = "select board_id from board order by board_id desc limit 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
			return 1; // 첫번째 게시글인 경우
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public int getNext() {
		String SQL = "select board_id from board order by board_id desc";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)+1;
			}
			return 1; // 첫번째 게시글인 경우
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public int write(String writer, String title, String content, boolean secret, String secret_key) {
		String SQL = "insert into board(writer,title,content,regdate,secret,secret_key) values (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  writer);
			pstmt.setString(2,  title);
			pstmt.setString(3,  content);
			pstmt.setString(4,  getDate());
			pstmt.setBoolean(5, secret);
			pstmt.setString(6, secret_key);
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public ArrayList<Board> getList(int pageNumber){
		
		String SQL = "select * from board order by board_id desc limit ?,10";
		ArrayList<Board> list = new ArrayList<Board>();
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber-1)*10);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				Board board = new Board();
				board.setBoard_id(rs.getInt(1));
				board.setWriter(rs.getString(2));
				board.setTitle(rs.getString(3));
				board.setContent(rs.getString(4));
				board.setRegdate(rs.getString(5));
				board.setDeletedate(null);
				board.setSecret(rs.getBoolean(7));
				board.setSecret_key(rs.getString(8));

				list.add(board);
			}
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return list;
	}
	
	public ArrayList<Board> getSearchList(int pageNumber, String searchSelect, String searchText){
	
	String SQL = "select * from board where " + searchSelect.trim();
	
	ArrayList<Board> list = new ArrayList<Board>();
	
	try {
		
		SQL += " LIKE '%"+searchText.trim()+"%' order by board_id desc limit ?,10";
	
		PreparedStatement pstmt = conn.prepareStatement(SQL);
		pstmt.setInt(1, (pageNumber-1)*10);
		rs = pstmt.executeQuery();
		
		while(rs.next()) {
			Board board = new Board();
			board.setBoard_id(rs.getInt(1));
			board.setWriter(rs.getString(2));
			board.setTitle(rs.getString(3));
			board.setContent(rs.getString(4));
			board.setRegdate(rs.getString(5));
			board.setDeletedate(null);
			board.setSecret(rs.getBoolean(7));
			board.setSecret_key(rs.getString(8));
			list.add(board);
		}
	}catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}
	return list;
	}
	
	public int searchCountData(String searchSelect, String searchText) {
		String SQL = "select count(*) from board where " + searchSelect.trim();
		
		try {
			SQL += " LIKE '%"+searchText.trim()+"%'";
			
			PreparedStatement pstmt = conn.prepareStatement(SQL);
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

	public boolean searchNextPage(int pageNumber) {
	String SQL = "select * from board where board_id < ? order by board_id desc limit 10";
	
	try {
		PreparedStatement pstmt = conn.prepareStatement(SQL);
		pstmt.setInt(1, getID()-(pageNumber-1)*10);
		rs = pstmt.executeQuery();
		
		if(rs.next()) {
			return true;
		}
	}catch (Exception e) {
		// TODO: handle exception
		e.printStackTrace();
	}
	return false;
}
	
	public int countData() {
		String SQL = "select count(*) from board";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
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
	
	public boolean nextPage(int pageNumber) {
		String SQL = "select * from board where board_id < ? order by board_id desc limit 10";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return true;
			}
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return false;
	}

	public Board getBoard(int board_id) {
	    String SQL = "SELECT * FROM board WHERE board_id =?";
		try {
		    PreparedStatement ps = conn.prepareStatement(SQL);
		    ps.setInt(1, board_id);
		    rs = ps.executeQuery();
		    while(rs.next()) { 
			Board board = new Board(); //rs를 받아와 board클래스 set
			board.setBoard_id(rs.getInt(1));
			board.setWriter(rs.getString(2));
			board.setTitle(rs.getString(3));
			board.setContent(rs.getString(4));
			board.setRegdate(rs.getString(5));
			board.setDeletedate(rs.getString(6));
			board.setSecret(rs.getBoolean(7));
			board.setSecret_key(rs.getString(8));
			return board;
		    }
		}catch(Exception e) {
		    e.printStackTrace();
		}
		return null;
	}

	public int update(int board_id, String title, String content, boolean secret, String secret_key) {
		String SQL = "update board set title = ?, content = ?, secret=?, secret_key=? where board_id = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1,  title);
			pstmt.setString(2,  content);
			pstmt.setBoolean(3, secret);
			pstmt.setString(4, secret_key);
			pstmt.setInt(5, board_id);
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return -1; // DB error
	}
	
	public int delete(int board_id) {
		//String SQL = "update board set bbsAvailable = 0 where board_id = ?";
		String SQL = "delete from board where board_id = ?";
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
	
	public int check(int board_id, String secret_key) {
		String SQL = "select * from board where board_id = ?";
		try {
		    PreparedStatement ps = conn.prepareStatement(SQL);
		    ps.setInt(1, board_id);
		    		    
		    rs = ps.executeQuery();
		    
		    while(rs.next()) { 
				Board board = new Board(); //rs를 받아와 board클래스 set
				board.setBoard_id(rs.getInt(1));
				board.setWriter(rs.getString(2));
				board.setTitle(rs.getString(3));
				board.setContent(rs.getString(4));
				board.setRegdate(rs.getString(5));
				board.setDeletedate(rs.getString(6));
				board.setSecret(rs.getBoolean(7));
				board.setSecret_key(rs.getString(8));
				
				if(board.getSecret_key().equals(secret_key))
				{
					return 1;
				}else
					return 0;
		    }
		}catch(Exception e) {
		    e.printStackTrace();
		}
		return -1;
	}
	
}
