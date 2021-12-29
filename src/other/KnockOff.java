class KnockOff {
    // Replaces all words initiated with ‘F’ with "CRAB"
    private String sentence;
    protected String replacement = "CRAB";
    public KnockOff(String s){
	this.sentence = s;
    }
    public String getPurified(){
	class worker {
	    public  char[] ca = sentence.toCharArray();
	    public  boolean isLetter(Integer i){
		if (i >= sentence.length()) return false;
		else return ('A' <= ca[i] && ca[i] <= 'z');
	    }
	    public boolean isObscene(Integer i){
		if (i >= sentence.length()) return false;
		else if (ca[i] == 'f' || ca[i] == 'F') {
		    // System.out.println(i + " ++> \t" + sentence.substring(i));
		    return true;
		}
		else {
		    // System.out.println(i + " --> \t" + sentence.substring(i));
		    return false;
		}
	    }
	    public  Integer findWord(Integer i){
		if (i >= sentence.length())
		    return sentence.length();
		else if (isLetter(i)) return i;
		else return findWord(i + 1);
	    }
	    public Integer jumpWord(Integer i) {
		if (i >= sentence.length())
		    return sentence.length();
		else if (! isLetter(i)) return i;
		else return jumpWord(i + 1);
	    }

	    public String getFrom(Integer i, String res){
		//		System.out.println(i + " \t"  + res); 
		Integer j  = findWord(i);
		String res1 = res + sentence.substring(i, j), rp = replacement;
		Integer k = jumpWord(j);
		if (! isObscene(j)) {
		    rp = sentence.substring(j, k);
		}
		String res2 = res1 + rp;
		if (k >= sentence.length()) return res2;
		else  return getFrom(k, res2);
	    }
	}
	worker wk = new worker();
	return wk.getFrom(0, "");
    }
    public static void main(String[] args){
	KnockOff obj = new KnockOff("12345 -> - - - > Therefore the beautiful Fox finally found some fascinate fungus in the forest.");
	System.out.println(obj.getPurified());
    }
    
}
