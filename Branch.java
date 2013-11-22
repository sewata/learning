class Branch {
	private char parent;
	private char[] child = new char[5];
	
	public void setValues(char pa, char c1, char c2, char c3, char c4, char c5) {
		parent = pa;
		child[0] = c1;
		child[1] = c2;
		child[2] = c3;
		child[3] = c4;
		child[4] = c5;
	}

	public char getParent() {
		return parent;
	}
	
	public char[] getChild() {
		return child;
	}
}
