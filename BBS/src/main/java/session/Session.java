package session;

public class Session {
	private String session_key;
	private String member_id;
	private String session_type;
	public String getSession_key() {
		return session_key;
	}
	public void setSession_key(String session_key) {
		this.session_key = session_key;
	}
	public String getMember_id() {
		return member_id;
	}
	public void setMember_id(String member_id) {
		this.member_id = member_id;
	}
	public String getSession_type() {
		return session_type;
	}
	public void setSession_type(String session_type) {
		this.session_type = session_type;
	}
}
