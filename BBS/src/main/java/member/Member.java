package member;

public class Member {
	
	private String id;
	private String pw;
	private String name;
	private String gender;
	private String email;
	private int fail_count;
	
	public int getFail_count() {
		return fail_count;
	}
	public void setFail_count(int fail_count) {
		this.fail_count = fail_count;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
}
