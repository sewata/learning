import java.io.*;
import java.util.*;

class Tree {
	private static PrintWriter pw;
	private static Branch[] branchList = new Branch[10];
	private static Stack<Character> parentStack = new Stack<Character>();

	public static void main(String[] args) throws IOException {
		for (int i = 0; i < branchList.length; i++) {
			branchList[i] = new Branch();
		}
		branchList[0].setValues('A', 'G', 'A', 'C', 'D', 'H');
		branchList[1].setValues('B', 'J', 'E', 'E', 'I', 'J');
		branchList[2].setValues('C', 'I', 'D', 'C', 'G', 'H');
		branchList[3].setValues('D', 'E', 'C', 'A', 'A', 'G');
		branchList[4].setValues('E', 'F', 'H', 'J', 'C', 'B');
		branchList[5].setValues('F', 'H', 'G', 'E', 'F', 'E');
		branchList[6].setValues('G', 'F', 'G', 'D', 'B', 'E');
		branchList[7].setValues('H', 'E', 'A', 'I', 'E', 'G');
		branchList[8].setValues('I', 'H', 'D', 'D', 'D', 'D');
		branchList[9].setValues('J', 'F', 'B', 'C', 'A', 'H');
		
		for (int i = 0; i < branchList.length; i++) {
			char root = branchList[i].getParent();
			pw = new PrintWriter(new BufferedWriter(new FileWriter("Tree" + root + ".txt")));
			pw.println(root);
			parentStack.push(root);
			grow(root, 1);
			parentStack.pop();
			pw.close();
		}
	}
	
	private static void grow(char node, int level) {
		
		/* child[]を入れる配列 */
		char ary[] = new char[5];
		
		/* nodeがparentとなっているbranchListのインデックスを得て、そのchild[]を得る */
		for (int i = 0; i < branchList.length; i++) {
			char tmp = branchList[i].getParent();
			if (tmp == node) {
				ary = branchList[i].getChild();
				break;
			}
		}
		
		/* 得た5つのchild[]全てにこのforブロックの処理をする */
		for (int i = 0; i < ary.length; i++) {
			/* level分の半角スペースを出力 */
			for (int j = level; j > 0; j--) {
				pw.print(" ");
			}
			
			/* childを出力 */
			pw.println(ary[i]);
			
			/* 再出現のルールに従い、スタックに存在しない文字ならば
			   スタックに格納し、その文字を引数としてgrowを呼ぶ
			   ※スタックに存在するしないの判定は、searchメソッドを利用する
			   （引数がスタックに存在しない場合、-1を戻り値とするメソッド）
			   なお、growを再帰的に呼ぶ際に、
			   カレントのlevelの値を変更しないよう（level + 1）として呼ぶ   */
			if (parentStack.search(ary[i]) < 0) {
				parentStack.push(ary[i]);
				grow(ary[i], (level + 1));
			}
		}
		
		/* levelは10,9,8...3,2,1の順で処理が完了していくので
		   ここにlevel1が到達するのは全ての処理を終えたときとなる
		   次のrootに備えてparentStackからroot以外を空にする
		   文字の種類はrootを除くと9種類なので9回popする          */
		if (level == 1) {
			for (int i = 0; i < 9; i++) {
				parentStack.pop();
			}
		}
	}
}
